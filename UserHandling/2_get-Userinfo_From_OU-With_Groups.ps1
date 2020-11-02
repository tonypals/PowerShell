# This script puts all users from a specific OU to a file.
# The columns are choosen after "Select" in the bottom.
cls

Remove-Variable collection*,item*,sam*
Clear-Variable da*,cev*,des*,da*
$path = (get-addomain).distinguishedname
$date = get-date -format d
$CEVT = "OU=CEVT,OU=Cevt users,OU=CEVT,$path"
$Consultants = "OU=Consultants,OU=Cevt users,OU=CEVT,$path"
$consultantsIT = "OU=consultants-it,OU=Cevt users,OU=CEVT,$path"
$suppliers = "OU=Supplier,OU=Cevt users,OU=CEVT,$path"
$VCC= "OU=VCC Employee,OU=Cevt users,OU=CEVT,$path"
$GeelyDesign = "OU=Geely Design Users,OU=CEVT,$path"
$Lax = "OU=Lax,OU=Geely Design Users,OU=CEVT,$path"
$BCN = "OU=BCN,OU=Geely Design Users,OU=CEVT,$path"
$Admin= "OU=Admin-Accounts,OU=CEVT,$path"
$AllCEVT = "OU=CEVT,$path"
$GeelyStaff ="OU=GeelyStaff,$path"
$GeelySales = "OU=Geely Sales Users,OU=CEVT,$path"

# Change the Path to choose from where the users should be exported

        $collection = Get-ADuser -filter {enabled -ne $false} -SearchBase "OU=Cevt users,OU=CEVT,$path" -Properties samaccountname,mail,Description,company,department,mail,accountexpirationdate,lastlogondate,manager
        #Where-Object {$_.extensionattribute1 -ne $null}
        
        #$collection = import-csv c:\temp\AllManagers-export_$date.csv -Delimiter ";"
#$collection.count

$Result = foreach ($item in $collection)
{   
    $sam = $item.samaccountname
 
    $Unitdeptgroups = Get-ADPrincipalGroupMembership -Identity $sam | select samaccountname | 
              where { $_.SAMAccountName -like '*Dept*' -or $_.SAMAccountName -like '*Unit*'}
              #where { $_.samaccountname -like '*lynkco*' }
              

    <#          
    $VPNgroups = Get-ADPrincipalGroupMembership -Identity $sam | select samaccountname | 
              where { $_.SAMAccountName -like '*vpn*' }

              #>
              

#write-host "$sam"

    $user = get-aduser $sam -Properties * | 
            select @{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}},@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}}

    
    
    # Use this after Select if the Hash don't work
    #@{n='directReports';e={$_.directreports -join '; '}}

    $Hash = @{ 
                            "Samaccountname" = $sam    
                            "Manager" =  $user.Manager
                            "Attribut" = $item.extensionattribute1
                            "Company" = $item.company
                            "Department" = $item.department
                            "Descriptions" = $item.description
                            "Displayname" = $item.displayname
                            "Pager" = $item.pager
                            "UnitDeptGroups" = $unitdeptgroups.samaccountname -join ';'                       
                            "DirectReport" = ($_.directreports | Where-Object{$_} | ForEach-Object{Get-Aduser $_ | Select-object -ExpandProperty Name}) -join ","
                            "Mail" = $item.mail
                            "Accountexpirationdate" = $item.AccountExpirationDate
                            "Phone" = $item.OfficePhone
                            "Lastlogondate" = $item.LastLogonDate
                            "OU" = $user.ou 
                                                   
                            
                            }

                             New-Object -TypeName PSObject -Property $Hash

$Result

  }

# Get result. Select chooses what columns should be choosen.  


        $Result | 
        select samaccountname,Company,Description,Department,manager,OU,unitdeptgroups |
        export-csv c:\temp\AllUsersWithGroups_$date.csv -notypeinformation -Delimiter ";" -append -Encoding unicode -Force

        ii c:\temp\AllUsersWithGroups_$date.csv


