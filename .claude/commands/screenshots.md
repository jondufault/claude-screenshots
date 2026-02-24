---
description: "Open the screenshot manager in a browser tab to capture, name, and save clipboard images to the current directory"
allowed-tools: ["Bash"]
---

# /screenshots — Screenshot Capture Manager

Launch the screenshot manager. A browser tab opens where the user will:
1. Take screenshots (PrtSc or their preferred tool)
2. Press Ctrl+V in the browser tab to capture each one
3. Name each screenshot
4. Save all to the current working directory

## How to launch

Run the screenshot manager as a **background Bash task** (using `run_in_background: true`) so you can monitor when it finishes:

```
screenshot-manager "$PWD"
```

After launching, tell the user the browser tab is open and remind them of the shortcuts:
- **Ctrl+V** to capture a screenshot from clipboard
- **Ctrl+S** to save all and close
- **Esc** to close without saving

**SSH note:** If Claude Code is running on a remote machine, the browser won't open automatically. The URL is printed to stderr — tell the user to open it manually on their local machine (it won't work since the server is on the remote host). For SSH use cases, users should run the screenshot manager directly on their local machine instead.

## Getting results

When the user says they're done (or you want to check), read the background task output using `TaskOutput`. The script outputs JSON to stdout:

```json
{"action": "saved", "directory": "/path/to/dir", "files": [{"file": "name.png", "path": "/full/path/name.png", "width": 1920, "height": 1080}]}
```

The `action` field will be `"saved"`, `"discarded"`, or `"closed"`. Parse this and report the results — list the saved files and offer to view them with the Read tool.
