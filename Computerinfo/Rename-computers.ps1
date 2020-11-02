cls
$name = hostname
$Serial = (gwmi win32_bios).serialnumber
$Computers = Get-adcomputer -filter {Name -like 'segot*'} -SearchBase "OU=GOT,OU=Computers,OU=LYNKCO,DC=auto,DC=geely,DC=com" | select name
$Newname = "LSEGOTL$serial"


foreach ($computer in $computers) {

  Rename-Computer -NewName $Newname -ComputerName $computer -DomainCredential auto\ADMIN -force 
    $computer
    }

