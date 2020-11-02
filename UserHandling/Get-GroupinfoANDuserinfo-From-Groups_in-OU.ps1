 # This script shows all groups in a OU and dumps the Groupname and all users to a CSV-file
 cls

 Remove-Variable mem*,adgrou*
 
 #$adgroups = get-adgroup -Filter * -SearchBase "OU=gd Groups,ou=CEVT,DC=auto,DC=geely,DC=com" -Properties *

 # Get all GD groups
 $adgroups = get-adgroup -filter * | where {$_.name -like "*GD-*"} 

 

$Results = ForEach ($AdGroup in $ADGroups) 
{
        $Members = Get-AdGroupMember -Identity $AdGroup.SamAccountName
         
        $managedBy = get-adgroup $adgroup -Properties * | select @{Name='Manager';Expression={(Get-ADUser $_.Managedby).sAMAccountName}},memberof,description        

        $member2 = get-adgroup $adgroup –Properties MemberOf | 
                    Select-Object -ExpandProperty MemberOf | 
                    Get-ADGroup -Properties name  | 
                    Select-Object name | 
                    where {($_.name -like “*dept*”)}       

                    #where {($_.name -like “*dept*” -or $_.name -like "*unit*")}

      
       
 # Gets permission for the groupmembers       

ForEach ($Member in $Members) 
{
        $mem = get-aduser $member.SamAccountName -Properties * -ErrorAction Continue
        $user = get-aduser $sam -Properties * | select @{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}}, @{n='directReports';e={$_.directreports -join '; '}},@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}}

        # Hides the errors when Computers or servers are a member and Get-aduser don't work

        cls

$Hash = @{
        GroupName =       $AdGroup.SamAccountName
        Accountexpirationdate = $mem.accountexpirationdate
        Description = $Managedby.description
        GroupManagedBy = $managedBy.Manager
        UserOU = $User.OU
        MemberOfGroup =    $mem.SamAccountName
        UserDepartment =$mem.Department
        UserManager  =  (Get-ADUser $mem.Manager).sAMAccountName
        UserTitle = $mem.Title
        Company = $mem.Company
        GroupMemberOf = $member2.name
    

}
New-Object -TypeName PSObject -Property $Hash
}
}
        $Date = get-date -Format d
        $Results | select Description,groupName,MemberOfGroup,UserTitle,groupmanagedby,UserManager,UserDepartment,UserOu,GroupMemberOf| 
        Export-Csv -Path c:\temp\GD-Groups_$date.csv -NoTypeInformation -Delimiter ";" -Encoding Unicode


        ii c:\temp\GD-Groups_$date.csv