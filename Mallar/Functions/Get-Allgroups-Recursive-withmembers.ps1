﻿function Get-ADGroupMembers {

	param(
		[string]$GroupName
	)
	
	$objects = @()

	$members = Get-ADGroupMember -Identity $GroupName

	foreach ($member in $members) {

		if ($member.objectClass -eq "group") {
			$objects += Get-AdGroupMembers -GroupName $member.Name
		}
			
		$objects += @{
			"objectclass" = $member.objectClass;
			"name" = $member.Name;
			"group" = $GroupName
		}
		
	} # foreach
	
	return $objects
	
} # Get-AdGroupMembers



$GRP = "Groupname"
$AllMembers = Get-ADGroupMembers -GroupName $GRP
$AllMembers | Foreach-Object {New-Object psobject -Property $_ } | Export-Csv C:\temp\$(get-date -f yyyy-MM-dd-hh-mm-ss)-$GRP.txt –NoTypeInformation -Encoding Unicode -Append