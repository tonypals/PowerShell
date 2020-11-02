<#
.Synopsis
   Enabled AD-accounts for Training purposes
.DESCRIPTION
   The accounts "CEVT-Education 1-22" are used for educations for TC and Catia.
   This script enables all or some of the accounts, adds an AccountExpirationdate 5 days ahead and sets a new random password
   for the accounts choosen.
   The Password is added to the clipboard for easier access when mailing to the teacher
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
cls
$x = get-aduser -filter {name -like 'cevt-education*'} -Properties * | 
     select samaccountname | 
     sort -Descending -Property {[int]"0"*5+($_.samaccountname -replace "[a-zA-Z]","")}

$Number = Read-host "Type number of how many accounts that should be enabled, Ex 3"
$users = $x | select -First $Number

# Function to create a new Password
        function Get-RandomCharacters($length, $characters) { 
            $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length } 
            $private:ofs="" 
            return [String]$characters[$random]
        }

        $password = Get-RandomCharacters  -length 8 -characters 'abcdefghiklmnoprstuvwxyz'
        $password += Get-RandomCharacters -length 1 -characters 'ABCDEFGHKLMNOPRSTUVWXYZ'
        $password += Get-RandomCharacters -length 2 -characters '1234567890'
        $password += Get-RandomCharacters -length 1 -characters '!"+?'



# Days when to expire
    $Days = 5

# expiration date is today plus the number of days
    $expirationDate = (Get-Date).AddDays($Days)


foreach ($user in $users) {

# Sets Accountexpirationdate and Enables the accounts

    #Set-ADUser -Identity $user.samaccountname -AccountExpirationDate $expirationDate -Enabled $true

    #Set-ADAccountPassword -Identity $user.samaccountname -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$newPass" -Force)

# Reset the Accounts

    #Clear-ADAccountExpiration -Identity $user.samaccountname 
    #Set-Aduser $user.samaccountname -Enabled $false


#Show Result
    Get-aduser $user.samaccountname -Properties * | select samaccountname,enabled,AccountExpirationDate
       # Add the Password to the clipboard
    $Password | Set-Clipboard
    Write-host "The new password is "$Password" and is in the Clipboard"

 
}



