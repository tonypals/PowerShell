<#

    This will install multiple Microsoft Standalone Updates from the specified location silently and without rebooting after each update.
    You have the option of rebooting after all of the updates have been installed.  Two logs are crated, an output log from WUSA that has
    to be read with Event Viewer (.evtx extension) and a transcript log to give you an idea of what's going on (.log extension).

#>

#Create Transcript Log for Troubleshooting
$VerbosePreference = 'Continue'
$LogPath = "c:\temp"
Get-ChildItem "$LogPath\*.log" | Where-Object LastWriteTime -LT (Get-Date).AddDays(-15) | Remove-Item -Confirm:$false
$LogPathName = Join-Path -Path $LogPath -ChildPath "windowsUpdates-$(Get-Date -Format 'yyyy.MM.dd-HH.mm').log"
Start-Transcript $LogPathName

#$Location = Read-Host 'Where are the MSU files located? (complete path with ending \)'
$Location = "C:\Users\tony.palsson\Downloads\WHDownloader_0.0.2.3\Updates\Windows10-x64\General"

$Reboot = Read-Host 'Do you want to reboot after all updates are installed? (Yes/No)'

$FileTime = Get-Date -format 'yyyy.MM.dd-HH.mm.ss'

$Updates = (Get-ChildItem $Location -Recurse | Where-Object {$_.Extension -eq '.msu'} | Sort-Object {$_.LastWriteTime} )
$Qty = $Updates.count


if (!(Test-Path $env:systemroot\SysWOW64\wusa.exe)){
  $Wus = "$env:systemroot\System32\wusa.exe"
}
else {
  $Wus = "$env:systemroot\SysWOW64\wusa.exe"
}

if (!(Test-Path c:\Temp)){
  New-Item c:\Temp
}

if (Test-Path c:\Temp\Wusa.evtx){
  Rename-Item c:\Temp\Wusa.evtx c:\Temp\Wusa.$FileTime.evtx
}

foreach ($Update in $Updates)
{
  Write-Information "Starting Update $Qty - `r`n$Update"
  Start-Process -FilePath $Wus -ArgumentList ($Update.FullName, '/quiet', '/norestart', "/log:c:\Temp\Wusa.log") -Wait
  Write-Information "Finished Update $Qty"
  if (Test-Path c:\Temp\Wusa.log){
   # Rename-Item c:\Temp\Wusa.log c:\Temp\Wusa.$FileTime.evtx
  }

  Write-Information '-------------------------------------------------------------------------------------------'

  $Qty = --$Qty

  if ($Qty -eq 0){
    if ($Reboot -like 'Y*'){
      Restart-Computer
    }
  }
}

#Close Transcript Log for Troubleshooting
Stop-Transcript

get-mshotfix | select hotfixid
(get-mshotfix | select hotfixid).count