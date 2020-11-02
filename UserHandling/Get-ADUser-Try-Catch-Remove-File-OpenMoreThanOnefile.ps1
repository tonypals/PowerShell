<#
This script takes user info and add to a file. If the user don't exist it will be displayed in a TXT-file.
#>

# Set Variables
    $Date = Get-date -Format "yyMMdd"
    $Exists = "c:\temp\Users_Exists_$Date.csv"
    $NOTExist = "c:\temp\Users_Exists_NOT_$Date.txt"
    $existingusers = @()
    $nonexistingusers = @()
    $Users =       $()
    $search = "DC=auto,DC=geely,DC=com"
    $path =        (get-addomain).distinguishedname

# Sets Varibles for OU's

  $CEVT =        "OU=CEVT,OU=Cevt users,OU=CEVT,$path"
  $Consultants = "OU=Consultants,OU=Cevt users,OU=CEVT,$path"
  $Partner =     "OU=Partner,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com"


# Removes Export-Files if existing

    if (Test-Path $Exists) {
      Remove-Item $Exists
    }  
    if (Test-Path $NOTExist) {
      Remove-Item $NOTExist
    }

# Get all Enabled Users from specific OU's

  $Users = Get-ADUser -Filter {Enabled -eq $true} -Properties * | 
                 Where-Object { ($_.DistinguishedName -like "*$Partner") -or ($_.DistinguishedName -like "*$CEVT") -or ($_.DistinguishedName -like "*$Consultants")} 

# Get all Enabled CEVT Users. Change the Searchbase if needed 
    #$Users = Get-ADUser -Filter {enabled -ne $false } -Properties * -SearchBase $search 

# Import users from a CSV with SamAccountName in the Header
   #$users = Import-csv -path C:\temp\wronglynkcousers.csv -Delimiter ";"

# Import Users from a Textfile
   #$users = Get-Content C:\temp\UserTest.txt

# Sets all Properties that should be choosen

$props=@(
   'Name',
   'SAMAccountName',
    @{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}}
   # 'DistinguishedName'
   #'Description',
   #'Enabled',
   #'created',
   #'modified',
   'Company',
   'ExtensionAttribute3'
   'ExtensionAttribute13'
   # @{Name="MemberOf";expression={($_.memberof | %{(Get-ADGroup $_).sAMAccountName}) -join ";"}},   # Shows groups the User is member of
   'LastLogonDate'
   @{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}}                             # Shows the Manager
   # @{name="OU3";expression={($_.DistinguishedName -split ",OU=")[3]}}
   @{ L="MemberOfCCDyn"; E={ ($_.memberof | foreach { ($_ | where { $_ -like "CN=CEVT-CCDyn*" }) }).split(',')[0].TrimStart("CN=CEVT-CCDyn-") }}             # All CCDYN-Groups for CEVT
   @{ L="MemberOfCCDynLynkCo"; E={ ($_.memberof |  foreach { ($_ | where { $_ -like "CN=LynkCo-CCDyn*" }) }).split(',')[0].TrimStart("CN=LynkCo-CCDyn-") }}  # All CCDYN-Groups for LYNKCO
   # @{ L="E3"; E={ "CN=CEVT-Office365-E3-SE-License,OU=Office 365,OU=Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -eq ($_.memberof | 
   # foreach { ($_ | where { $_ -like "CN=CEVT-Office365-E3-SE-License,OU=Office 365,OU=Groups,OU=CEVT,DC=auto,DC=geely,DC=com" }) }) }}                     # Shows if the user has an E3-License
)


foreach ($user in $users){
try{
        $aduser =    get-aduser $user.samaccountname -properties * | 
        select $props
        $existingusers += $aduser      

    } # EndOf Try

    catch {
        write-host "Unable to find $user" -ForegroundColor Yellow
        $nonexistingusers += $user
          } # Endof Catch


                         } # EndOf Foreach


# Export Users found to a CSV-file
    $existingusers | Export-csv -path $Exists -Delimiter ";" -NoTypeInformation -Append

# Export User NOT Found to a Text-file
    $nonexistingusers | out-file $NOTExist -Append



If ((Get-Content $NOTExist) -eq $Null) {
"File is blank"
}
else
{
Get-Childitem 'C:\Temp' -Recurse | Where-Object {$_.Name -like "*Users_Exists_*"} | Invoke-Item
}












