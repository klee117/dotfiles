# WSL2 external USB drive auto-mount ("usb-drive-anyport")

Runbook + backup for the Seagate One Touch external drive that auto-mounts at
`/mnt/external` inside WSL2. **This directory is the source-of-truth backup** of
a setup whose live files otherwise live in volatile, untracked locations
(`C:\Scripts\`, `/usr/local/sbin/`, `/etc/`, and Windows Task Scheduler).

Last verified end-to-end: **2026-06-27**.

---

## TL;DR recovery

| Symptom | Do this |
|---|---|
| `/mnt/external` empty after a **WSL restart** | Wait ~10s (the `[boot]` script re-triggers the task). Else run the task manually (below). |
| `/mnt/external` empty after **Windows logon** | Run the task manually (below). Check task State is **not** `Queued`. |
| `/mnt/external` **frozen** (`ls` hangs) after a **physical unplug** | `wsl --shutdown` (from PowerShell) → replug to **any** port → reopen WSL. **Do NOT try to remount mid-session** — it hangs on the dead device. |
| Drive never mounts; nothing in logs | Task may be missing/`Queued`/disk absent — see **Troubleshooting**. |

Manual mount (handles ExecutionPolicy + elevation in one shot), from PowerShell:
```
schtasks /run /tn "WSL Mount External"
```

---

## The drive

- Seagate One Touch, **serial `00000000NT326QNC`**, VID:PID `0bc2:ab73`, 1.8 TB.
- ext4 partition, **UUID `ce332bf9-1e1a-4209-9a9b-c466c2c2e83b`**, mounted at `/mnt/external` (holds `projects/`).
- **Device name is NOT stable** (`sdd`/`sde`/`sdf` drift across attaches). Everything keys on **serial** (to attach) and **UUID** (to mount) — never the device name.

## How it works

`wsl --mount --bare` (Hyper-V passthrough, **not** usbip). The disk goes
**Offline on Windows** and appears as a native SCSI disk inside the WSL VM under
the `MSFT1000` Hyper-V host (same SCSI host as the WSL root VHD).

1. **`C:\Scripts\mount-external.ps1`** — finds the disk **by serial**, runs
   `wsl --mount \\.\PhysicalDriveN --bare`, waits for the UUID partition to
   appear, then `mount -a`. Serial lookup = port-independent ("anyport").
   Logs to `C:\Scripts\mount-external.log` (**UTF-16LE** — decode with
   `iconv -f UTF-16LE -t UTF-8`).
2. **fstab**: `UUID=ce332bf9-… /mnt/external ext4 defaults,nofail 0 0`.

### Two auto-mount triggers (both required)

1. **Windows logon** → scheduled task **`WSL Mount External`** (runs as `klee1`,
   `RunLevel Highest` = real High-integrity token, which `wsl --mount`
   requires). This is the only drive task.
2. **WSL VM restart** (`wsl --shutdown` or idle auto-shutdown releases the disk
   back to Windows; the logon task does **not** fire on a mid-session VM
   restart) → `/etc/wsl.conf` `[boot] command = /usr/local/sbin/wsl-boot-mount.sh`
   re-triggers the same task. Runs **synchronously** as root (a backgrounded
   `&` subshell gets killed when the `[boot]` runner tears down). No-ops if
   already mounted. Logs `/var/log/wsl-boot-mount.log`.

## Physical replug to a different port — by design needs a WSL restart

`wsl --shutdown` → unplug → replug to **any** port → reopen WSL. The `[boot]`
command re-attaches by serial and mounts by UUID, so any port works.

**Why mid-session remount can't work without a VM restart:** a hard physical
unplug leaves the ext4 mount pinned to the now-dead device. The kernel blocks
**any** access to the mountpoint in **uninterruptible (D-state) I/O** — so
`ls /mnt/external`, `cd projects`, etc. freeze forever (and so would a remount
script's own health check). `umount -l` detaches the name but can't abort the
hung I/O. Only `wsl --shutdown` (VM teardown) reliably clears the wedge; the
fresh VM re-attaches cleanly by serial. All mid-session live-remount tooling was
**deliberately removed** (2026-06-27) — this is by design, not a regression.

## Files in this backup

| File here | Live location | Notes |
|---|---|---|
| `mount-external.ps1` | `C:\Scripts\mount-external.ps1` | attach-by-serial + mount |
| `wsl-boot-mount.sh` | `/usr/local/sbin/wsl-boot-mount.sh` | root, 0755; WSL `[boot]` trigger |
| `wsl.conf` | `/etc/wsl.conf` | the `[boot] command` line is the relevant bit |
| `fstab.line` | one line of `/etc/fstab` | the UUID mount entry |
| `WSL-Mount-External.task.xml` | Task Scheduler `\WSL Mount External` | re-importable; **only backup of the task** |

## Restore

Run `restore.sh` (with `sudo`) for the Linux side; it copies `wsl-boot-mount.sh`
into place, ensures the fstab line, and ensures the `wsl.conf [boot] command`.
The **Windows side is manual** (Linux can't elevate-register a Windows task):

```powershell
# 1. Script
New-Item -ItemType Directory -Force C:\Scripts | Out-Null
Copy-Item .\mount-external.ps1 C:\Scripts\

# 2. Scheduled task (re-import the XML). The XML declares encoding=UTF-16 but is
#    read as a string, so Get-Content -Raw is correct regardless of byte encoding.
Register-ScheduledTask -TaskName "WSL Mount External" `
  -Xml (Get-Content -Raw .\WSL-Mount-External.task.xml) -User klee1 -Force
```

> Caveat: the task XML embeds a **machine-specific SID** (`S-1-5-21-…-1001`) and
> the trigger user `X13\klee1`. On the **same** machine this just works. On a
> **different** machine, re-create the task instead (logon trigger, run as that
> user, **Run with highest privileges**, **uncheck both battery conditions**,
> action `powershell.exe -ExecutionPolicy Bypass -File C:\Scripts\mount-external.ps1`).

Then apply: `wsl --shutdown` and reopen.

## Troubleshooting (in order)

1. **Is the task `Queued`?** `Get-ScheduledTask 'WSL Mount External'` → `.State`.
   `Queued` = blocked from running (historically the **battery** conditions;
   both must be `False`). `schtasks /run` returns SUCCESS even when Queued and
   the script never runs.
2. **Read `C:\Scripts\mount-external.log`** (UTF-16LE) and
   `/var/log/wsl-boot-mount.log` (plain).
3. **Is the disk present?** `Get-Disk | ? SerialNumber -eq '00000000NT326QNC'`.
   `IsOffline: True` is **correct** (it's passed through to the WSL VM).
4. **Frozen mountpoint after unplug** → `wsl --shutdown`, replug any port,
   reopen. Never remount mid-session.

### Environment gotchas

- `klee1` is a local Administrator; the task's `RunLevel Highest` yields a real
  **High** integrity token. A plain interop shell is **Medium** integrity and
  `wsl --mount` fails `WSL_E_ELEVATION_NEEDED_TO_MOUNT_DISK`. Ad-hoc elevation:
  `Start-Process -Verb RunAs`.
- Windows binaries are **not** on the WSL `$PATH` (`appendWindowsPath=false`) —
  call by full path, e.g.
  `/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe`, `…/schtasks.exe`, `…/wsl.exe`.
- Passwordless root via interop: `wsl.exe -u root -- bash -c '…'`.
- PowerShell **ExecutionPolicy is Restricted** → running `.\*.ps1` interactively
  fails. Prefer `schtasks /run /tn "WSL Mount External"` (the task action uses
  `-ExecutionPolicy Bypass`).
- `blkid -U <uuid>` is an **unreliable** presence probe (stale cache). Judge by
  whether the mountpoint is readable, not by blkid.
- **Mount namespaces:** interop login shell, `wsl -u root -- …`, and the Windows
  task's mount share **one** namespace, so mounts are visible to the user shell.
  systemd PID 1 is a separate namespace.

## Notes

- This backup lives on the **internal** WSL disk (`$HOME`), never on the
  external drive itself (which would be circular). It is versioned in the
  `~/.dotfiles` bare repo. **That repo's remote push is still pending** — until
  then this is local-only (single-machine) backup. A copy of this README + the
  task XML is also dropped in `C:\Scripts\` so the recovery steps are reachable
  from Windows when WSL is down.
