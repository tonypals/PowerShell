#$users = Get-ADGroupMember "CEVT-CC-Account not handeld by MIM or CPU (Orphan)" | select samaccountname

$Date = Get-date -Format "yy-MM-dd-ss"
$OutFile = "C:\temp\Exports\OrphansFromGroups_$date.csv"

$Groups = Get-ADGroup -Filter {Name -like "*orph*"}

$Users = @(); ForEach ($Group in $Groups) {
    $Users += (Get-ADGroupMember -Identity "$($Group.Name)" -Recursive)
}

$users.count


$props=@(
  
           'SAMAccountName',
            @{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}}  
           'Description',
           'Enabled',
           'created',
           'mail'
           'Company',
           'ExtensionAttribute3'
           'ExtensionAttribute13'
            @{Name="MemberOf";expression={($_.memberof | %{(Get-ADGroup $_).sAMAccountName}) -join ";"}},   # Shows groups the User is member of
           'LastLogonDate'
           @{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}} 

   )

foreach ($user in $users){

Get-ADUser $user.samaccountname -Properties * | 
select $props |
Export-Csv -Path $OutFile -Delimiter ";" -Encoding Unicode -NoTypeInformation -Append

}

Invoke-Item $OutFile

