[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')  
  
$Computername = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Computername", "Name")  
  
 Function Get-computerinfo10{

    [CmdletBinding()]

param(
[string[]]$Computername
)
    
Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH)ConfigurationManager.psd1) 
cd ps1:

$os =     Get-wmiobject -class win32_operatingsystem -ComputerName $COMPUTERNAME
$CS =     Get-WmiObject -class win32_computersystem -ComputerName $Computername
# $Screen = Get-WmiObject -Class Win32_DesktopMonitor -ComputerName $Computername
$Bios =   Get-WmiObject win32_bios -ComputerName $Computername
$CM =     Get-CMDevice -Name $Computername

$Props = @{
           'Primary User' =     $cm.Username
           'OS version' =       $cm.DeviceOS 
           'Last Active Time' = $cm.LastActiveTime
           'Computername'=      $Computername;
           'OsVersion'=         $os.version;    
           'Model'=             $CS.model;         
           'RAM'=               $cs.totalphysicalmemory / 1GB -as [int];
           'Cores'=             $cs.numberoflogicalprocessors
           'SerialNumber'=      $bios.SerialNumber
           'InstallDate'=       $OS.ConvertToDateTime($OS.Installdate)
           
         }
         
         
$Obj = New-Object -typename psobject -property $props
}

$obj




