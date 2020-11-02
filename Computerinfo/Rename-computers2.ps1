$oldcomputernames = get-adcomputer -filter * -SearchBase "OU=GOT,OU=Computers,OU=LYNKCO,DC=auto,DC=geely,DC=com" | where {$_.name –like “c*”} | select name*

#OldComputername = get-adcomputer -filter * -SearchBase "OU=LYNKCO Computers,OU=CEVT,DC=auto,DC=geely,DC=com" | where {$_.name –like “c*”} | select name*

foreach ($oldcomputername in $oldcomputernames) {

$NewComputername = $OldComputername.Name -replace ("^c", "L")

#Rename-Computer -NewName $NewComputername -ComputerName $OldComputername -WhatIf


Write-Output  $OldComputername
Write-Output  $NewComputername

}








