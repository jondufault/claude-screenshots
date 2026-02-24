#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="${HOME}/.claude/commands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Pick install directory
case "$(uname -s)" in
    MINGW*|MSYS*|CYGWIN*)
        BIN_DIR="${LOCALAPPDATA:-$HOME/AppData/Local}/Programs/screenshot-manager"
        mkdir -p "$BIN_DIR"
        cp "$SCRIPT_DIR/screenshot-manager" "$BIN_DIR/screenshot-manager"
        echo "Installed screenshot-manager to $BIN_DIR/screenshot-manager"
        echo ""
        echo "NOTE: Add $BIN_DIR to your PATH if it isn't already."
        ;;
    *)
        BIN_DIR="${HOME}/.local/bin"
        mkdir -p "$BIN_DIR"
        cp "$SCRIPT_DIR/screenshot-manager" "$BIN_DIR/screenshot-manager"
        chmod +x "$BIN_DIR/screenshot-manager"
        echo "Installed screenshot-manager to $BIN_DIR/screenshot-manager"
        if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
            echo ""
            echo "NOTE: $BIN_DIR is not in your PATH."
            echo "Add this to your shell profile (~/.bashrc or ~/.zshrc):"
            echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        fi
        ;;
esac

# Install the Claude Code skill
mkdir -p "$SKILL_DIR"
cp "$SCRIPT_DIR/.claude/commands/screenshots.md" "$SKILL_DIR/screenshots.md"
echo "Installed Claude Code skill to $SKILL_DIR/screenshots.md"

# Check dependencies
if ! command -v python3 &>/dev/null; then
    echo ""
    echo "Missing dependency:"
    echo "  - Python 3 (required)"
fi

echo ""
echo "Done! Use /screenshots in Claude Code to launch the manager."
