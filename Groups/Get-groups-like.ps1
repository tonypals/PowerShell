# Get Groups with name like ** 

$FileName = "c:\temp\exports\grouplist.csv"
if (Test-Path $FileName) {
  Remove-Item $FileName
}
$Import = "c:\temp\exports\import.txt"
if (Test-Path $Import) {
  Remove-Item $Import}




Get-ADGroup -filter {Name -like '*admin*'} -Properties name | select name | sort name |out-file $Import 
get-adgroup  -Filter * -SearchBase  "OU=Admin-Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Properties name | select name | sort name | out-file $Import -Append

(get-content 'C:\temp\exports\import.txt') -replace 'name','' -replace '----', '' -notmatch '^\s*$'  > C:\temp\Exports\CleanImport.txt




$groups = Get-Content C:\temp\exports\cleanImport.txt
$resultsarray =@()
    foreach ($group in $groups) {
        $GroupInfo = Get-adgroup $group.TrimEnd() -Properties * 
        $resultsarray += Get-ADGroupMember $group.TrimEnd()| 
        select name,
        @{Expression={$group};Label="Group Name"},
        @{Expression={$Groupinfo.description};Label="Group Description"},
        @{Expression={$Groupinfo.ManagedBy};Label="ManagedBy"},
        @{Expression={$Groupinfo.WhenCreated};Label="WhenCreated"}      
        
       
                                }

$resultsarray| Export-csv -path $FileName -notypeinformation

invoke-item $FileName