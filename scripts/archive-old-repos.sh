#!/bin/bash

set -uo pipefail

DAYS_THRESHOLD=${1:-180}
DRY_RUN=false

usage() {
    echo "Usage: $0 [DAYS] [--dry-run]"
    echo "  DAYS: Number of days since last activity (default: 180)"
    echo "  --dry-run: Show what would be archived without doing it"
    exit 1
}

if [[ $# -gt 0 && "$1" == "--help" ]]; then
    usage
fi

if [[ $# -eq 2 && "$2" == "--dry-run" ]]; then
    DRY_RUN=true
elif [[ $# -eq 1 && "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    DAYS_THRESHOLD=180
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

echo "Checking repositories not updated in the last $DAYS_THRESHOLD days..."
echo

CUTOFF_DATE=$(date -d "$DAYS_THRESHOLD days ago" -I)
echo "Cutoff date: $CUTOFF_DATE"
echo

REPOS_TO_ARCHIVE=()

while IFS=$'\t' read -r name updated_at archived; do
    if [[ "$archived" == "true" ]]; then
        continue
    fi
    
    updated_date=$(date -d "$updated_at" -I 2>/dev/null || echo "1900-01-01")
    
    if [[ "$updated_date" < "$CUTOFF_DATE" ]]; then
        REPOS_TO_ARCHIVE+=("$name")
        echo "📦 $name (last updated: $updated_date)"
    fi
done < <(gh repo list --limit 1000 --json name,updatedAt,isArchived --template '{{range .}}{{.name}}{{"\t"}}{{.updatedAt}}{{"\t"}}{{.isArchived}}{{"\n"}}{{end}}')

if [[ ${#REPOS_TO_ARCHIVE[@]} -eq 0 ]]; then
    echo "✅ No repositories found that haven't been updated in the last $DAYS_THRESHOLD days"
    exit 0
fi

echo
echo "Found ${#REPOS_TO_ARCHIVE[@]} repository(ies) that haven't been updated in the last $DAYS_THRESHOLD days."
echo

if [[ "$DRY_RUN" == "true" ]]; then
    echo "🔍 DRY RUN MODE - No changes will be made"
    echo "The following repositories would be archived:"
    for repo in "${REPOS_TO_ARCHIVE[@]}"; do
        echo "  - $repo"
    done
    exit 0
fi

read -p "Do you want to proceed with archiving these repositories? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 0
fi

echo
echo "Archiving repositories..."

ARCHIVED_COUNT=0
FAILED_COUNT=0

for repo in "${REPOS_TO_ARCHIVE[@]}"; do
    echo -n "Archiving $repo... "
    
    read -p "Archive $repo? (y/N/a=all/q=quit): " -n 1 -r
    echo
    
    case $REPLY in
        [Yy]*)
            if error_output=$(gh repo archive "$repo" -y 2>&1); then
                echo "✅ $repo archived successfully"
                ((ARCHIVED_COUNT++))
            else
                echo "❌ Failed to archive $repo: $error_output"
                ((FAILED_COUNT++))
            fi
            ;;
        [Aa]*)
            echo "Archiving all remaining repositories..."
            for remaining_repo in "${REPOS_TO_ARCHIVE[@]:$((${#REPOS_TO_ARCHIVE[@]} - ${#REPOS_TO_ARCHIVE[@]} + ARCHIVED_COUNT + FAILED_COUNT))}"; do
                if error_output=$(gh repo archive "$remaining_repo" -y 2>&1); then
                    echo "✅ $remaining_repo archived successfully"
                    ((ARCHIVED_COUNT++))
                else
                    echo "❌ Failed to archive $remaining_repo: $error_output"
                    ((FAILED_COUNT++))
                fi
            done
            break
            ;;
        [Qq]*)
            echo "Operation cancelled by user."
            break
            ;;
        *)
            echo "Skipping $repo"
            ;;
    esac
done

echo
echo "Summary:"
echo "  Archived: $ARCHIVED_COUNT repositories"
echo "  Failed: $FAILED_COUNT repositories"
echo "  Total processed: $((ARCHIVED_COUNT + FAILED_COUNT)) repositories"