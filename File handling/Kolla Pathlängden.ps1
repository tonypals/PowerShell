


   If (!(Test-Path r:))
    {
    New-PSDrive -Name r -PSProvider FileSystem –Root "\\segot-s040\gd"
    }
    else { cls
     }

$date = get-date -Format d
$path = "H:\Exports\departments"


$AllFolders = Get-ChildItem -Directory -Path 'r:\departments' -Recurse -Force

cd r:
cd departments


 cmd /c "dir /b /s /a" | ForEach-Object { if ($_.length -gt 250) {$_ | Out-File -append h:\exports\longfilepath.txt}} -Verbose

ii h:\exports\longfilepath.txt