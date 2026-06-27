$serial = "00000000NT326QNC"
$uuid   = "ce332bf9-1e1a-4209-9a9b-c466c2c2e83b"
$log    = "C:\Scripts\mount-external.log"

function Log($m) { "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $m" | Tee-Object -FilePath $log -Append | Out-Null }

Log "=== run start (whoami=$(whoami)) ==="
$disk = Get-Disk | Where-Object { $_.SerialNumber.Trim() -eq $serial }
if (-not $disk) { Log "disk with serial $serial NOT found; aborting"; return }
Log "found disk #$($disk.Number) status=$($disk.OperationalStatus)"

wsl.exe --mount "\\.\PhysicalDrive$($disk.Number)" --bare 2>&1 | ForEach-Object { Log "wsl --mount: $_" }
Log "wsl --mount exit code: $LASTEXITCODE"

# Wait for the partition (by UUID) to appear in WSL, then mount /mnt/external.
$elapsed = 0
do {
    Start-Sleep -Seconds 2
    $elapsed += 2
    $seen = (wsl.exe -u root -- lsblk -no UUID 2>$null) -match $uuid
} while (-not $seen -and $elapsed -lt 60)
Log "UUID device seen=$([bool]$seen) after ${elapsed}s"

wsl.exe -u root -- mount -a 2>&1 | ForEach-Object { Log "mount -a: $_" }
wsl.exe -u root -- mountpoint -q /mnt/external
$mounted = ($LASTEXITCODE -eq 0)
Log "=== run end; /mnt/external mounted=$mounted ==="
