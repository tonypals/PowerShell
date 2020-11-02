$Date = get-date -Format d

Get-adcomputer -Filter {operatingsystem -like 'mac*' -and enabled -eq $true} -Properties * | 
select name,
lastlogondate |

Export-csv -Path c:\temp\AllMacsFromAD-$Date.csv -Delimiter ";" -NoTypeInformation

ii c:\temp\AllMacsFromAD-$Date.csv