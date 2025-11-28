#!/bin/sh
set -e

# This script creates pull requests from a selected branch to multiple base branches
# and generates a summary with PR links that can be copied to clipboard.

# Enable debug mode if DEBUG=1 is set
DEBUG=${DEBUG:-0}

debug_echo() {
    if [ "$DEBUG" = "1" ]; then
        echo "DEBUG: $*" >&2
    fi
}

# Cross-platform timeout function
run_with_timeout() {
    TIMEOUT_SECONDS="$1"
    shift
    
    if command -v timeout >/dev/null 2>&1; then
        # GNU timeout (Linux)
        timeout "$TIMEOUT_SECONDS" "$@"
    elif command -v gtimeout >/dev/null 2>&1; then
        # GNU timeout via Homebrew (macOS)
        gtimeout "$TIMEOUT_SECONDS" "$@"
    else
        # Fallback: no timeout (just run the command)
        debug_echo "No timeout command available, running without timeout"
        "$@"
    fi
}

echo "Welcome to Branch Summary Generator"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Check if gh CLI is available
if ! command -v gh > /dev/null 2>&1; then
    echo "Error: GitHub CLI (gh) is not installed"
    echo "Please install it with: brew install gh"
    exit 1
fi

# Function to get the base branch for a given branch using merge-base analysis
# This function finds the most likely base branch by:
# 1. Checking upstream tracking branch (most reliable)
# 2. Using git merge-base to find common ancestors with potential base branches
# 3. Selecting the base branch with the most recent common ancestor
get_base_branch() {
    BRANCH="$1"
    
    # First, try to get the tracking branch (most reliable when set correctly)
    debug_echo "Checking tracking branch for: $BRANCH"
    TRACKING_BRANCH=$(git rev-parse --abbrev-ref "${BRANCH}@{upstream}" 2>/dev/null | sed 's|origin/||' || echo "")
    debug_echo "Tracking branch result: '$TRACKING_BRANCH'"
    
    # Ignore self-referencing tracking branches (branch tracking itself)
    if [ -n "$TRACKING_BRANCH" ] && [ "$TRACKING_BRANCH" != "$BRANCH" ]; then
        debug_echo "Using valid tracking branch: $TRACKING_BRANCH"
        echo "$TRACKING_BRANCH"
        return 0
    elif [ -n "$TRACKING_BRANCH" ] && [ "$TRACKING_BRANCH" = "$BRANCH" ]; then
        debug_echo "Ignoring self-referencing tracking branch: $TRACKING_BRANCH"
    fi
    
    # If no tracking branch, use merge-base analysis to find the actual branching point
    # Get list of potential base branches to check
    POTENTIAL_BASES=""
    
    # Check for main/master branches (local and remote)
    if git show-ref --verify --quiet refs/heads/main; then
        POTENTIAL_BASES="$POTENTIAL_BASES main"
    fi
    if git show-ref --verify --quiet refs/heads/master; then
        POTENTIAL_BASES="$POTENTIAL_BASES master"
    fi
    if git show-ref --verify --quiet refs/remotes/origin/main; then
        POTENTIAL_BASES="$POTENTIAL_BASES origin/main"
    fi
    if git show-ref --verify --quiet refs/remotes/origin/master; then
        POTENTIAL_BASES="$POTENTIAL_BASES origin/master"
    fi
    
    # Add develop branch if it exists
    if git show-ref --verify --quiet refs/heads/develop; then
        POTENTIAL_BASES="$POTENTIAL_BASES develop"
    fi
    if git show-ref --verify --quiet refs/remotes/origin/develop; then
        POTENTIAL_BASES="$POTENTIAL_BASES origin/develop"
    fi
    
    if [ -z "$POTENTIAL_BASES" ]; then
        debug_echo "No potential bases found, defaulting to main"
        echo "main"  # Final fallback
        return 0
    fi
    
    debug_echo "Potential base branches: $POTENTIAL_BASES"
    
    # Strategy 1: Try fork-point detection (most accurate)
    BEST_BASE=""
    
    for BASE_CANDIDATE in $POTENTIAL_BASES; do
        # Skip if the candidate is the same as our branch
        if [ "$BASE_CANDIDATE" = "$BRANCH" ]; then
            continue
        fi
        
        debug_echo "Checking fork-point for $BRANCH against $BASE_CANDIDATE"
        
        # Try to find the fork-point (where the branch diverged)
        FORK_POINT=$(git merge-base --fork-point "$BASE_CANDIDATE" "$BRANCH" 2>/dev/null || echo "")
        
        if [ -n "$FORK_POINT" ]; then
            debug_echo "Found fork-point: $FORK_POINT for base: $BASE_CANDIDATE"
            BEST_BASE="$BASE_CANDIDATE"
            break  # Fork-point is the most reliable, use first one found
        fi
    done
    
    # Strategy 2: If no fork-point found, use commit count analysis
    if [ -z "$BEST_BASE" ]; then
        debug_echo "No fork-point found, using commit count analysis"
        MIN_UNIQUE_COMMITS=999999
        
        for BASE_CANDIDATE in $POTENTIAL_BASES; do
            if [ "$BASE_CANDIDATE" = "$BRANCH" ]; then
                continue
            fi
            
            # Count commits unique to our branch (not in base candidate)
            UNIQUE_COMMITS=$(git rev-list --count "$BRANCH" ^"$BASE_CANDIDATE" 2>/dev/null || echo "999999")
            debug_echo "Branch $BRANCH has $UNIQUE_COMMITS commits not in $BASE_CANDIDATE"
            
            # The base with the fewest unique commits is likely the true base
            if [ "$UNIQUE_COMMITS" -lt "$MIN_UNIQUE_COMMITS" ] && [ "$UNIQUE_COMMITS" -gt "0" ]; then
                MIN_UNIQUE_COMMITS="$UNIQUE_COMMITS"
                BEST_BASE="$BASE_CANDIDATE"
            fi
        done
    fi
    
    # Strategy 3: Final fallback based on common patterns
    if [ -z "$BEST_BASE" ]; then
        debug_echo "Commit count analysis failed, using fallback logic"
        
        # Check if branch name suggests a base (e.g., feature branches usually come from develop)
        case "$BRANCH" in
            feature/*|feat/*|fix/*|bugfix/*)
                if echo "$POTENTIAL_BASES" | grep -q "develop"; then
                    BEST_BASE="develop"
                    debug_echo "Feature/fix branch detected, defaulting to develop"
                fi
                ;;
            hotfix/*|release/*)
                if echo "$POTENTIAL_BASES" | grep -q "main"; then
                    BEST_BASE="main"
                    debug_echo "Hotfix/release branch detected, defaulting to main"
                fi
                ;;
        esac
        
        # Ultimate fallback
        if [ -z "$BEST_BASE" ]; then
            if echo "$POTENTIAL_BASES" | grep -q "main"; then
                BEST_BASE="main"
            elif echo "$POTENTIAL_BASES" | grep -q "master"; then
                BEST_BASE="master"
            elif echo "$POTENTIAL_BASES" | grep -q "develop"; then
                BEST_BASE="develop"
            else
                BEST_BASE="main"
            fi
            debug_echo "Using ultimate fallback: $BEST_BASE"
        fi
    fi
    
    # Clean up the base branch name (remove origin/ prefix for display)
    CLEAN_BASE=$(echo "$BEST_BASE" | sed 's|origin/||')
    debug_echo "Final base branch determined: $CLEAN_BASE"
    echo "$CLEAN_BASE"
}

# Function to create PR with enhanced error handling
# Returns status code and writes result to stdout for parsing
create_pr_with_error_handling() {
    SOURCE="$1"
    TARGET="$2"
    
    echo "Creating PR from $SOURCE to $TARGET..." >&2
    
    # Check if source and target are the same
    if [ "$SOURCE" = "$TARGET" ]; then
        echo "  ❌ Cannot create PR from branch to itself" >&2
        echo "SAME_BRANCH:$TARGET"
        return 1
    fi
    
    # Check if source branch exists remotely first (with timeout)
    echo "  🔍 Checking if source branch exists on remote..." >&2
    
    debug_echo "Running: git ls-remote --heads origin (with timeout if available)"
    echo "    ⏳ Connecting to remote (this may take a few seconds)..." >&2
    
    # Use timeout if available, otherwise run normally
    if ALL_REMOTE_BRANCHES=$(run_with_timeout 5 git ls-remote --heads origin 2>&1); then
        LS_REMOTE_EXIT_CODE=0
        debug_echo "Git ls-remote completed successfully"
    else
        LS_REMOTE_EXIT_CODE=$?
        debug_echo "Git ls-remote failed with exit code: $LS_REMOTE_EXIT_CODE"
        
        if [ $LS_REMOTE_EXIT_CODE -eq 124 ]; then
            echo "  ❌ Remote connection timed out after 5 seconds. Check network connectivity." >&2
            echo "TIMEOUT_ERROR:$SOURCE"
        else
            debug_echo "Git ls-remote failed with output: '$ALL_REMOTE_BRANCHES'"
            echo "  ❌ Failed to connect to remote. Check network and authentication." >&2
            echo "REMOTE_ERROR:$SOURCE"
        fi
        return 1
    fi
    
    debug_echo "All remote branches found: $(echo "$ALL_REMOTE_BRANCHES" | grep -c refs/heads) branches"
    if [ "$DEBUG" = "1" ]; then
        echo "DEBUG: First 3 remote branches:" >&2
        echo "$ALL_REMOTE_BRANCHES" | head -3 >&2
    fi
    
    # Check if our specific branch is in the list
    REMOTE_SOURCE_CHECK=$(echo "$ALL_REMOTE_BRANCHES" | grep "refs/heads/$SOURCE" || echo "")
    debug_echo "Source branch check result: '$REMOTE_SOURCE_CHECK'"
    
    if [ -z "$REMOTE_SOURCE_CHECK" ]; then
        debug_echo "Remote check failed. Checking local branch existence..."
        debug_echo "Running: git show-ref --verify --quiet \"refs/heads/$SOURCE\""
        
        # Check if branch exists locally but not pushed
        if git show-ref --verify --quiet "refs/heads/$SOURCE"; then
            debug_echo "Branch exists locally but not on remote"
            
            # Try alternative method: check if branch has upstream tracking info
            UPSTREAM_INFO=$(git rev-parse --abbrev-ref "$SOURCE@{upstream}" 2>/dev/null || echo "")
            if [ -n "$UPSTREAM_INFO" ]; then
                echo "  ⚠️  Branch has upstream tracking but remote check failed. Proceeding with caution..." >&2
                echo "  💡 If this fails, try: git push -u origin $SOURCE" >&2
                debug_echo "Branch has upstream tracking: $UPSTREAM_INFO, continuing"
                # Continue execution instead of failing
            else
                echo "  ❌ Source branch '$SOURCE' exists locally but not on remote. Push it first: git push -u origin $SOURCE" >&2
                echo "PUSH_REQUIRED:$SOURCE"
                return 1
            fi
        else
            debug_echo "Branch does not exist locally or on remote"
            echo "  ❌ Source branch '$SOURCE' not found locally or on remote. Create or checkout the branch first." >&2
            echo "BRANCH_NOT_FOUND:$SOURCE"
            return 1
        fi
    fi
    
    debug_echo "Source branch found on remote"
    
    # Check if target branch exists (with timeout if available)
    echo "  🔍 Checking if target branch exists on remote..." >&2
    REMOTE_TARGET_CHECK=$(run_with_timeout 5 git ls-remote --heads origin "$TARGET" 2>/dev/null || echo "")
    
    if [ -z "$REMOTE_TARGET_CHECK" ] || ! echo "$REMOTE_TARGET_CHECK" | grep -q "refs/heads/$TARGET"; then
        echo "  ❌ Target branch '$TARGET' not found on remote" >&2
        echo "TARGET_NOT_FOUND:$TARGET"
        return 1
    fi
    
    # Check if branches are identical (no differences) and test for merge conflicts
    echo "  🔍 Checking for differences and potential merge conflicts..." >&2
    MERGE_BASE=$(run_with_timeout 10 git merge-base "origin/$SOURCE" "origin/$TARGET" 2>/dev/null || echo "")
    SOURCE_COMMIT=$(run_with_timeout 10 git rev-parse "origin/$SOURCE" 2>/dev/null || echo "")
    TARGET_COMMIT=$(run_with_timeout 10 git rev-parse "origin/$TARGET" 2>/dev/null || echo "")
    
    if [ -n "$MERGE_BASE" ] && [ -n "$SOURCE_COMMIT" ] && [ "$MERGE_BASE" = "$SOURCE_COMMIT" ]; then
        echo "  ⚠️  No differences between $SOURCE and $TARGET (branches are identical)" >&2
        echo "NO_DIFFERENCES:$TARGET"
        return 1
    fi
    
    # Pre-check for potential merge conflicts (optional - can be slow for large repos)
    if [ -n "$MERGE_BASE" ] && [ -n "$SOURCE_COMMIT" ] && [ -n "$TARGET_COMMIT" ]; then
        debug_echo "Testing for merge conflicts between $SOURCE and $TARGET"
        
        # Test merge in a safe way (doesn't actually merge)
        MERGE_TEST=$(git merge-tree "$MERGE_BASE" "$SOURCE_COMMIT" "$TARGET_COMMIT" 2>/dev/null || echo "")
        
        if echo "$MERGE_TEST" | grep -q "<<<<<<< "; then
            echo "  ⚠️  Warning: Potential merge conflicts detected between $SOURCE and $TARGET" >&2
            echo "  💡 PR can still be created, but will need manual conflict resolution" >&2
            debug_echo "Merge conflicts detected, but continuing with PR creation"
        fi
    fi
    
    # First check if PR already exists
    echo "  🔍 Checking for existing PR..." >&2
    debug_echo "Running: gh pr list --head \"$SOURCE\" --base \"$TARGET\""
    
    EXISTING_PR_URL=$(gh pr list --head "$SOURCE" --base "$TARGET" --json url --jq '.[0].url' 2>/dev/null || echo "")
    
    if [ -n "$EXISTING_PR_URL" ]; then
        echo "  📎 PR already exists: $EXISTING_PR_URL" >&2
        debug_echo "Found existing PR: $EXISTING_PR_URL"
        echo "SUCCESS:$EXISTING_PR_URL"
        return 0
    fi
    
    # Try to create PR with detailed error capture (with timeout)
    echo "  🚀 Creating new PR..." >&2
    debug_echo "Running: gh pr create --base \"$TARGET\" --head \"$SOURCE\""
    debug_echo "PR title: \"Merge $SOURCE into $TARGET\""
    
    PR_OUTPUT=$(run_with_timeout 30 gh pr create \
        --base "$TARGET" \
        --head "$SOURCE" \
        --title "Merge $SOURCE into $TARGET" \
        --body "Automated PR created by branch-summary.sh" \
        2>&1)
    
    debug_echo "gh pr create output: '$PR_OUTPUT'"
    
    PR_EXIT_CODE=$?
    
    if [ $PR_EXIT_CODE -eq 0 ]; then
        echo "  ✅ PR created: $PR_OUTPUT" >&2
        echo "SUCCESS:$PR_OUTPUT"
        return 0
    else
        # Parse common error types and provide specific feedback
        case "$PR_OUTPUT" in
            *"already exists"*|*"already have a pull request open"*)
                echo "  ⚠️  PR already exists for $SOURCE → $TARGET" >&2
                # This shouldn't happen since we check for existing PRs first, but handle it anyway
                EXISTING_PR=$(gh pr list --head "$SOURCE" --base "$TARGET" --json url --jq '.[0].url' 2>/dev/null || echo "")
                if [ -n "$EXISTING_PR" ]; then
                    echo "  📎 Existing PR: $EXISTING_PR" >&2
                    echo "SUCCESS:$EXISTING_PR"
                else
                    echo "SUCCESS:PR already exists (URL unavailable)"
                fi
                ;;
            *"no commits"*|*"No commits between"*)
                echo "  ⚠️  No commits between $SOURCE and $TARGET" >&2
                echo "NO_COMMITS:$TARGET"
                ;;
            *"authentication"*|*"auth"*)
                echo "  ❌ Authentication required. Run: gh auth login" >&2
                echo "AUTH_REQUIRED:$TARGET"
                ;;
            *"not found"*|*"repository not found"*)
                echo "  ❌ Repository or branch not found" >&2
                echo "NOT_FOUND:$TARGET"
                ;;
            *"insufficient"*|*"permission"*)
                echo "  ❌ Insufficient permissions to create PR" >&2
                echo "PERMISSIONS:$TARGET"
                ;;
            *"rate limit"*|*"API rate limit"*)
                echo "  ❌ GitHub API rate limit exceeded. Try again later" >&2
                echo "RATE_LIMIT:$TARGET"
                ;;
            *"archived"*)
                echo "  ❌ Repository is archived - PRs cannot be created" >&2
                echo "ARCHIVED:$TARGET"
                ;;
            *"disabled"*|*"pull requests are disabled"*)
                echo "  ❌ Pull requests are disabled for this repository" >&2
                echo "DISABLED:$TARGET"
                ;;
            *"network"*|*"connection"*)
                echo "  ❌ Network error. Check your internet connection" >&2
                echo "NETWORK_ERROR:$TARGET"
                ;;
            *"conflict"*|*"merge conflict"*|*"cannot be merged"*)
                echo "  ⚠️  Cannot create PR due to merge conflicts with $TARGET" >&2
                echo "  💡 Resolve conflicts first: git checkout $SOURCE && git rebase $TARGET" >&2
                echo "MERGE_CONFLICTS:$TARGET"
                ;;
            *"cannot be automatically merged"*|*"merge is not clean"*)
                echo "  ⚠️  PR created but has merge conflicts that need manual resolution" >&2
                echo "  💡 Check the PR on GitHub and resolve conflicts there" >&2
                # Extract PR URL from output if available
                PR_URL=$(echo "$PR_OUTPUT" | grep -o 'https://github.com[^[:space:]]*' | head -1 || echo "")
                if [ -n "$PR_URL" ]; then
                    echo "MERGE_CONFLICTS_WITH_PR:$PR_URL"
                else
                    echo "MERGE_CONFLICTS_WITH_PR:PR created with conflicts (URL not found)"
                fi
                ;;
            *"validation failed"*|*"422"*)
                echo "  ❌ GitHub validation failed. Check branch names and repository settings" >&2
                echo "VALIDATION_ERROR:$TARGET"
                ;;
            *)
                echo "  ❌ Failed to create PR: $PR_OUTPUT" >&2
                echo "UNKNOWN_ERROR:$TARGET"
                ;;
        esac
        return 1
    fi
}

# Function to copy to clipboard based on OS
copy_to_clipboard() {
    CONTENT="$1"
    
    if command -v pbcopy > /dev/null 2>&1; then
        # macOS
        printf "%s" "$CONTENT" | pbcopy
        echo "✅ Summary copied to clipboard (macOS)"
    elif command -v xclip > /dev/null 2>&1; then
        # Linux with xclip
        printf "%s" "$CONTENT" | xclip -selection clipboard
        echo "✅ Summary copied to clipboard (Linux - xclip)"
    elif command -v xsel > /dev/null 2>&1; then
        # Linux with xsel
        printf "%s" "$CONTENT" | xsel --clipboard --input
        echo "✅ Summary copied to clipboard (Linux - xsel)"
    elif command -v wl-copy > /dev/null 2>&1; then
        # Wayland
        printf "%s" "$CONTENT" | wl-copy
        echo "✅ Summary copied to clipboard (Wayland)"
    else
        echo "⚠️  Could not copy to clipboard. Please copy the summary manually."
        echo "Install one of: pbcopy (macOS), xclip, xsel, or wl-copy (Linux)"
    fi
}

# Step 1: Select source branch
echo ""
echo "Step 1: Select the source branch for PRs"
ALL_BRANCHES=$(git branch -a | sed 's/^[*+ ] //' | sed 's|remotes/origin/||' | grep -v '^HEAD' | sort -u)

if [ -z "$ALL_BRANCHES" ]; then
    echo "Error: No branches found"
    exit 1
fi

SOURCE_BRANCH=$(echo "$ALL_BRANCHES" | fzf --reverse --info=inline --prompt="Source Branch: " --height=20 --preview="" --multi=0)

if [ -z "$SOURCE_BRANCH" ]; then
    echo "No source branch selected. Exiting."
    exit 0
fi

echo "Selected source branch: $SOURCE_BRANCH"

# Get the base branch for the source branch
debug_echo "Getting base branch for: $SOURCE_BRANCH"
ORIGINAL_BASE=$(get_base_branch "$SOURCE_BRANCH")
debug_echo "Detected base branch: $ORIGINAL_BASE"
echo "Base branch: $ORIGINAL_BASE"

# Step 2: Select target branches for PRs
echo ""
echo "Step 2: Select target branches for pull requests (use TAB to select multiple)"
TARGET_BRANCHES=$(echo "$ALL_BRANCHES" | grep -v "^${SOURCE_BRANCH}$" | fzf --reverse --info=inline --prompt="Target Branches: " --height=20 --preview="" --multi)

if [ -z "$TARGET_BRANCHES" ]; then
    echo "No target branches selected. Exiting."
    exit 0
fi

echo "Selected target branches:"
echo "$TARGET_BRANCHES" | sed 's/^/  - /'

# Step 3: Create PRs and collect links
echo ""
echo "Creating pull requests..."

SUMMARY="Branch: $SOURCE_BRANCH"
SUMMARY="$SUMMARY\nBase-branch: $ORIGINAL_BASE"
SUMMARY="$SUMMARY\n"

PR_CREATED=false
PUSH_REQUIRED_BRANCHES=""

# Create a temporary file to capture results
TEMP_RESULTS=$(mktemp)

# Process each target branch (avoid subshell by using here-string instead of pipe)
while IFS= read -r TARGET_BRANCH; do
    if [ -n "$TARGET_BRANCH" ]; then
        # Use the enhanced PR creation function
        PR_RESULT=$(create_pr_with_error_handling "$SOURCE_BRANCH" "$TARGET_BRANCH")
        
        # Parse the result to update summary
        case "$PR_RESULT" in
            SUCCESS:*)
                PR_URL=$(echo "$PR_RESULT" | sed 's/SUCCESS://')
                echo "success|$TARGET_BRANCH|$PR_URL" >> "$TEMP_RESULTS"
                ;;
            EXISTING_PR:*)
                EXISTING_URL=$(echo "$PR_RESULT" | sed 's/EXISTING_PR://')
                if [ "$EXISTING_URL" != "Unable to fetch existing PR URL" ]; then
                    echo "existing|$TARGET_BRANCH|$EXISTING_URL" >> "$TEMP_RESULTS"
                else
                    echo "existing|$TARGET_BRANCH|PR exists but URL unavailable" >> "$TEMP_RESULTS"
                fi
                ;;
            SAME_BRANCH:*)
                echo "same_branch|$TARGET_BRANCH|Cannot create PR from branch to itself" >> "$TEMP_RESULTS"
                ;;
            PUSH_REQUIRED:*)
                echo "push_required|$TARGET_BRANCH|Source branch needs to be pushed" >> "$TEMP_RESULTS"
                ;;
            BRANCH_NOT_FOUND:*)
                echo "branch_not_found|$TARGET_BRANCH|Source branch does not exist" >> "$TEMP_RESULTS"
                ;;
            REMOTE_ERROR:*)
                echo "remote_error|$TARGET_BRANCH|Failed to connect to remote" >> "$TEMP_RESULTS"
                ;;
            TIMEOUT_ERROR:*)
                echo "timeout_error|$TARGET_BRANCH|Remote connection timed out" >> "$TEMP_RESULTS"
                ;;
            NO_DIFFERENCES:*|NO_COMMITS:*)
                echo "no_changes|$TARGET_BRANCH|No differences between branches" >> "$TEMP_RESULTS"
                ;;
            AUTH_REQUIRED:*)
                echo "auth_error|$TARGET_BRANCH|Authentication required" >> "$TEMP_RESULTS"
                ;;
            PERMISSIONS:*)
                echo "permission_error|$TARGET_BRANCH|Insufficient permissions" >> "$TEMP_RESULTS"
                ;;
            RATE_LIMIT:*)
                echo "rate_limit|$TARGET_BRANCH|API rate limit exceeded" >> "$TEMP_RESULTS"
                ;;
            MERGE_CONFLICTS:*)
                echo "merge_conflicts|$TARGET_BRANCH|Merge conflicts prevent PR creation" >> "$TEMP_RESULTS"
                ;;
            MERGE_CONFLICTS_WITH_PR:*)
                PR_URL=$(echo "$PR_RESULT" | sed 's/MERGE_CONFLICTS_WITH_PR://')
                echo "conflicts_with_pr|$TARGET_BRANCH|$PR_URL" >> "$TEMP_RESULTS"
                ;;
            VALIDATION_ERROR:*)
                echo "validation_error|$TARGET_BRANCH|GitHub validation failed" >> "$TEMP_RESULTS"
                ;;
            *)
                echo "error|$TARGET_BRANCH|Failed to create PR" >> "$TEMP_RESULTS"
                ;;
        esac
    fi
done <<< "$TARGET_BRANCHES"

# Process results and build summary
if [ -s "$TEMP_RESULTS" ]; then
    while IFS='|' read -r STATUS BRANCH INFO; do
        case "$STATUS" in
            success)
                SUMMARY="$SUMMARY\n$BRANCH: $INFO"
                PR_CREATED=true
                ;;
            existing)
                # This case is now handled in the success case since we pre-check for existing PRs
                SUMMARY="$SUMMARY\n$BRANCH: $INFO (existing PR)"
                PR_CREATED=true
                ;;
            same_branch)
                SUMMARY="$SUMMARY\n$BRANCH: ❌ Cannot create PR to same branch"
                ;;
            push_required)
                SUMMARY="$SUMMARY\n$BRANCH: ❌ Push source branch first"
                PUSH_REQUIRED_BRANCHES="$PUSH_REQUIRED_BRANCHES $BRANCH"
                ;;
            branch_not_found)
                SUMMARY="$SUMMARY\n$BRANCH: ❌ Source branch does not exist"
                ;;
            remote_error)
                SUMMARY="$SUMMARY\n$BRANCH: ❌ Failed to connect to remote"
                ;;
            timeout_error)
                SUMMARY="$SUMMARY\n$BRANCH: ❌ Remote connection timed out"
                ;;
            no_changes)
                SUMMARY="$SUMMARY\n$BRANCH: ⚠️ No changes to merge"
                ;;
            auth_error)
                SUMMARY="$SUMMARY\n$BRANCH: ❌ Authentication required"
                ;;
            permission_error)
                SUMMARY="$SUMMARY\n$BRANCH: ❌ Insufficient permissions"
                ;;
            rate_limit)
                SUMMARY="$SUMMARY\n$BRANCH: ❌ Rate limit exceeded"
                ;;
            merge_conflicts)
                SUMMARY="$SUMMARY\n$BRANCH: ⚠️ Merge conflicts prevent PR creation"
                ;;
            conflicts_with_pr)
                SUMMARY="$SUMMARY\n$BRANCH: $INFO ⚠️ (has merge conflicts)"
                PR_CREATED=true  # PR was created, just with conflicts
                ;;
            validation_error)
                SUMMARY="$SUMMARY\n$BRANCH: ❌ GitHub validation failed"
                ;;
            *)
                SUMMARY="$SUMMARY\n$BRANCH: ❌ Failed to create PR"
                ;;
        esac
    done < "$TEMP_RESULTS"
fi

# Clean up temporary file
rm -f "$TEMP_RESULTS"

# Step 4: Display and copy summary with helpful suggestions
echo ""
echo "========================================"
echo "PULL REQUEST SUMMARY"
echo "========================================"
printf "%b\n" "$SUMMARY"
echo "========================================"

# Provide helpful suggestions for common issues
if [ -n "$PUSH_REQUIRED_BRANCHES" ]; then
    echo ""
    echo "💡 To fix 'push required' errors, run:"
    echo "   git push -u origin $SOURCE_BRANCH"
fi

if echo "$SUMMARY" | grep -q "Authentication required"; then
    echo ""
    echo "💡 To fix authentication errors, run:"
    echo "   gh auth login"
fi

if echo "$SUMMARY" | grep -q "No changes to merge"; then
    echo ""
    echo "💡 Branches with no changes are already up-to-date with the source branch"
fi

if echo "$SUMMARY" | grep -q "Merge conflicts"; then
    echo ""
    echo "💡 To resolve merge conflicts:"
    echo "   1. git checkout $SOURCE_BRANCH"
    echo "   2. git rebase <target-branch>  # or git merge <target-branch>"
    echo "   3. Resolve conflicts in your editor"
    echo "   4. git add . && git rebase --continue  # or git commit"
    echo "   5. git push --force-with-lease"
fi

if [ "$PR_CREATED" = true ]; then
    echo ""
    copy_to_clipboard "$(printf "%b" "$SUMMARY")"
else
    echo ""
    echo "⚠️  No PRs were successfully created."
    if echo "$SUMMARY" | grep -q "❌"; then
        echo "   Check the error messages above and follow the suggestions."
    fi
fi

echo ""
echo "Done!"