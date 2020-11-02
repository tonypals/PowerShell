function Get-ADNestedGroupMembers { 
<#  f
.SYNOPSIS
Author: Piotr Lewandowski
Version: 1.01 (04.08.2015) - added displayname to the output, changed name to samaccountname in case of user objects.

.DESCRIPTION
Get nested group membership from a given group or a number of groups.

Function enumerates members of a given AD group recursively along with nesting level and parent group information. 
It also displays if each user account is enabled. 
When used with an -indent switch, it will display only names, but in a more user-friendly way (sort of a tree view) 
   
.EXAMPLE   
Get-ADNestedGroupMembers "MyGroup" | Export-CSV .\NedstedMembers.csv -NoTypeInformation

.EXAMPLE  
Get-ADGroup "MyGroup" | Get-ADNestedGroupMembers | ft -autosize
            
.EXAMPLE             
Get-ADNestedGroupMembers "MyGroup" -indent
 
#>

param ( 
[Parameter(ValuefromPipeline=$true,mandatory=$true)][String] $GroupName, 
[int] $nesting = -1, 
[int]$circular = $null, 
[switch]$indent 
) 
                    <#
                        function indent                                                                # Vad gör den här funktionen egentligen?
                        { 
                        Param($list) 
                            foreach($line in $list) 
                            { 
                            $space = $null 
         
                                for ($i=0;$i -lt $line.nesting;$i++) 
                                { 
                                $space += "-" 
                                } 
                                $line.name = "$space" + "$($line.name)"
                            } 
                          return $List 
                        } 

                        #>
     
$modules = get-module | select -expand name
    if ($modules -contains "ActiveDirectory") 
    { 
        $table = $null 
        $nestedmembers = $null 
        $adgroupname = $null     
        $nesting++   
        $ADGroupname = get-adgroup $groupname -properties  memberof,members,Description 

        $memberof = $adgroupname | select -expand memberof                                  # Här får man ut Memberof
        Write-Verbose "Rad 57 Checking group: $($adgroupname.name)"

        if ($adgroupname) 
        {  
            if ($circular) 
            { 
                $nestedMembers = Get-ADGroupMember -Identity $GroupName -recursive          # Alla undergrupper
                $circular = $null 
            } 
            else 
            { 
                $nestedMembers = Get-ADGroupMember -Identity $GroupName  | sort objectclass -Descending 
                if (!($nestedmembers))
                {
                    $unknown = $ADGroupname | select -expand members
                    if ($unknown)
                    {
                        $nestedmembers=@()
                        foreach ($member in $unknown)
                        {
                        $nestedmembers += get-adobject $member
                        }
                    }

                }
            } 
 
            foreach ($nestedmember in $nestedmembers) 
            { 
                $Props = @{ Type=$nestedmember.objectclass;
                            Name=$nestedmember.name;
                            DisplayName="";            
                            ParentGroup=$ADgroupname.name;
                            Enabled="";
                            Nesting=$nesting;
                            DN=$nestedmember.distinguishedname;
                            GroupDescription=$ADGroupName.Description
                           
                  }

                    
                 
                if ($nestedmember.objectclass -eq "user") 
                { 
                    $nestedADMember = get-aduser $nestedmember -properties enabled,displayname 
                    $table = new-object psobject -property $props 
                    $table.enabled = $nestedadmember.enabled
                    $table.name = $nestedadmember.samaccountname
                    $table.displayname = $nestedadmember.displayname             
                  
                              <#
                                if ($indent)                                                                # Vadå $indent? Indent heter väl funktionen?
                                { 
                                indent $table | select @{N="Name";E={"$($_.name)  ($($_.displayname))"}}    # Här vet jag inte vad som görs
                                } 
                                #>


                    #else 
                    { 
                    $table | select type,name,displayname,parentgroup,nesting,enabled,GroupDescription,dn,ou
                    } 
                }  
                elseif ($nestedmember.objectclass -eq "group") 
                {  
                    $table = new-object psobject -Property $props 
                     
                    if ($memberof -contains $nestedmember.distinguishedname) 
                    { 
                        $table.comment ="Circular membership" 
                        $circular = 1 
                    } 

                    <#
                    if ($indent) 
                    { 
                    indent $table | select name,comment | %{
						
						if ($_.comment -ne "")
						{
						[console]::foregroundcolor = "red"
						write-output "$($_.name) (Circular Membership)"
						[console]::ResetColor()
						}
						else
						{
						[console]::foregroundcolor = "yellow"
						write-output "$($_.name)"
						[console]::ResetColor()
						}
                    } #>
					}
                    else 
                    { 
                    $table | select type,name,displayname,parentgroup,nesting,enabled,GroupDescription,dn,ou         # Här läggs info om Gruppen i $Table                
                                                   
                    } 

                    <#
                    if ($indent) 
                    { 
                       Get-ADNestedGroupMembers -GroupName $nestedmember.distinguishedName -nesting $nesting -circular $circular -indent 
                    } 
                   
                    else  
                    { 
                       Get-ADNestedGroupMembers -GroupName $nestedmember.distinguishedName -nesting $nesting -circular $circular 
                    } 
                     #>
              	                  
               } 
                else 
                { 
                    
                    if ($nestedmember)
                    {
                        $table = new-object psobject -property $props
                        if ($indent) 
                        { 
    	                    indent $table | select name 
                            Write-host "indent $table | select name "    # Här händer inget
                        } 
                        else 
                        { 
                        $table | select type,name,displayname,parentgroup,nesting,enabled,GroupDescription,dn,ou  
                        Write-host "Rad 172 select type,name,displayname,parentgroup,nesting,enabled,GroupDescription,dn,ou"   # Här händer inget
                        } 
                     }
                } 
              
            } 
         } 
    } 
    else {Write-Warning "Active Directory module is not loaded"}        



<#########################################################################################################################





#>
$OUGroup = $null
$LikeAdminGroups = $null

<#
$OUGroup = Get-ADGroup -Properties * -Filter * -SearchBase "OU=Admin-Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -ResultPageSize 2147483647
Write-host "Rad 196  There are" $OUGroup.count  "in OU-group" -ForegroundColor Green
$LikeAdminGroups = Get-ADGroup -Filter {name -like "*Admin*"} -Properties * -ResultPageSize 2147483647
Write-host "Users in LikeAdminGroups is:" $LikeAdminGroups.count -ForegroundColor Green
$groups = $OUGroup+$LikeAdminGroups

#>

                $OUGroup = Get-ADGroup -Properties * -Filter * -SearchBase "OU=LYNKCO Computers,OU=CEVT,DC=auto,DC=geely,DC=com " -ResultPageSize 2147483647
               $ADGroupname = get-adgroup $groupname -properties  memberof,members,Description 
               $groups = $OUGroup



Write-host "Rad 205 There are" $Groups.count"Groups in the Filter" -ForegroundColor Green   
Write-host ""                                                                            # OU får fyllas på med Excel sen

$Date = Get-date -Format "yyMMdd-(HH.mm)"
 

foreach ($Group in $Groups){

$GroupName = $Group.Name

$members= Get-ADGroupMember $GroupName 
Write-host "Rad 209  There are" $members.count "members in" $GroupName -ForegroundColor Green
Write-host ""


$path = "C:\temp\Exports\TonyAdminGrupper_$Date.csv"

Get-ADNestedGroupMembers $GroupName | export-csv $path -delimiter ";" -NoTypeInformation -append -Encoding Unicode -Force


}

 ii $path
