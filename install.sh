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
missing=()
python3 -c "import tkinter" 2>/dev/null || missing+=("tkinter (apt install python3-tk, or dnf install python3-tkinter)")
python3 -c "import PIL" 2>/dev/null || missing+=("Pillow (pip install Pillow)")

case "$(uname -s)" in
    Linux*)
        command -v wl-paste &>/dev/null || command -v xclip &>/dev/null || \
            missing+=("wl-paste or xclip (for clipboard access)")
        ;;
esac

if [[ ${#missing[@]} -gt 0 ]]; then
    echo ""
    echo "Missing dependencies:"
    for dep in "${missing[@]}"; do
        echo "  - $dep"
    done
fi

echo ""
echo "Done! Use /screenshots in Claude Code to launch the manager."
