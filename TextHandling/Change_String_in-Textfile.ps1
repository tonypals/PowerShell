$original_file = 'C:\temp\svensson\errors3.csv'
$destination_file =  'c:\temp\svensson\errorscleanup.csv'
(Get-Content $original_file) | Foreach-Object {
    $_ #replace 'get-aduser : Cannot find an object with identity' ,''
       -replace '' under: '' under: 'DC=auto,DC=geely,DC=com'.', ''' `
       -replace '+ get-aduser $item.samaccountname -Properties * | select |', '' `
       -replace 'At line:7 char:1', '' `
       -replace '+ FullyQualifiedErrorId : ActiveDirectoryCmdlet:Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException,Microsoft.ActiveDirectory.Management.Commands.GetADUser', '' `
       -replace 'At C:\temp\scripts\error-handling_to_file.ps1:8 char:1', ''
    } | Set-Content $destination_file

