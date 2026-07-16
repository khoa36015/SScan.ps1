param(
    [string]$Target = "127.0.0.1",
    [int]$StartPort = 1,
    [int]$EndPort = 65535,
    [int]$Timeout = 1000
)

Write-Host "Scanning $Target from port $StartPort to $EndPort ...`n" -ForegroundColor Cyan

$openPorts = @()

for ($port = $StartPort; $port -le $EndPort; $port++) {
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $connect = $client.BeginConnect($Target, $port, $null, $null)
        $wait = $connect.AsyncWaitHandle.WaitOne($Timeout, $false)

        if ($wait -and $client.Connected) {
            Write-Host "[OPEN] Port $port" -ForegroundColor Green

            # --- Banner grabbing ---
            try {
                $stream = $client.GetStream()
                $stream.ReadTimeout = 500
                $buffer = New-Object byte[] 1024
                $read = $stream.Read($buffer, 0, $buffer.Length)
                if ($read -gt 0) {
                    $banner = [System.Text.Encoding]::ASCII.GetString($buffer, 0, $read)
                    foreach ($line in ($banner -split "`r`n|`n")) {
                        if ($line.Trim() -ne "") {
                            Write-Host "       Banner: $($line.Trim())" -ForegroundColor Yellow
                        }
                    }
                }
                $stream.Close()
            }
            catch {
                # No banner / timeout
            }
            # -----------------------

            $client.Close()
            $openPorts += $port
        }
    }
    catch {
        # Port closed / unreachable
    }

    # Progress
    if ($port % 1000 -eq 0) {
        Write-Host "[*] $port / $EndPort ports checked" -ForegroundColor DarkGray
    }
}

Write-Host "`n[DONE] Open ports: $($openPorts -join ', ')" -ForegroundColor Cyan
if ($openPorts.Count -eq 0) { Write-Host "[DONE] No open ports found." -ForegroundColor Red }
