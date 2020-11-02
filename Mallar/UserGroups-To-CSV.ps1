$groups = ForEach ($group in $user.memberof) {
    (Get-ADGroup $group).Name
}

$groupStr = $groups -join "; "
$memberOFGroups = $user | Select-Object Name,SamAccountName,@{
    n='Groups';
    e={$groupStr}
    }
