[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')  
  
$Computername = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Computername", "Name")  
  
 # [CmdletBinding()]
    #param(
        #[Parameter(Mandatory=$True)]
        #[String]$Computername
       
    #)
    
Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH)ConfigurationManager.psd1) 
cd ps1:
$last = get-cmdevice -name $Computername | select UserName, LastActiveTime

$os = Get-wmiobject -class win32_operatingsystem -ComputerName $COMPUTERNAME
$CS = Get-WmiObject -class win32_computersystem -ComputerName $Computername
$Screen = Get-WmiObject -Class Win32_DesktopMonitor -ComputerName $Computername
$Bios = Get-WmiObject win32_bios -ComputerName $Computername
$CM = Get-CMDevice -Name $Computername

$Props = @{'Computername'=$Computername;
           'OsVersion'=$os.version;    
           'Model'=$CS.model;
           'Manufacturer'=$cs.manufacturer;
           'RAM'=$cs.totalphysicalmemory / 1GB -as [int];
           'Cores'=$cs.numberoflogicalprocessors
          'ScreenWidth'=$Screen.ScreenWidth
           'ScreenHight'=$Screen.screenHeight
           'SerialNumber'=$bios.SerialNumber
           'InstallDate'=$OS.ConvertToDateTime($OS.Installdate)
           'Primary User' = $cm.Name
           'OS version' = $cm.DeviceOS
           

           
         }
         
$Obj = New-Object -typename psobject -property $props


write-output $obj
write-output $last
c:
cd C:\Script




