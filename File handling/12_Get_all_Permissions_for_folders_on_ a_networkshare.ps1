#New-PSDrive –Name  r –PSProvider FileSystem –Root "\\segot-s040\gd" –Persist


   If (!(Test-Path r:))
    {
    New-PSDrive -Name r -PSProvider FileSystem –Root "\\segot-s040\gd"
    }
    else { cls
     }

$date = get-date -Format d
$path = "H:\Exports\departments"


$AllFolders = Get-ChildItem -Directory -Path 'r:\departments' -Recurse -Force
$Results = @()
Foreach ($Folder in $AllFolders) {
    $Acl = Get-Acl -Path $Folder.FullName
    foreach ($Access in $acl.Access) {
        if ($Access.IdentityReference -notlike "BUILTIN\Administrators"`       -and $Access.IdentityReference -notlike "auto\auto Admins"`       -and $Access.IdentityReference -notlike "auto\GD-FileShare-Admins" `       -and $Access.IdentityReference -notlike "auto\g-cevt-admin" `       -and $Access.IdentityReference -notlike "CREATOR OWNER"`       -and $access.IdentityReference -notlike "NT AUTHORITY\SYSTEM"`) {
            $Properties = [ordered]@{'FolderName'=$Folder.FullName;'AD Group'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
            $Results += New-Object -TypeName PSObject -Property $Properties 
        }
    }
}

$Results | Export-Csv -path "$path - $(Get-Date -format d).csv"

ii $path
cls
write-host "Nu är filen klar!" -ForegroundColor Green