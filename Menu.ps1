cls
Write-host "             **********************************"
Write-host "                               Menu             " -ForegroundColor Green
Write-host ""
Write-Host "             **********************************"
Write-host ""

Write-host    "           Connect to Servers or VDI            " -ForegroundColor Yellow

Write-host    ""
Write-host       " A. Connect to the AD-server with RDP"
Write-host       " B. Connect to one of the VDI's with RDP"
Write-host       " C. Get installed Applications from one Computer"
Write-host       " D. Get Info from ALL VDI's"

Write-host " "
Write-host "      ****************************"
Write-host "             Permissions and Staging           " -ForegroundColor Yellow
Write-host ""
Write-host       "E. Add user Officegroups and Script"
Write-host       "F. Add user to the Local Admin for one VDI"
write-host       "G. Remove all Local Admins on one VDI"
Write-Host       "H. Get all Local Admins on ALL VDI's" 
Write-host       "I. Remove one User from Local admins on One VDI" 
Write-host       "J. Clean up a user after tests. (Removes groups)"
Write-host       "K. Stage a Physical Machine"
Write-host       "L. Get all Groups for one user"
Write-host ""
Write-host "      ****************************"
Write-host "             Documents and Sites            " -ForegroundColor Yellow
Write-host ""

Write-host " 0. Open the ServiceNow site"
Write-host " 1. Get the"SOP document from Sharepoint""
Write-host " 2. Get the"Tests-Document from Sharepoint" "
Write-host " 3. Open the Sharepoint-site"
Write-host " 4. Open Application Manager site"
Write-host " 5. Open the Vsphere site to handle VDI's"
Write-host " 6. Open SCCM client Site"



Write-host " "
Write-host "      ****************************"
Write-host "             Traffic and Buses             " -ForegroundColor Yellow
Write-host ""
Write-host " 7. Get Trafiken.nu to see the traffic"
Write-host " 8. Open the Västtrafik TravelPage"
write-host ""

$choice = Read-host "Enter Selection"

