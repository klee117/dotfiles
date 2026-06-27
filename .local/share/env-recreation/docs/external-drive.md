# External USB drive auto-mount

This has its own **self-contained kit** — don't duplicate it here. See:

**`~/.local/share/usb-external-mount/README.md`** (full runbook + backup of every
script/config + the re-importable scheduled-task XML + `restore.sh`).

## One-paragraph summary
A Seagate One Touch (serial `00000000NT326QNC`, ext4 UUID `ce332bf9-…`) is
attached to the WSL VM via **`wsl --mount --bare`** (Hyper-V passthrough, keyed
by **disk serial** so any USB port works) and mounted by **UUID** at
`/mnt/external`. `~/projects` is a symlink to `/mnt/external/projects`. Two
triggers keep it mounted: the **`WSL Mount External`** scheduled task at Windows
logon, and the `/etc/wsl.conf` `[boot]` command on every WSL restart. The task
must have both **battery conditions disabled** (laptop) or it sits `Queued`.

## On a new machine
- If there's no external drive, skip — but note `~/projects` (and several
  `.bashrc` aliases that point into it) won't resolve.
- If there is: install `C:\Scripts\mount-external.ps1`, re-import the task from
  `WSL-Mount-External.task.xml`, run `restore.sh` for the Linux side. The
  serial/UUID in the scripts are specific to *that* drive — update them for a
  different disk. Full steps in the kit's README.

## Recovery quick-ref
- Empty after a WSL restart → wait ~10s, or `schtasks /run /tn "WSL Mount External"`.
- **Frozen `/mnt/external` (`ls` hangs) after an unplug** → `wsl --shutdown`,
  replug any port, reopen. Never remount mid-session (it hangs on the dead device).
