# WSL platform + Windows host

## `/etc/wsl.conf`

Lives inside Ubuntu. Apply changes with `wsl --shutdown` (from PowerShell) then
reopen. The canonical copy is also backed up at
`~/.local/share/usb-external-mount/wsl.conf`. Key settings and why:

```ini
[boot]
systemd = true                                   # run systemd as PID 1
command = /usr/local/sbin/wsl-boot-mount.sh      # re-mount external drive on every WSL start

[automount]
enabled = true
root = "/mnt/"
options = "metadata,umask=22,fmask=11"           # metadata => Linux can store chmod/chown on /mnt (git/ssh need this)
mountFsTab = false

[interop]
enabled = true                                   # allow launching Windows .exe from WSL
appendWindowsPath = false                         # <<< Windows PATH NOT imported into Linux

[network]
generateResolvConf = true
generateHosts = true

[user]
default = klee1
```

### Consequences to remember
- **`appendWindowsPath=false`** → call Windows binaries by full path:
  - `/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe`
  - `/mnt/c/Windows/System32/schtasks.exe`, `…/wsl.exe`
- **Passwordless root via interop:** `wsl.exe -u root -- bash -c '…'` (used to
  edit `/etc/*` and `/usr/local/sbin/*` without a sudo password prompt).
- **Integrity levels:** a plain interop shell is *Medium* integrity; `wsl --mount`
  needs *High* (the external-drive scheduled task runs with `RunLevel Highest`
  for this). Ad-hoc elevation from PowerShell: `Start-Process -Verb RunAs`.
- **Mount namespaces:** the interop login shell, `wsl -u root -- …`, and a
  Windows task's mount share **one** namespace (mounts are visible to your
  shell). systemd PID 1 is a separate namespace.

## Windows-side artifacts

- `C:\Scripts\` — holds `mount-external.ps1`, its log, a copy of the external
  drive runbook, and the exported task XML. See `external-drive.md`.
- Scheduled task **`WSL Mount External`** — the only drive task. Logon-triggered,
  `RunLevel Highest`, **both battery conditions disabled** (laptop — otherwise it
  sits `Queued` forever on battery). Re-importable from the task XML.
- PowerShell **ExecutionPolicy is Restricted** → run `.ps1` via the task
  (`schtasks /run /tn "WSL Mount External"`, action uses `-ExecutionPolicy Bypass`)
  rather than `.\script.ps1`.

## Networking / security (partially captured — verify)
- `ufw` is installed (rules not captured here — check `sudo ufw status`).
- The usb memory notes a WireGuard full-tunnel VPN keeps the WSL subnet
  `172.28.16.0/20` excluded from AllowedIPs (correct for WSL + full-tunnel). Not
  detailed here; reconfigure from the VPN's own config.
