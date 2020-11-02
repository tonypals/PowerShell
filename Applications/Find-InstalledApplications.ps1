get-itemproperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
sort displayname |
Format-Table –AutoSize

get-itemproperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
sort displayname |
Format-Table –AutoSize


Get-WmiObject -Class win32_product | where {$_.name -like "net*"}

Get-WmiObject -Class win32_product | where {$_.name -like "*es-es*"}

Get-WmiObject -Class win32_product  | select name