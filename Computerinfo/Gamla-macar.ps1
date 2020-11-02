 $DaysAgo=(Get-Date).AddDays(-60)



 $path = "c:\temp\Macs_lastlogintimestamp-earlierthan_60_days.csv"

 Get-Adcomputer -Filter {(LastLogonTimeSTamp -gt $DaysAgo)} -Properties PwdLastSet,LastLogonTimeStamp,Description -SearchBase "OU=Mac,OU=GD Computers,OU=CEVT,DC=auto,DC=geely,DC=com"|

Select-Object -Property Name,Enabled,Description, `

@{Name="PwdLastSet";Expression={[datetime]::FromFileTime($_.PwdLastSet)}}, `

@{Name="LastLogonTimeStamp";Expression={[datetime]::FromFileTime($_.LastLogonTimeStamp)}} |

Export-Csv -Path $path -NoTypeInformation -Delimiter ";"

ii $path