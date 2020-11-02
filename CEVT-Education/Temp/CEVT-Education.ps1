
<#
.Synopsis
   Enabled AD-accounts for Training purposes
.DESCRIPTION
   The accounts "CEVT-Education 1-22" are used for educations for TC and Catia.
   This script enables all or some of the accounts, adds an AccountExpirationdate 5 days ahead and sets a new random password
   for the accounts choosen.
   The Password is added to the clipboard for easier access when mailing to the teacher
.EXAMPLE
   

#>
cls




$WorkSheet = import-csv C:\Scripts\CEVT-Education\FormToFill.csv -Delimiter ","


    $EducationResponsible = $WorkSheet.Teacher
    $StartDate            = $WorkSheet.EducationStartDate
    $NumberOfUsers        = $WorkSheet.Participants
    


###################   Adds the parameters from the Excel  #############################


$x = get-aduser -filter {name -like 'cevt-education*'} -Properties * | 
     select samaccountname | 
     sort -Descending -Property {[int]"0"*5+($_.samaccountname -replace "[a-zA-Z]","")}


$users = $x | select -First $NumberOfUsers

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
    $Days = 6

  $expirationDate = ([datetime]$startdate).AddDays($Days)

#$mydate

# expiration date is today plus the number of days
   # $expirationDate = (Get-Date).AddDays($Days)


foreach ($user in $users) {

Write-host "Username is: "$user.samaccountname

#### Sets Accountexpirationdate and Enables the accounts

    Set-ADUser -Identity $user.samaccountname -AccountExpirationDate $expirationDate -Enabled $true

    Set-ADAccountPassword -Identity $user.samaccountname -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$password" -Force)

# Reset the Accounts

    #Clear-ADAccountExpiration -Identity $user.samaccountname 
    #Set-Aduser $user.samaccountname -Enabled $false


#Show Result
    Get-aduser $user.samaccountname -Properties * | select samaccountname,enabled,AccountExpirationDate
       # Add the Password to the clipboard
    $Password | Set-Clipboard
  

 
}
$sam = $user.samaccountname

  Write-host "The new password is "$Password" and is in the Clipboard"
  Write-host "   "
  Write-host "Number of users is:" $users.Count


$MailTo = @("tony.palsson@cevt.se");
$MailFrom = "OrderEducation@cevt.se";
$domains = @("auto.geely.com");

$InfoDateStart = get-date $StartDate -Format d
$InfoDateEnd = get-date $expirationDate -Format d




 # Write stuff to Mail
 # ---------------------------------
 $MailSubject = "The Course is now booked" 
 $MailBody = " We have know enabled accounts for you as requested.
 The accounts will be enabled from $InfoDateStart until $InfoDateEnd and then you will have to do a new request.
 The $NumberOfUsers Accounts enabled are:  CEVT-Education1 - CEVT-Education$NumberOfUsers
 
 The password for all accounts are:

 $Password
 
 Best Regards
 IT Department" 

 # Send the report
  Send-MailMessage -To $MailTo  -From $MailFrom -SMTPServer smtpext01.cevt.se -Subject $MailSubject -Body $MailBody
