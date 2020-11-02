# This script adds a PC to the Accessdirector group so the user can be Local Admin for some Minutes

$PC = Read-Host "Type Computername : Ex csegotld9285yqz"
$name = get-adcomputer $pc | select samaccountname


Add-ADGroupMember -Identity CEVT-AccessDirector-Computers -Members $name

Get-ADComputer $pc -Properties * | select mem*