Add-Type -AssemblyName System.Windows.Forms
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
$folderBrowser.Description = "Select a folder to save the system info file"
$null = $folderBrowser.ShowDialog()

if (-not $folderBrowser.SelectedPath) {
    Write-Host "No folder selected. Script aborted."
    exit
}

$outputFile = Join-Path $folderBrowser.SelectedPath "pc2dollar.txt"

# Get system info using WMI/CIM
$computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
$processor = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1
$gpus = Get-CimInstance Win32_VideoController |
    Where-Object { $_.Name -notmatch 'basic|usb|virtual|mirage|microsoft' }
$ram = [Math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
$storageDevices = Get-CimInstance -ClassName Win32_DiskDrive

# Format the output
$output = @()
$output += "• Model and Motherboard: $($computerSystem.Manufacturer), $($computerSystem.Model)
"
$output += "• Processor: $($processor.Name.Trim())
"
$output += "• Graphics: $($graphics.Name.Trim())
"
$output += "• RAM: ${ram} GB
"
$output += "• Graphic card/s:"
$output += $gpus | ForEach-Object {
    $gpu = $_.Name.Trim()
      "  - $gpu"
}
$output += "
• Storage:"
$output += $storageDevices | ForEach-Object {
    $model = $_.Model.Trim()
    $sizeGB = [Math]::Round($_.Size / 1GB, 2)
    "  - $model ($sizeGB GB)"
}

# Write to file
$output | Out-File -FilePath $outputFile -Encoding UTF8

# Notify user
Write-Host "System information saved to: $outputFile"
