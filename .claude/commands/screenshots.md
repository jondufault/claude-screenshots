---
description: "Open the screenshot manager GUI to capture, name, and save clipboard images to the current directory"
allowed-tools: ["Bash"]
---

# /screenshots — Screenshot Capture Manager

Launch the screenshot manager window. The user will:
1. Take screenshots (PrtSc or their preferred tool)
2. Press Ctrl+V in the window to capture each one
3. Name each screenshot
4. Save all to the current working directory

## How to launch

Run the screenshot manager as a **background Bash task** (using `run_in_background: true`) so you can monitor when it finishes:

```
screenshot-manager "$PWD"
```

After launching, tell the user the window is open and remind them of the shortcuts:
- **Ctrl+V** to capture a screenshot from clipboard
- **Ctrl+S** to save all and close
- **Esc** to close without saving

## Getting results

When the user says they're done (or you want to check), read the background task output using `TaskOutput`. The script outputs JSON to stdout:

```json
{"action": "saved", "directory": "/path/to/dir", "files": [{"file": "name.png", "path": "/full/path/name.png", "width": 1920, "height": 1080}]}
```

The `action` field will be `"saved"`, `"discarded"`, or `"closed"`. Parse this and report the results — list the saved files and offer to view them with the Read tool.