Switch ($choice) {
 "a" {Start-Process "$env:windir\system32\mstsc.exe" -ArgumentList "/v:gotclw1003.got.volvocars.net:9506"  
        }
 "b" {cls
        # Connect to a VDI with RDP
        $name = Read-host "Type the two digits for the Machine-name Ex: 40"
        Start-Process "$env:windir\system32\mstsc.exe" -ArgumentList "/v:GOT500VI790$name"   
        }
 "C" {    cls
            $computer = Read-host "Type in the last two digits of the computer ex 34"
            $computername = "GOT500VI790"+$computer
            cls
            $computername
            Get-WmiObject -Namespace "root\cimv2" -Class Win32_product -ComputerName $computername | 
                select name | 
                sort name # | 
                #Where-Object {$_.name -notlike "*desktop*" -and $_.name -notlike "*policy*" -and $_.name -notlike "*horizon*" -and $_.name -notlike "*configuration*"} 

            $a =Get-WmiObject -Namespace "root\cimv2" -Class Win32_product -ComputerName $computername | 
                select Name 

            $antal = $a.Count
           write-host "Number of applications: $antal" 
            Pause}
 "d" { 

cls

Remove-Variable collection*,item*,sam*
Clear-Variable da*,cev*,des*,da*

# Create Variables
$date = get-date -format d
$ErrorActionPreference = "silentlycontinue"
Remove-item -path C:\temp\AllProgramsFromAllVDI*.* -ErrorAction SilentlyContinue
$output = "c:\temp\AllProgramsFromAllVDI.txt"


$array = (30..39)
$array |
    foreach {
        
        $computername = "GOT500VI790$_"

  foreach ($item in $computername)
    {   

    # Add Computername
    $computername
        Add-Content $output "ComputerStart  $computername"

    # Add IP and Macaddress
        
    $colItems = Get-WmiObject -Class "Win32_NetworkAdapterConfiguration" -ComputerName $computername -Filter "IpEnabled = TRUE"
    ForEach ($objItem in $colItems)
    {
        Add-Content $output $objItem.IpAddress[0]  
        Add-Content $output $objItem.MacAddress
    }


 # Add Applications

        $applications = Get-WmiObject -Namespace "root\cimv2" -Class Win32_product -ComputerName $computername | 
        select name | 
        sort name      
        $applications | out-file $output -Append  

      
  # Count applications and add them to file

        $antal =Get-WmiObject -Namespace "root\cimv2" -Class Win32_product -ComputerName $computername |  select name  
        $antalNR = $antal.count

   # Add info to the file

        Add-Content $output "Number of applications: $antalnr"    
        Add-Content $output  "ComputerEnd $computername"   
        Add-Content $output  "**********************"
   
      }
      }


      # Create an Excel object
$excelApp = New-Object -ComObject Excel.Application
$excelApp.Visible = $True
$excelApp.DisplayAlerts = $True

# Open your tab-delimited text into a new Workbook
$file = (Get-ChildItem "C:\temp\AllProgramsFromAllVDI.txt").FullName
$objWorkbook = $excelApp.Workbooks.Open($file)



# Save yo' file...
$file = $file.Substring(0, $file.Length - 3) + "xls"
$objWorkbook.SaveAs($file, 1)

      }
 "E" {Remove-Variable username,comp*,admingroup*,office*,cdsid*,sam* -ErrorAction SilentlyContinue

#Show Gui to add CDSID

    [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
    $Officegroup = "WS-OFFICE-WORKSTATION-USER"
    $Officegroup2 = "WS-CONFIG-OFFICE-WS-REMOTEDESKTOP-USER"
    $CDSid = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Users CDSID", "Adding user to WS-office-workstation-user")  
    $scriptpath = "login4.vbs"

# Add user to Adgroup
 
    Add-ADGroupMember -Identity $Officegroup -Members $CDSid
    Add-ADGroupMember -Identity $Officegroup2 -Members $CDSid

# Change the Loginscript to login4.vbs

    Set-aduser $CDSid -ScriptPath $scriptpath

# Set variables for the summary

    $sum1 = get-adgroupmember $Officegroup | select samaccountname | where {$_.samaccountname -like $cdsid} | select samaccountname
    $sum2 = get-adgroupmember $Officegroup2 | where {$_.samaccountname -eq "$cdsid"} | select samaccountname
    $sam =  $sum1.samaccountname
    $summary = $Officegroup+": "+$sum1.samaccountname
    $summary2 = $Officegroup2+": "+$sum2.samaccountname
    $Scriptsummary = Get-aduser $CDSid -Properties * | select scriptpath
    $HomeDir = get-aduser $cdsid -Properties * | select homedirectory

# Clear the screen

    cls

# Show summary, If the name is shown it's ok

    
    write-host $summary -ForegroundColor green
    write-host $summary2 -ForegroundColor green
    write-host "The Scriptpath is:"$scriptsummary.scriptpath -ForegroundColor green
    Write-host ""
    Write-host "Homedirectory should be FQDN, If not, Change in AD"
    write-host "The Homedirectory is:"$homedir.homedirectory -ForegroundColor green
    Write-host ""

     pause   }
 "f" {# This Script adds a user to the AD-group that gives local Admin Permissions on a PC with the same name as the group.

Remove-Variable username,comp*,admingroup* -ErrorAction SilentlyContinue

[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')  
  
# Set Variables
    $Comp = [Microsoft.VisualBasic.Interaction]::InputBox("Enter PC-name with 2 Digits: Ex 44", "Add User to Local admin on PC")
    $CDSid = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Users CDSID", "Add User to Local admin on PC") 
    $name = "GOT500VI790$comp"
    $AdminGroup= "DEL-GCL-GOT500VI790$comp-Admin"

# Add the user to the AD-group
 
    Add-ADGroupMember -Identity $admingroup -Members $CDSid

# Clean The screen
    cls

# Show the Group-name

    $AdminGroup

# Show Summary
Write-host "The following User/Users are now a Local Admin on $name"
    get-adgroupmember $admingroup | select samaccountname
 
    

pause

        }
 "g" {[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')  

 
    $Comp = [Microsoft.VisualBasic.Interaction]::InputBox("Enter PC-name with 2 Digits: Ex 44", "Remove all local-admins from PC")



    $AdminGroup= "DEL-GCL-GOT500VI790$comp-Admin"
    $name = "DEL-GCL-GOT500VI790$comp"
    $members = get-adgroupmember $admingroup | select samaccountname
    cls
    $comp
    Get-ADGroupMember $AdminGroup | ForEach-Object {Remove-ADGroupMember "$AdminGroup" $_ -Confirm:$false}
    $AdminGroup
    $members = get-adgroupmember $admingroup | select samaccountname
    Write-host "There are now NO Local Admins on $name" -ForegroundColor red
    $members
    get-adgroupmember $admingroup | select samaccountname
       pause     }
 "H" {$array = (30..60)
   $array |
    foreach {
        $Computername = "DEL-GCL-GOT500VI790$_-Admin"
        $groupmembers = get-adgroupmember $Computername | select samaccountname
        $y = $null
        $name = "GOT500VI790$_"
        
    foreach ($item in $Groupmembers)
            {
               if ($item -lt $y)
                    {
      
                    }
                    else
                    {
                     write-host "*****"
                        $name
                     get-adgroupmember $Computername | select samaccountname


                             # Get the date when the group was updated

                             #Get-ADGroupMemberDate -Group $Computername  -DomainController GOTSVW1043 | select username,lastmodified -ExpandProperty username,lastmodified
                   
                    write-host ""
        
                    }
            }
     }

 pause  }
 "I" { # This script deletes one user from the Local Admin

Remove-Variable username,comp*,admingroup* -ErrorAction SilentlyContinue

[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')  

# Set Variables
    $Comp = [Microsoft.VisualBasic.Interaction]::InputBox("Enter PC-name with 2 Digits: Ex 44", "Remove a User from Local Admins on PC")
    $CDSid = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Users CDSID", "Remove a User from Local Admins on PC") 
    $name = "GOT500VI790$comp"
    $AdminGroup= "DEL-GCL-GOT500VI790$comp-Admin"

# Remove the user from the AD group

    Remove-ADGroupMember -Identity $admingroup -Members $cdsid -Confirm:$false

# Show result

    get-adgroupmember $AdminGroup | select samaccountname 
    pause }
 "J" { # This script shows a gui where a CDSID can be written. The user will be removed from the remote desktop group and from Admingroups on PC

# Removes-variables 

    Remove-Variable username,comp*,admingroup*,office*,cdsid*,sam* -ErrorAction SilentlyContinue

#Show Gui to add CDSID

    [void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
    
    $Officegroup = "WS-CONFIG-OFFICE-WS-REMOTEDESKTOP-USER"
    $CDSid = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Users CDSID", "Remove User from RemoteDesktop and Admin for VDI")     

# Remove user from Adgroup
 
    Remove-ADGroupMember -Identity $Officegroup -Members $CDSid -Confirm:$false

# Set variables for the summary

    get-adgroupmember $Officegroup | select samaccountname | where {$_.samaccountname -like $cdsid} | select samaccountname    
    cls
   
   Write-host "The user $cdsid is now removed from the AD-group $officegroup" -ForegroundColor Green

# Clear the screen

    Write-host "Check if the user $cdsid is not admin on any of the machines"
    Write-host "Remove the user if so."

# Show summary, If the name is shown it's ok
$array = (30..60)
$array |
    foreach {
        $Computername = "DEL-GCL-GOT500VI790$_-Admin"
        $groupmembers = get-adgroupmember $Computername | select samaccountname
        $y = $null
        $name = "GOT500VI790$_"
        
    foreach ($item in $Groupmembers)
            {
               if ($item -lt $y)
                    {
      
                    }
                    else
                    {
                     write-host "*****"
                        $name
                     get-adgroupmember $Computername | select samaccountname


                             # Get the date when the group was updated

                             #Get-ADGroupMemberDate -Group $Computername  -DomainController GOTSVW1043 | select username,lastmodified -ExpandProperty username,lastmodified
                   
                    write-host ""
     $title = "Check Admin on PC's"
$message = "Was the user removed from all Computers?"

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
    "Go Back To Menu."

$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
    "Go to R"

$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

$result = $host.ui.PromptForChoice($title, $message, $options, 0) 

switch ($result)
    {
        0 {cd C:\WorkScripts
            . .\menu.ps1}
        1 {cls
       write-host "Go to 'R' in the menu and delete the user" -BackgroundColor Red
       Write-host "Menu is shown in 10 sec"
       sleep 5
       Write-host "5"
       Sleep 1
       Write-host "4"
       Sleep 1
       Write-host "3"
       Sleep 1
       Write-host "2"
       Sleep 1
       Write-host "1"
       sleep 2

       cd C:\WorkScripts
            . .\menu.ps1
      }
    }
                    }
            }
        }  
        pause }
 "K" {cd C:\WorkScripts
        . .\Invoke-WSConfigurationTool.ps1}
 "L" {$cdsid = Read-host "Type the users CDSID to see memberOF"
 (Get-ADUser –Identity $cdsid  –Properties MemberOf).MemberOf -replace '^CN=([^,]+),OU=.+$','$1'
 Pause}
 "0" {  # Open ServiceNow Site  
 Start-Process -FilePath Chrome -ArgumentList https://volvocars.service-now.com}
 "1" {    # Get the SOP Document from Sharepoint
 $IE=new-object -com internetexplorer.application
            $IE.navigate2("https://sharepoint.volvocars.net/sites/ITprojects/2724DigitalWorkplaceOfferingforWindows10/_layouts/15/WopiFrame.aspx?sourcedoc=%7BB7B5546E-C7FB-4E52-997A-19B01AFB626E%7D&file=Test%20Cooridnator%20Guide.docx&action=default")
            $IE.visible=$true  }
 "2" {  # Open Test Result
        Start-Process -FilePath Chrome -ArgumentList "https://sharepoint.volvocars.net/sites/ITprojects/2724DigitalWorkplaceOfferingforWindows10/_layouts/15/WopiFrame.aspx?sourcedoc=%7B783679D3-F84C-4689-987A-1499CCF4614C%7D&file=Test%20results.xlsx&action=default"}
           
 "3" {# Open the sharepoint site
 $IE=new-object -com internetexplorer.application
$IE.navigate2("https://sharepoint.volvocars.net/sites/ITprojects/2724DigitalWorkplaceOfferingforWindows10/Project%20Plan%20Documents/Forms/AllItems.aspx?e=5%3Aa8de1ed735f74f7d967536deade2b766&RootFolder=%2Fsites%2FITprojects%2F2724DigitalWorkplaceOfferingforWindows10%2FProject%20Plan%20Documents%2FTest%20Factory&FolderCTID=0x012000DBD661C166FC34408B8CF253EFD97F7F" )
$IE.visible=$true

        }
 "4" {# Open Appmanager Online
            $IE=new-object -com internetexplorer.application
         $IE.navigate2("https://www.appmanager.online/" )
         $IE.visible=$true

        }            
 "5" {# Open Vsphere
 Start-Process -FilePath Chrome -ArgumentList https://gotsvw1535.got.volvocars.net/vsphere-client/?csp  

        }    
 "6" {# open SCCM client Site
 $IE=new-object -com internetexplorer.application
        $IE.navigate2("http://gotclw1003.got.volvocars.net/ts/en-us/default.aspx")
        $IE.visible=$true
        }
 "7" {# Start Trafiken.nu
 Start-Process -FilePath Chrome -ArgumentList https://trafiken.nu/goteborg/ } 
 "8" {# Open Nästa tur at Västtrafik
 $IE=new-object -com internetexplorer.application
$IE.navigate2("http://www.vasttrafik.se/nasta-tur-fullskarm/?externalid=9021014006650000&friendlyname=S%c3%b6rredsv%c3%a4gen+G%c3%b6teborg")
$IE.visible=$true

        }

      }


cd C:\WorkScripts
  

. .\menu.ps1
              
   
   
   
   
   
    
    
        



