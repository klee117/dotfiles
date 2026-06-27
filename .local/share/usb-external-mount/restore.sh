#!/usr/bin/env bash
# restore.sh — re-install the Linux side of the usb-drive-anyport setup from this
# backup directory. Idempotent. Run as root:  sudo ./restore.sh
#
# The WINDOWS side (C:\Scripts\mount-external.ps1 + the "WSL Mount External"
# scheduled task) is NOT handled here — Linux can't elevate-register a Windows
# task. See README.md "Restore" for the PowerShell steps.
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
FSTAB_LINE='UUID=ce332bf9-1e1a-4209-9a9b-c466c2c2e83b /mnt/external ext4 defaults,nofail 0 0'
BOOT_CMD='command = /usr/local/sbin/wsl-boot-mount.sh'

if [ "$(id -u)" -ne 0 ]; then echo "Run as root: sudo $0" >&2; exit 1; fi

echo "[1/4] install /usr/local/sbin/wsl-boot-mount.sh"
install -m 0755 -o root -g root "$DIR/wsl-boot-mount.sh" /usr/local/sbin/wsl-boot-mount.sh

echo "[2/4] ensure mountpoint /mnt/external"
mkdir -p /mnt/external

echo "[3/4] ensure fstab entry"
if grep -q 'ce332bf9-1e1a-4209-9a9b-c466c2c2e83b' /etc/fstab; then
  echo "      already present"
else
  printf '%s\n' "$FSTAB_LINE" >> /etc/fstab
  echo "      added"
fi

echo "[4/4] ensure /etc/wsl.conf [boot] command"
if [ ! -f /etc/wsl.conf ]; then
  install -m 0644 "$DIR/wsl.conf" /etc/wsl.conf
  echo "      installed wsl.conf from backup"
elif grep -qF 'wsl-boot-mount.sh' /etc/wsl.conf; then
  echo "      [boot] command already present"
else
  echo "      WARNING: /etc/wsl.conf exists but has no wsl-boot-mount.sh command."
  echo "      Add under a [boot] section:  $BOOT_CMD"
  echo "      (reference copy: $DIR/wsl.conf)"
fi

echo
echo "Linux side done. Now do the Windows side (see README.md), then:"
echo "  wsl --shutdown   # from PowerShell, then reopen WSL"
