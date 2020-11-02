

$FileName=$Null
$Props=$null
$Ou=$Null



cls
$path = (get-addomain).distinguishedname
$date = get-date -format d

$props=@(
   'Name',
   'Description',  
   'DistinguishedName'  
   'ObjectClass'
   'lastlogondate'
   'operatingsystem'
   'Enabled' 
)

# Checks if file exists, Deletes if exists

$FileName = "C:\Temp\Exports\$date-AllCEVTComputers.csv"
    if (Test-Path $FileName) {
      Remove-Item $FileName
    }

# CEVT Computers
    $CEVT = "OU=CEVT,$path"
# LynkCo Computers: 
    $LynkCo = "OU=LYNKCO,$path"

# Change here which OU's to search in:


$OU= @($CEVT)

$ou |  

    #ForEach {Get-ADComputer -SearchBase $_ -Filter { ObjectClass -eq 'Computer' -and enabled -ne $false}   -Properties * | 
    ForEach {Get-ADComputer -SearchBase $_ -filter {objectclass -eq 'computer' } -Properties * | 
    select $props } |
    export-csv -Delimiter ";" -Path $FileName -NoTypeInformation -Encoding Unicode -Append -Force


Invoke-Item $FileName


