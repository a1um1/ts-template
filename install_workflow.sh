#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Clone the current repo's .github/workflows to the target directory
REPO_URL="https://github.com/a1um1/ts-template.git"
TARGET_DIR="$SCRIPT_DIR/.github/workflows"

if [ -z "$REPO_URL" ]; then
  echo "Error: Not inside a git repository or no remote origin set."
  exit 1
fi

# Create target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Clone only the .github/workflows directory using sparse-checkout
TMP_DIR=$(mktemp -d)
git clone --filter=blob:none --no-checkout "$REPO_URL" "$TMP_DIR"
cd "$TMP_DIR"
git sparse-checkout init --cone
git sparse-checkout set workflows
git checkout

# Copy workflows to the original script directory
cp -r workflows "$SCRIPT_DIR/.github/"

# Cleanup
cd "$SCRIPT_DIR"
rm -rf "$TMP_DIR"

echo "Workflows cloned to $TARGET_DIR"