#!/bin/bash

set -uo pipefail

DRY_RUN=false

usage() {
    echo "Usage: $0 [--dry-run]"
    echo "  --dry-run: Show what would be deleted without doing it"
    exit 1
}

if [[ $# -gt 0 && "$1" == "--help" ]]; then
    usage
fi

if [[ $# -eq 1 && "$1" == "--dry-run" ]]; then
    DRY_RUN=true
fi

if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed or not in PATH"
    echo "Install it from: https://cli.github.com/"
    exit 1
fi

if ! gh auth status &> /dev/null; then
    echo "Error: Not authenticated with GitHub CLI"
    echo "Run: gh auth login"
    exit 1
fi

echo "Finding archived repositories..."
echo

ARCHIVED_REPOS=()

while IFS=$'\t' read -r name archived; do
    if [[ "$archived" == "true" ]]; then
        ARCHIVED_REPOS+=("$name")
        echo "🗂️  $name (archived)"
    fi
done < <(gh repo list --limit 1000 --json name,isArchived --template '{{range .}}{{.name}}{{"\t"}}{{.isArchived}}{{"\n"}}{{end}}')

if [[ ${#ARCHIVED_REPOS[@]} -eq 0 ]]; then
    echo "✅ No archived repositories found"
    exit 0
fi

echo
echo "Found ${#ARCHIVED_REPOS[@]} archived repository(ies)."
echo

if [[ "$DRY_RUN" == "true" ]]; then
    echo "🔍 DRY RUN MODE - No changes will be made"
    echo "The following archived repositories would be available for deletion:"
    for repo in "${ARCHIVED_REPOS[@]}"; do
        echo "  - $repo"
    done
    exit 0
fi

echo "⚠️  WARNING: Repository deletion is PERMANENT and IRREVERSIBLE!"
echo "All code, issues, pull requests, and history will be lost forever."
echo

read -p "Do you understand the risks and want to proceed? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 0
fi

echo
echo "Processing archived repositories..."

DELETED_COUNT=0
FAILED_COUNT=0
SKIPPED_COUNT=0

for repo in "${ARCHIVED_REPOS[@]}"; do
    echo
    echo "Repository: $repo"
    
    read -p "Delete $repo? (y/N/q=quit): " -n 1 -r
    echo
    
    case $REPLY in
        [Yy]*)
            echo "⚠️  Final confirmation: Type the repository name to confirm deletion:"
            read -p "Repository name: " confirm_name
            if [[ "$confirm_name" != "$repo" ]]; then
                echo "❌ Repository name mismatch. Skipping $repo"
                ((SKIPPED_COUNT++))
                continue
            fi
            
            if error_output=$(gh repo delete "$repo" --confirm 2>&1); then
                echo "✅ $repo deleted successfully"
                ((DELETED_COUNT++))
            else
                echo "❌ Failed to delete $repo: $error_output"
                ((FAILED_COUNT++))
            fi
            ;;
        [Qq]*)
            echo "Operation cancelled by user."
            break
            ;;
        *)
            echo "Skipping $repo"
            ((SKIPPED_COUNT++))
            ;;
    esac
done

echo
echo "Summary:"
echo "  Deleted: $DELETED_COUNT repositories"
echo "  Failed: $FAILED_COUNT repositories"
echo "  Skipped: $SKIPPED_COUNT repositories"
echo "  Total processed: $((DELETED_COUNT + FAILED_COUNT + SKIPPED_COUNT)) repositories"

if [[ $DELETED_COUNT -gt 0 ]]; then
    echo
    echo "⚠️  Remember: Deleted repositories cannot be recovered!"
fi