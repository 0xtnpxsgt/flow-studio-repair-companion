# Automatic repair — Windows setup

Automatic repair is optional. Normal video generation works without it. Set it up once per computer; afterwards nothing needs to stay open.

## 1. Install Node.js

Download **Node.js LTS** from https://nodejs.org and install it with the default options. Skip this if it is already installed.

## 2. Install AGY

Open **PowerShell** from the Start menu, paste this and press Enter:

```powershell
irm https://antigravity.google/cli/install.ps1 | iex
```

Wait for it to finish, then close and reopen PowerShell. (Official guide: https://www.antigravity.google/docs/cli/install/)

## 3. Sign in to AGY

In PowerShell run:

```powershell
agy
```

Finish the Google sign-in if asked. When AGY's main screen appears, close it. Repair uses your AGY account and its usage limits.
If `agy` is not recognized, use `& "$env:LOCALAPPDATA\agy\bin\agy.exe"`.

## 4. Install the repair companion

1. Unzip **flow-studio-repair-companion** somewhere permanent (for example `Documents\flow-studio-repair-companion`).
2. Double-click **Install Repair.cmd** inside it.
3. Wait for **Self-test OK**, then close the window.

The installer registers the companion with Chrome and Edge for your Windows user only (no admin rights). If you move the folder later, run the installer again. To remove it, double-click **Uninstall Repair.cmd**.

## 5. Switch repair on

1. In Chrome, reload the extension (or restart Chrome).
2. Open the extension's **Repair** tab.
3. Check **Enable local prompt repair** and click **Save repair preferences**.
4. Click **Test repair connection**. It should say **Ready**.

Run your queue normally. When Flow refuses a prompt, Chrome starts the repair companion by itself, the prompt is repaired (up to your selected number of rounds) and generated again. No terminal window, nothing to keep open.

## If something goes wrong

The prompt's card tells you what to do. Common messages:

- **"auto-repair is not installed on this PC"** — run step 4.
- **"does not allow this extension"** — the companion was installed for another copy of the extension. Run **Install Repair.cmd** again (from the newest companion download).
- **"could not start"** — install Node.js (step 1), run the installer again, and check `native-host\host.log` in the companion folder.
- **"repair could not finish (...)"** — usually AGY is not signed in or its account limit was reached. Fix that and press Retry.
- **"Needs prompt edit"** — a safe repair could not keep the locked content; edit the prompt yourself.

A refused prompt is never resent unchanged because of a repair problem: it waits for you with the reason.

Repairs are saved on your PC in the companion folder's `repair-history`. Do not share that folder: it contains your prompts.
