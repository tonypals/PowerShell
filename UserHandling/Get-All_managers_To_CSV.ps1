# This script imports all managers in the OU CEVT and displays all their mail-adresses in a CSV-file
# This CSV should then be used to send a mail to all managers.
cls

remove-item C:\temp\manager.txt
remove-item C:\temp\managers2.txt
cls

$Date = Get-date -Format d
Remove-Variable collection*,item*,sam*
Clear-Variable da*,cev*,des*,da*
$path = (get-addomain).distinguishedname



# Import all users to the CSV-file and choose only the Manager-attribute

       Get-ADUser -filter * -SearchBase "OU=CEVT,$path"  | Where-Object {$_.Enabled -eq $true} |  
        ForEach { get-aduser $_.samaccountname -Properties *}  | 
            select @{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}} |
                export-csv -Delimiter ";" -Path c:\temp\1.csv -NoTypeInformation
       

# Sorts out so only unique values are displayed. Sent to txt-file.

    $Coll = $(foreach ($line in get-content C:\temp\1.csv) {$line}) | sort | get-unique | Out-File c:\temp\managers2.txt

# Removes all " " and some names in the Text-file.

       (Get-Content C:\temp\managers2.txt) | 
        Foreach-Object {$_ -replace '"','' -replace 'manager','' -replace 'vpntest1','' -replace 'vpntest2','' -replace 'vpntest3','' -replace 'vcctest',''} | Set-Content C:\temp\manager.txt

# Remove empty lines from the Text-file

    (gc C:\temp\manager.txt) | ? {$_.trim() -ne "" } | set-content C:\temp\manager.txt
    
# Exports the data to a CSV-file

    $collection = get-content -path C:\temp\manager.txt
        foreach ($item in $collection)
        {get-aduser $item -Properties * | select Displayname,samaccountname,mail,officephone,Description,Department | export-csv -path C:\temp\Y.csv -Delimiter ";" -NoTypeInformation -Append -Encoding Unicode
    
}

                             
# Imports the users and just chooses the Dept and Unit-groups


    $collection = import-csv C:\temp\y.csv -Delimiter ";"

    $Result = foreach ($item in $collection)
    {   
            $sam = $item.samaccountname
            $groups = Get-ADPrincipalGroupMembership -Identity $sam | select samaccountname | 

             where { $_.SAMAccountName -like '*Dept*' -or $_.SAMAccountName -like '*Unit*' }

                #where { $_.SAMAccountName -like '*Dept*'}

 
# Set variables that needs expressions:
   
    $manager = get-aduser $sam -Properties * | select @{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}} 
    $directReport = (@((get-aduser $sam -Properties directreports).directreports -replace '^CN=(.+?),(?:OU|CN)=.+','$1' -join ';'))

    #               (@((get-aduser $dr  -Properties memberof).memberof           -replace '^CN=(.+?),(?:OU|CN)=.+','$1') -join ',')

# Create the table

    $Hash = @{ 
                            "Samaccountname" = $sam    
                            "Manager" =  $manager.Manager
                            "Attribut" = $item.extensionattribute1
                            "Company" = $item.company
                            "Department" = $item.department
                            "Displayname" = $item.displayname
                            "Pager" = $item.pager
                            "Groups" = $groups.samaccountname -join ';'
                            "Directreport" = $directreport.directReports
                            "Mail" = $item.mail
                            "Accountexpirationdate" = $item.AccountExpirationDate
                            "Phone" = $item.OfficePhone
                            "Lastlogondate" = $item.LastLogonDate
                            
                            
                            }

                   New-Object -TypeName PSObject -Property $Hash


  }

# Get result. Select chooses what columns should be choosen.   
$Date = Get-date -Format d

        $Result | 
        select Displayname,samaccountname,mail,Department,manager,Directreport,groups  |
        export-csv c:\temp\x.csv -notypeinformation -Delimiter ";" -append -Encoding Unicode -Force    


