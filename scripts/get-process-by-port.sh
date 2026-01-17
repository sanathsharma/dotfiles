#!/bin/bash

# Check if port argument is provided
if [ -z "$1" ]; then
    echo "Error: Port number required"
    echo "Usage: $0 <port>"
    exit 1
fi

# Validate port number
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Error: Port must be a number"
    exit 1
fi

PORT=$1

# Check if port is in valid range
if [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
    echo "Error: Port must be between 1 and 65535"
    exit 1
fi

# Run lsof command
sudo lsof -i tcp:$PORT
