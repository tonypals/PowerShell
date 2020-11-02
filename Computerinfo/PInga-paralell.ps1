$computers = Get-ADComputer -Filter  { name -like "csegotl1*"}  | Select -ExpandProperty DNSHostName 

$computers.Count

Write-Host "med paralell"

Measure-command { 102..150 | foreach-object -parallel { $ping = New-Object System.Net.Networkinformation.Ping ; $ping.send("172.31.201.$_")}}

write-host "utan paralell"

Measure-command { 102..150 | foreach-object { $ping = New-Object System.Net.Networkinformation.Ping ; $ping.send("172.31.201.$_")}}

