# Flow Studio repair - setup

**Users: follow [QUICK-START.md](QUICK-START.md).** Since v1.8.0 the repair companion is installed once with **Install Repair.cmd** and Chrome starts it by itself (Native Messaging) - no terminal window, no pairing token.

**Publishing:** see [PUBLISHING.md](PUBLISHING.md).

## Developer fallback (optional)

The old local helper still works for development: double-click **Start Repair Helper.cmd**, keep its window open, and paste its pairing token under **Developer helper token (optional)** in the Repair tab. The extension uses the installed companion first and only falls back to the helper when the companion is not installed.

## Notes from earlier versions

This is a separate experimental extension. The original `flow-automator` is untouched.

1. In Chrome's Extensions page, enable Developer mode and **Load unpacked** the extension folder you downloaded. Disable the original while testing so the two automations do not compete.
2. Start the companion: double-click **Start Repair Helper.cmd** in the extension folder, or in PowerShell inside that folder run:

   ```powershell
   node repair-helper.cjs
   ```

3. Copy the printed pairing token to **Repair**, enable it and save repair preferences. Keep the helper terminal open.

Uses the existing local AGY installation and model `gemini-3.8-flash-high`. Set `FLOW_REPAIR_MODEL` to change the model or `FLOW_REPAIR_AGY` to select its executable. AGY must already be signed in. AI usage is charged through that existing account.

Only explicit policy/flag/restriction failures invoke repair. Download failures, quotas and ordinary timeouts use existing handling. A scene gets up to the selected repair limit (default 3); each accepted revision gets a generation attempt, separate from normal technical retries. Concat groups require manual revision. Repair occupies its worker until complete; other workers can continue. The helper accepts one repair at a time; busy/unavailable helpers fall back to existing retries.

The helper uses a fresh text-only request in sandboxed plan mode, not DramaFactory's production watcher. It does not run `fix-skipped.ps1`, send Telegram messages, rotate accounts, or modify DramaFactory files. The local validation locks reference tags and explicit second values. Dialogue can change when needed for safety; the model is instructed to retain language, speakers and scene intent. These semantic constraints cannot be proven by the local checks. Review repaired output during initial testing.

Accepted original/revised pairs are stored in `repair-history` in this copy. The loaded queue uses the repaired prompt; source project prompt files are unchanged. Stopping the queue prevents a late repair response from resubmitting, although the helper may finish its current request. Stop the helper with Ctrl+C. The token is local to this copy; do not distribute `.repair-token` or `repair-history` to the community.

Live AGY repair has been exercised on real Flow policy refusals (v1.6.0). v1.7.0 adds the stronger validator below; its unit tests pass, and its own live run is pending.

See [REPAIR-UPGRADE.md](REPAIR-UPGRADE.md) for v1.6.0 limits and validation coverage.