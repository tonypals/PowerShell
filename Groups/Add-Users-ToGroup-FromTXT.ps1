# Clear the Variables
    $sam,$users,$GroupName = $null

# Set the Variables

    $users = get-content C:\temp\Mattias.txt
    $GroupName = "CEVT-VDI-Longrun"

foreach ($user in $users)
{
# Select the users with the displayname as in the TXT-file
    $users = Get-ADUser -ldapfilter "(displayname=$user)" -Property samaccountname | Select-Object -Property samaccountname 

foreach ($user in $users) {
        $sam = $users.samaccountname
        Get-aduser $sam | select sam*
        Add-ADGroupMember -Identity $GroupName -Members $Sam 

}
}

# Show how many there are in the group after the script has ran
(Get-ADGroupMember CEVT-VDI-Longrun | select sam*).count