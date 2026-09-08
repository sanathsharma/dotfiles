#!/bin/bash

# Check if Cargo.toml exists
if [ ! -f "Cargo.toml" ]; then
    echo "Error: Cargo.toml not found in current directory"
    exit 1
fi

# Extract package name from Cargo.toml
PACKAGE_NAME=$(grep -m 1 "name\s*=" Cargo.toml | sed -E 's/name\s*=\s*"([^"]+)"/\1/g' | tr -d '[:space:]')

# Convert package name for binary search (replace - with _)
BINARY_NAME=$(echo "$PACKAGE_NAME" | tr '-' '_')

if [ -z "$PACKAGE_NAME" ]; then
    echo "Error: Could not extract package name from Cargo.toml"
    exit 1
fi

echo "Package name: $PACKAGE_NAME"

# Run cargo build
echo "Building project..."
cargo build

if [ $? -ne 0 ]; then
    echo "Error: cargo build failed"
    exit 1
fi

# Find the latest binary with the package name
echo "Finding latest binary..."
BINARY=$(find target/debug/deps -type f -name "${BINARY_NAME}-*" -not -name "*.d" -not -name "*.rlib" | sort -r | head -n 1)

if [ -z "$BINARY" ]; then
    echo "Error: Could not find binary for package $PACKAGE_NAME"
    exit 1
fi

echo "Found binary: $BINARY"

# Run rust-lldb with the binary
echo "Starting rust-lldb..."
rust-lldb "$BINARY"
