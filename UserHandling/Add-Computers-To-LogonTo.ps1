# This script adds Computers to AD-accounts so they only can logon to those

$comparray=$()
# Import the CSV with the Computernames
 $comparray = (Import-Csv "C:\temp\TCtrainingcomputers.csv"  | Select -ExpandProperty NetBIOSName) -join ','

# Select the users that should have the Computers in the "Logon To" Property
    $Users = get-aduser -filter {name -like 'cevt-education*'} -Properties * | 
         select samaccountname

     foreach ($user in $users) {

# Add the users
    #Set-ADUser -Identity $user.samaccountname -LogonWorkstations $comparray

# Show result
    Get-ADUser $User.samaccountname -Properties LogonWorkstations | `
    Format-List Name, LogonWorkstations
}

