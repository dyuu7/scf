# Reproducible PowerShell (pwsh) Profile

A small, reusable setup to rebuild your pwsh environment after a fresh install.  
Works on **Windows / macOS / Linux** and favors **fast startup** with **idempotent** install scripts.

## Features
- Prompt via **oh-my-posh**
- Node version manager **fnm** (auto switch on `cd`)
- Quick directory jumps with **ZLocation**
- Optional **PSReadLine** tweaks (history prediction, ListView)
- Robust installer: **symlink first**, **copy as fallback**, backups of existing profile
- Local overrides via `local.profile.ps1`
- Theme selection priority: `theme.omp.json` in repo → `$env:POSH_THEMES_PATH/huvix.omp.json` → oh-my-posh default

## Repository Layout
```

.
├── Microsoft.PowerShell_profile.ps1
├── README.md
├── scripts
│   ├── bootstrap.ps1      # Install dependencies (winget/brew/apt…)
│   ├── install.ps1        # Link/copy profile to $PROFILE
│   └── uninstall.ps1      # Remove created symlink (if any)
└── theme.omp.json         # Optional: your oh-my-posh theme for full reproducibility

````

## Quick Start

1. **Clone this repo**
   ```powershell
   git clone <your-repo-url> pwsh && cd pwsh
````

2. **Install dependencies** (oh-my-posh / fnm / ZLocation).
   Skips what’s already installed; supports winget/brew/apt/etc.

   ```powershell
   pwsh -NoLogo -NoProfile -ExecutionPolicy Bypass -File ./scripts/bootstrap.ps1
   ```

   *Skip anything you don’t want:*

   ```powershell
   # examples
   pwsh -NoLogo -NoProfile -File ./scripts/bootstrap.ps1 -InstallZLocation:$false
   pwsh -NoLogo -NoProfile -File ./scripts/bootstrap.ps1 -InstallOhMyPosh:$false -InstallFnm:$false
   ```

3. **Install the profile** (creates a symlink to `$PROFILE`; falls back to copy)

   ```powershell
   pwsh -NoLogo -NoProfile -File ./scripts/install.ps1
   ```

   *If symlinks are restricted (Windows without Developer Mode/admin), force copy:*

   ```powershell
   pwsh -NoLogo -NoProfile -File ./scripts/install.ps1 -Copy
   ```

4. **Restart your terminal**.

## Usage

* The prompt is powered by **oh-my-posh**. If `./theme.omp.json` exists, it will be used automatically.
* **fnm**: when you `cd` into a project containing `.node-version` / `.nvmrc`, the Node version switches automatically.
* **ZLocation**: jump to frequently used folders quickly (e.g., `z foo`).
* **PSReadLine**: history prediction with ListView; standard Windows edit mode.

## Customize

* **Prompt theme**: put a `theme.omp.json` at repo root for a fully reproducible prompt.
* **Local machine overrides**: create `local.profile.ps1` next to `Microsoft.PowerShell_profile.ps1` for private, untracked settings. It’s auto-sourced if present.

## Uninstall

```powershell
pwsh -NoLogo -NoProfile -File ./scripts/uninstall.ps1
```

> Removes the symlink if one was created. Regular files are left untouched.

## Notes

* **PowerShell 7+** recommended.
* `$PROFILE` paths:

  * Windows: `C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
  * macOS/Linux: `~/.config/powershell/Microsoft.PowerShell_profile.ps1`
* If symlink creation fails on Windows, use **Developer Mode** or run as **Administrator**, or just pass `-Copy`.
