#!/usr/bin/env bash

# symlink-mirror.sh - Create symlinks mirroring directory structure
# Usage: ./symlink-mirror.sh -d <source_dir> -t <target_dir>

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage
usage() {
    echo "Usage: $0 -d <source_directory> -t <target_directory>"
    echo ""
    echo "Options:"
    echo "  -d    Source directory containing files to symlink"
    echo "  -t    Target directory where symlinks will be created"
    echo "  -h    Display this help message"
    exit 1
}

# Function to log messages
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Parse command line arguments
SOURCE_DIR=""
TARGET_DIR=""

while getopts "d:t:h" opt; do
    case $opt in
        d)
            SOURCE_DIR="$OPTARG"
            ;;
        t)
            TARGET_DIR="$OPTARG"
            ;;
        h)
            usage
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

# Validate arguments
if [ -z "$SOURCE_DIR" ] || [ -z "$TARGET_DIR" ]; then
    log_error "Both source (-d) and target (-t) directories are required"
    usage
fi

# Convert to absolute paths
SOURCE_DIR="$(cd "$SOURCE_DIR" && pwd)"
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd || echo "$TARGET_DIR")"

# Validate source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    log_error "Source directory does not exist: $SOURCE_DIR"
    exit 1
fi

# Create target directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    log_info "Creating target directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

log_info "Source directory: $SOURCE_DIR"
log_info "Target directory: $TARGET_DIR"
echo ""

# Counter for statistics
total_files=0
created_symlinks=0
skipped_files=0

# Find all files in source directory and create symlinks
while IFS= read -r -d '' source_file; do
    # Get relative path from source directory
    rel_path="${source_file#$SOURCE_DIR/}"

    # Target file path
    target_file="$TARGET_DIR/$rel_path"

    # Get directory for target file
    target_dir="$(dirname "$target_file")"

    # Create directory structure if it doesn't exist
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
    fi

    total_files=$((total_files + 1))

    # Check if target already exists
    if [ -e "$target_file" ] || [ -L "$target_file" ]; then
        if [ -L "$target_file" ]; then
            # Check if it's already pointing to the correct location
            current_target="$(readlink "$target_file")"
            if [ "$current_target" = "$source_file" ]; then
                log_info "Already linked: $rel_path"
                skipped_files=$((skipped_files + 1))
                continue
            else
                log_warn "Symlink exists but points elsewhere: $rel_path"
                log_warn "  Current: $current_target"
                log_warn "  Expected: $source_file"
                skipped_files=$((skipped_files + 1))
                continue
            fi
        else
            log_warn "File already exists (not a symlink): $rel_path"
            skipped_files=$((skipped_files + 1))
            continue
        fi
    fi

    # Create symlink
    ln -s "$source_file" "$target_file"
    log_info "Created symlink: $rel_path"
    created_symlinks=$((created_symlinks + 1))

done < <(find "$SOURCE_DIR" -type f -print0)

# Print statistics
echo ""
echo "=========================================="
log_info "Summary:"
echo "  Total files found: $total_files"
echo "  Symlinks created: $created_symlinks"
echo "  Files skipped: $skipped_files"
echo "=========================================="
