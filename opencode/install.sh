#!/bin/bash
# OpenCode Configuration Installer
# This script symlinks the converted QADS configuration to ~/.config/opencode/

set -e

OPENCODE_CONFIG_DIR="$HOME/.config/opencode"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/opencode"

echo "Installing QADS v4.0 OpenCode configuration..."
echo "Source: $SOURCE_DIR"
echo "Target: $OPENCODE_CONFIG_DIR"

# Create config directory if it doesn't exist
mkdir -p "$OPENCODE_CONFIG_DIR"

# Backup existing config if it exists
if [ -f "$OPENCODE_CONFIG_DIR/opencode.json" ]; then
    echo "Backing up existing opencode.json..."
    cp "$OPENCODE_CONFIG_DIR/opencode.json" "$OPENCODE_CONFIG_DIR/opencode.json.backup"
fi

# Create symlinks
echo "Creating symlinks..."

# Main config
if [ -f "$SOURCE_DIR/opencode.json" ]; then
    ln -sf "$SOURCE_DIR/opencode.json" "$OPENCODE_CONFIG_DIR/opencode.json"
    echo "✓ Linked opencode.json"
fi

# AGENTS.md
if [ -f "$SOURCE_DIR/AGENTS.md" ]; then
    ln -sf "$SOURCE_DIR/AGENTS.md" "$OPENCODE_CONFIG_DIR/AGENTS.md"
    echo "✓ Linked AGENTS.md"
fi

# Agent directory
if [ -d "$SOURCE_DIR/agent" ]; then
    ln -sf "$SOURCE_DIR/agent" "$OPENCODE_CONFIG_DIR/agent"
    echo "✓ Linked agent directory"
fi

# Command directory
if [ -d "$SOURCE_DIR/command" ]; then
    ln -sf "$SOURCE_DIR/command" "$OPENCODE_CONFIG_DIR/command"
    echo "✓ Linked command directory"
fi

# Rules integrated into AGENTS.md - no separate rules directory

echo ""
echo "Installation complete!"
echo ""
echo "To use the QADS framework in OpenCode:"
echo "1. Restart OpenCode or run 'opencode auth login' if needed"
echo "2. Use @mention to invoke agents: @chris-architect, @sergei-perfectionist-coder, etc."
echo "3. Use workflow commands: /plan, /work, /play, /sprint"
echo ""
echo "Available agents:"
echo "  - chris-architect: Sprint planning and architecture"
echo "  - sergei-perfectionist-coder: Code implementation with CI verification"
echo "  - patrick-auditor: Code review and quality assurance"
echo "  - max-devops-engineer: Repository management and CI/CD"
echo "  - And 6 more specialized agents..."
echo ""
echo "Workflow commands:"
echo "  - /plan: Sprint planning with issue consolidation"
echo "  - /work: Implementation with fraud-proof CI protocols"
echo "  - /play: Defect discovery and evidence collection"
echo "  - /sprint: Complete sprint cycle"
