$ProcessName = "onedrive"
Clear-Host
if((get-process $ProcessName -ErrorAction SilentlyContinue) -eq $Null)

    { Write-Host "Process is not running and all TMP-files are deleted" -ForegroundColor green}
else
    { get-process onedrive | stop-process -Verbose -Force
    Write-host "The Onedrive-Process is stopped"} 

Set-Location 'C:\Users\tony.palsson\OneDrive - CEVT\Test'

remove-item *.tmp


get-childitem *.tmp

Start-Process "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"  -ErrorAction SilentlyContinue


Get-Package | sort-object name | where-object {$_.name -like "net*"} | Uninstall-Package -force
Get-Package | sort-object name | where-object {$_.name -like "net*"} 
get-process oned*

msiexec /x {2F6B8D25-4398-4CFB-83DF-A38479415300} PWD=D4533E-AA12-62CA




