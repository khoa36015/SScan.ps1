# SScan.ps1

A PowerShell port scanner script for scanning TCP ports on a specified target.

## Usage

```powershell
.\SScan.ps1 -Target 192.168.1.1 -StartPort 1 -EndPort 1024 -Timeout 500
```

## Parameters

- `-Target` (string) — The IP address or hostname to scan. Example: `192.168.1.1`.
- `-StartPort` (int) — The first TCP port in the scan range. Example: `1`.
- `-EndPort` (int) — The last TCP port in the scan range. Example: `1024`.
- `-Timeout` (int) — Timeout for each port probe. Typically specified in milliseconds (e.g., `500` = 0.5 seconds). If your script uses a different unit, adjust accordingly.

## What this does

- Scans TCP ports from `StartPort` through `EndPort` on the specified `Target`.
- Each port probe waits up to `Timeout` (per probe) before considering the port filtered or unresponsive.
- The script prints results to the console; it may also support saving results to a file if an output parameter is implemented.

## Example

```powershell
# Scan ports 1–1024 on 192.168.1.1 with a 500 ms timeout per port
.\SScan.ps1 -Target 192.168.1.1 -StartPort 1 -EndPort 1024 -Timeout 500
```

## Notes and safety

- Only scan systems you own or have explicit permission to test. Unauthorized scanning may be illegal.
- Lower `Timeout` values speed up scans but may miss slow responses; increase `Timeout` on high-latency networks.
- Ensure PowerShell execution policy allows running scripts (e.g., `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`).

## Contributing

Contributions are welcome. Open an issue or submit a pull request to suggest changes or report bugs.

## License

Add a license (for example, MIT) if you want to make licensing explicit.
