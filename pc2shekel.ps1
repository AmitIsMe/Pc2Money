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

$ram = [Math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
$storageDevices = Get-CimInstance -ClassName Win32_DiskDrive

# Format the output
$output = @()
$output += "$($computerSystem.Manufacturer), $($computerSystem.Model) :מודל ולוח אם •"
$output += "
$($processor.Name.Trim()) :מעבד •"
$output += "
$($ram)GB :זיכרון ראם •"
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
