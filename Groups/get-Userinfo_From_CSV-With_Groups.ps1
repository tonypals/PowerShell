Remove-Variable collection*,item*,sam*
#Remove-item c:\temp\X_$date.csv

$Path1 = (get-addomain).distinguishedname
$Date = get-date -format d
#$collection = Get-ADuser -filter * -SearchBase "OU=Supplier;OU=CEVt users,OU=CEVT,$path1" -Properties * 

$collection = Get-ADuser -filter * -SearchBase "OU=Supplier,OU=CEVt users,OU=CEVT,$path1" -Properties * 

$Result = foreach ($item in $collection)
{   
    $sam = $item.samaccountname
    $groups = Get-ADPrincipalGroupMembership -Identity $sam | select samaccountname | 
         where { $_.SAMAccountName -like '*Dept*' -or $_.SAMAccountName -like '*Unit*' }
        #where { $_.SAMAccountName -like '*Dept*'}
    
    
    $manager = get-aduser $sam -Properties * | select @{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}} 

    $Hash = @{ 
                            "Samaccountname" = $sam    
                            "Manager" =  $manager.Manager
                            "Attribut" = $item.extensionattribute1
                            "Company" = $item.company
                            "Department" = $item.department
                            "Displayname" = $item.displayname
                            "Pager" = $item.pager
                            "Groups" = $groups.samaccountname -join ';'
                            "Mail" = $item.mail
                            "Accountexpirationdate" = $item.AccountExpirationDate
                            "Phone" = $item.OfficePhone
                            "Lastlogondate" = $item.LastLogonDate
                            
                            }

                   New-Object -TypeName PSObject -Property $Hash


  }

# Get result. Select chooses what columns should be choosen.   
        $Result | 
        select samaccountname,mail,Company,Department,Accountexpirationdate,Lastlogondate,manager,phone,Attribut,groups | 
        export-csv c:\temp\Suppliers_$date.csv -notypeinformation -Delimiter ";" -append -Encoding ASCII -Force

        ii c:\temp\Suppliers_$date.csv



