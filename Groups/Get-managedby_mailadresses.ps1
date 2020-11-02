
$groups = Get-content C:\temp\persgrupper.txt

$FileNameTXT = "c:\temp\GrupperFinnsInte.txt"
    if (Test-Path $FileNameTXT) {
        Remove-Item $FileNameTXT
    }

$FileName = "c:\temp\grupper.csv"
    if (Test-Path $FileName) {
        Remove-Item $FileName
    }


foreach ($Group in $Groups)
{

Try {
    Get-ADGroup $Group | select samaccountname
    }

Catch {
    $group | Out-File $FileNameTXT -Append
      }


Finally{

Get-ADGroup $group -Properties managedBy |
ForEach-Object { 

$managedBy = $_.managedBy;

if ($managedBy -ne $null)
{
 $manager = (get-aduser -Identity $managedBy -Properties emailAddress);
 $managerName = $manager.Name;
 $managerEmail = $manager.emailAddress;
}
else
{
 $managerName = 'N/A';
 $managerEmail = 'N/A';
}
}


$props=@(
            @{n='Group Name';e={$_.Name}},
            @{n='Managed By Name';e={$managerName}},
            @{n='Managed By Email';e={$managerEmail}}         
        )

get-adgroup $group | 
select $props |
export-csv -Path $FileName -Delimiter ";" -NoTypeInformation -append -Encoding Unicode

} # End foreach
} # End Finally


ii $FileNameTXT
ii $FileName
