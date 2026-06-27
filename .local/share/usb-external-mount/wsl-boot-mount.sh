#!/bin/sh
# wsl-boot-mount.sh — triggered by /etc/wsl.conf [boot] command on every WSL start.
#
# Why: a WSL VM restart (idle auto-shutdown or `wsl --shutdown`) releases the
# `wsl --mount --bare` external disk back to Windows (-> Online), and the only
# remount trigger was the *Windows logon* scheduled task. So after a mid-session
# VM restart the drive stayed unmounted. This re-triggers the pre-elevated
# Windows task "WSL Mount External" (which does wsl --mount --bare + mount -a)
# on every WSL boot, closing that gap with no Windows logon required.
#
# Runs synchronously as root. `schtasks /run` is fire-and-forget on the Windows
# side (the attach+mount happen asynchronously inside the task), so this returns
# in ~1s in the normal case and does not meaningfully block WSL boot. It is NOT
# backgrounded: a forked subshell gets killed when the [boot] runner / interop
# session that launched the script tears down.
LOG=/var/log/wsl-boot-mount.log
SCHTASKS=/mnt/c/Windows/System32/schtasks.exe
log() { echo "$(date '+%Y-%m-%d %H:%M:%S')  $*" >> "$LOG" 2>/dev/null; }

log "=== boot-mount start (pid $$) ==="
if mountpoint -q /mnt/external; then log "already mounted; nothing to do"; exit 0; fi

# Wait for Windows interop (/mnt/c automount) to be ready, up to ~20s.
i=0
while [ ! -e "$SCHTASKS" ] && [ "$i" -lt 20 ]; do sleep 1; i=$((i+1)); done
if [ ! -e "$SCHTASKS" ]; then log "schtasks.exe unavailable after ${i}s; abort"; exit 0; fi

log "interop ready after ${i}s; triggering 'WSL Mount External'"
"$SCHTASKS" /run /tn "WSL Mount External" >> "$LOG" 2>&1
log "schtasks /run rc=$?"
exit 0
