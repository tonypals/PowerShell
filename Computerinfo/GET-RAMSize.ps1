
  
$array = (30..60)
$array |
    foreach {
        
         $computername = "GOT500VI790$_.dhcp.nordic.volvocars.net"

          foreach ($item in $computername)
            {
                         
             
    



$os = Get-wmiobject -class win32_operatingsystem -ComputerName $COMPUTERNAME
$CS = Get-WmiObject -class win32_computersystem -ComputerName $Computername
$Screen = Get-WmiObject -Class Win32_DesktopMonitor -ComputerName $Computername
$Bios = Get-WmiObject win32_bios -ComputerName $Computername


$Props = @{'Computername'=$Computername;           
           
           
           'RAM'=$cs.totalphysicalmemory / 1GB -as [int];

           
           'InstallDate'=$OS.ConvertToDateTime($OS.Installdate)
          
           

           
         }
         
$Obj = New-Object -typename psobject -property $props


write-output $obj
write-output $last

     }

            }