# Replace all Distinguished names in the Directreport-column

            (Get-Content C:\temp\x.csv) | 
            % {$_ -replace ‘domain users;‘, “”} | 
            % {$_ -replace ‘CEVT-FineGrain‘, “”} | 
            % {$_ -replace ‘G-cevt-users;‘, “”} | 
            % {$_ -replace ‘G-CEVT-VPN-CERT;‘, “”} | 
            % {$_ -replace ‘CEVT-Office365-EMS-License;‘, “”} | 
            % {$_ -replace ‘CEVT-Office365-E3-SE-License;‘, “”} | 
            % {$_ -replace ‘G-CEVT-SharePoint-Users;‘, “”} | 
            % {$_ -replace ‘GD-GOT-Users;‘, “”} | 
            % {$_ -replace ‘CEVT_GVG10;‘, “”} | 
            % {$_ -replace ‘OU=CEVT,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com‘, “”} | 
            % {$_ -replace ‘OU=Consultants,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com‘, “”} | 
            % {$_ -replace ‘OU=Employees,OU=Admin-Accounts,OU=CEVT,DC=auto,DC=geely,DC=com; ‘, “”} | 
            % {$_ -replace ‘OU=CEVT,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com‘, “”} | 
            % {$_ -replace ‘OU=VCC Employee,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com;‘, “”} | 
            % {$_ -replace ‘OU=Consultants,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com‘, “”} | 
            % {$_ -replace ‘OU=IT,OU=Admin-Accounts,OU=CEVT,DC=auto,DC=geely,DC=com; ‘, “”} | 
            % {$_ -replace ‘OU=Temp,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com‘, “”} | 
            % {$_ -replace ‘OU=Consultants,OU=GOT,OU=Geely Sales Users,OU=CEVT,DC=auto,DC=geely,DC=com; ‘, “”} | 
            % {$_ -replace ‘OU=Consultants,OU=GOT,OU=Geely Design Users,OU=CEVT,DC=auto,DC=geely,DC=com; ‘, “”} | 
            % {$_ -replace ‘OU=Supplier,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com; CN=‘, “”} | 
            % {$_ -replace ‘OU=CEVT,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com; CN=‘, “”} | 
            % {$_ -replace ‘OU=Employees,OU=GOT,OU=Geely Sales Users,OU=CEVT,DC=auto,DC=geely,DC=com; CN=‘, “”} | 
            % {$_ -replace ‘OU=VCC Employee,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com; CN=‘, “”} | 
            % {$_ -replace ‘OU=VCC Employee,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com‘, “”} |
            % {$_ -replace ‘OU=Training,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com;‘, “”} |
            % {$_ -replace ‘OU=Consultants,OU=GOT,OU=Geely Design Users,OU=CEVT,DC=auto,DC=geely,DC=com; ‘, “”} |
            % {$_ -replace ‘OU=Supplier,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com‘, “”} |
            % {$_ -replace ‘OU=Employees,OU=GOT,OU=Geely Design Users,OU=CEVT,DC=auto,DC=geely,DC=com; ‘, “”} |
            % {$_ -replace ‘OU=Consultants,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com; CN=‘, “”} | 
             % {$_ -replace ‘OU=Exchange Resources,OU=CEVT,DC=auto,DC=geely,DC=com‘, “”} | 

             
             #% {$_ -replace ‘,; ‘, “,”} | 
              
           
            % {$_ -replace ‘CN=‘, “”} | 

            

out-file -FilePath C:\temp\Allmanagers_$date.csv -Force -Encoding unicode

# Open the file

ii C:\temp\Allmanagers_$date.csv

 
  # Cleanup Temp-files

remove-item C:\temp\manager.txt
remove-item C:\temp\managers2.txt
remove-item c:\temp\y.csv
remove-item c:\temp\x.csv
remove-item c:\temp\1.csv






<#   This script below could be used to send out a mail automatically to all Managers


$emailstring = import-csv -Path c:\temp\managermails.csv -Delimiter ";"

$emailarray  = $emailstring -replace '@{Mail=','' -replace '}','' -split ';'; 

Send-mailmessage -from "Tony Pålsson <tony.palsson@cevt.se>" -to $emailarray -subject "Update the list of users, please" -body "Here is the list of your group, Please update so all fields are correct. Return the attachment." -Attachments "C:\temp\ManagersCostcenters.csv" -smtpServer segot-s108.auto.geely.com

 #>