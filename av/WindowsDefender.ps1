# av/WindowsDefender.ps1
#
# Copyright 2020 Bill Zissimopoulos

function AvScan-WindowsDefender {
    param (
        $ScanPath,
        $DisplayName
    )

    $AvRoot = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows Defender' -Name InstallLocation
    $AvProg = Join-Path $AvRoot 'MpCmdRun.exe'
    if (-not (Test-Path $AvProg)) {
        $AvProg = 'C:\Program Files\Windows Defender\MpCmdRun.exe'
    }

    $ScanOut = & $AvProg -Scan -ScanType 3 -File $ScanPath -DisableRemediation
    if ($LASTEXITCODE -ne 0) {
        $ThreatDefinitionVersion = (Get-MpComputerStatus).AntispywareSignatureVersion
        Write-ScanOutput "SCAN: MpCmdRun.exe -Scan -ScanType 3 -File `"$DisplayName`" -DisableRemediation"
        Write-ScanOutput "Threat Definition Version: $ThreatDefinitionVersion`n"
        Write-ScanOutput $ScanOut
    }
}
