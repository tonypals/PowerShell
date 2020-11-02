$server = (get-addomaincontroller -Discover | select-object -ExpandProperty hostname)
$hour = 24
$path = (get-addomain).distinguishedname

$protectedgroups = Get-ADGroup -Filter 'admincount -eq 1' -server $server
$members = @()

ForEach ($group in $protectedgroups) {
    $members += Get-ADReplicationAttributeMetadata -server $server -Object $group.distinguishedname -ShowAllLinkedValues |
    Where-Object {$_.islinkvalue} 
    Select-Object @{name='GroupDN';expression={$group.distinguishedname}}, @{name='Groupname';expression={$group.name}}
    }

    $members | Where-Object {$_.lastoriginatingchangetime -gt (get-date).addhours(-500 * $hour)} | 
    select attributevalue,lastoriginatingchangetime,lastoriginatingdeletetime | sort lastoriginatingchangetime








$hour = 24 *  7

$protectedgroups | ogv

Get-ADReplicationAttributeMetadata -server $server -Object "CN=CEVT-Dept-Finance-Consultants,OU=Consultants,OU=Unit-Dept Groups,OU=CEVT Groups,OU=CEVT,$path" -ShowAllLinkedValues -Properties * | 
select attributevalue,lastoriginatingchangetime,lastoriginatingdeletetime,version | sort lastoriginatingchangetime

