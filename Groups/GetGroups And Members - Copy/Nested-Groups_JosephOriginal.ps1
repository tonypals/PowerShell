$Groups = Get-ADGroup -filter {Name -like '*citrix*' -and name -notlike 'LYNKCO-Users-Outlook-Settings' -and name -notlike 'G-CEVT-Exchange-OP' -and name -notlike '*Apps*'} -SearchBase  "OU=CEVT,DC=auto,DC=geely,DC=com"  -Properties *
$AllInfo = @()
foreach($group in $groups) {
    $GroupMembers = Get-ADGroupMember $group -Recursive #| select -ExpandProperty members
    foreach($user in $GroupMembers)
    {
        $UserInfo = get-Aduser $user -Properties * 
        $GroupOU = $Group.DistinguishedName -split ","
        $Info = New-Object pscustomObject
        $info | Add-Member NoteProperty -name "User" $user.SamAccountName         
        $info | Add-Member NoteProperty -name "GroupName" $Group.SamAccountName
        $info | Add-Member NoteProperty -Name "Group Description" $group.Description
        $info | Add-Member NoteProperty -Name "Create Date" $Group.whenCreated
        $Info | Add-Member NoteProperty -name "OU" $GroupOU[1]
        $Info | Add-Member NoteProperty -name "User Enabled" $userinfo.Enabled
        $allInfo += $Info
    }
}

$allinfo | export-csv $env:USERPROFILE\Desktop\AllInfo.csv -NoTypeInformation
ii $env:USERPROFILE\Desktop\AllInfo.csv  
