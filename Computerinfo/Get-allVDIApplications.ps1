$date = get-date -format d
$output = "c:\temp\VDI-applikationer_$date.txt"
remove-item $output -ErrorAction SilentlyContinue
$array = (45..45)
$array |
    foreach {
        
        $computername = "GOT500VI790$_"

  foreach ($item in $computername)
    {  

           
          $computername | Out-File $output -Append
       
            # Get Applications from Computer with WMI:

            Get-WmiObject -Namespace "root\cimv2" -Class Win32_product -ComputerName $computername | select Name | 
            Where-Object {$_.name -notlike "*office*" -and $_.name -notlike "*mcafee*" -and $_.name -notlike "*lync*" -and $_.name -notlike "*english*" -and $_.name -notlike "*anyconnect*" -and $_.name -notlike "*configuration*" -and $_.name -notlike "*horizon*" -and $_.name -notlike "*java 8 update 72*" -and $_.name -notlike "*JRE DeploymentRuleSet 1.10*" -and $_.name -notlike "*Microsoft Azure Information Protection*" -and $_.name -notlike "*onedrive setup installer*" -and $_.name -notlike "*vmware tools*" -and $_.name -notlike "*silverlight*" -and $_.name -notlike "*Microsoft Policy Platform*"  -and $_.name -notlike "*VCC desktop*"  -and $_.name -notlike "*Appdisco*"  -and $_.name -notlike "*Microsoft Visual C++ 2008*" -and $_.name -notlike "*Microsoft Visual C++ 2012*" -and $_.name -notlike "*Microsoft Visual C++ 2013*"} | sort name |
              Out-File $output -Append 
       
                
         }
         } 
         
         ii $output