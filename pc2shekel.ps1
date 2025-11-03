Add-Type -AssemblyName System.Windows.Forms
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Select a folder to save the system info file"
$null = $folderBrowser.ShowDialog()

if (-not $folderBrowser.SelectedPath) {
    Write-Host "No folder selected. Script aborted."
    exit
}

$outputFile = Join-Path $folderBrowser.SelectedPath "pc2shekel.txt"

# Get system info using WMI/CIM
$computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
$processor = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1
$gpus = Get-CimInstance Win32_VideoController |
    Where-Object { $_.Name -notmatch 'basic|usb|virtual|mirage|microsoft' }

# Per-stick RAM details
$memModules = Get-CimInstance -ClassName Win32_PhysicalMemory -ErrorAction SilentlyContinue
$storageDevices = Get-CimInstance -ClassName Win32_DiskDrive
$os = Get-CimInstance -ClassName Win32_OperatingSystem 

# Format the output
$output = @()
$output += "$($os.Caption.Trim()) (Version $($os.Version)) :מערכת הפעלה •
" 
$output += "$($computerSystem.Manufacturer), $($computerSystem.Model) :מודל ולוח אם •"

$output += "
$($processor.Name.Trim()) :מעבד •"

$output += "
:זיכרון ראם •"

if ($memModules) {
    $totalCapBytes = 0
    foreach ($m in $memModules) {
        $capGB = [Math]::Round(($m.Capacity / 1GB), 2)
        $totalCapBytes += $m.Capacity

        $mhz = if ($m.ConfiguredClockSpeed) { $m.ConfiguredClockSpeed } else { $m.Speed }
        $slot = if ($m.DeviceLocator) { $m.DeviceLocator } elseif ($m.BankLabel) { $m.BankLabel } else { $null }

        $line = "  - {0}GB @ {1} MHz{2}" -f $capGB, ($(if($mhz){$mhz}else{"N/A"})), ($(if($slot){" ($slot)"}else{""}))
        $output += $line
    }

    # Add total RAM line
    $totalGB = [Math]::Round(($totalCapBytes / 1GB), 2)
    $output += "  - Total RAM size: $totalGB GB"
} else {
    # Fallback: total only
    $totalRamGB = [Math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
    $output += "  - Total RAM size: $totalRamGB GB"
}

$output += "
:כרטיס/י מסך •"
$output += $gpus | ForEach-Object {
    $gpu = $_.Name.Trim()
        "  - $gpu"
}
$output += "
אחסון •"
$output += $storageDevices | ForEach-Object {
    $model = $_.Model.Trim()
    $sizeGB = [Math]::Round($_.Size / 1GB, 2)
    "  - $model ($sizeGB GB)"
}

# Write to file
$output | Out-File -FilePath $outputFile -Encoding Unicode

# Notify user
Write-Host "System information saved to: $outputFile"
