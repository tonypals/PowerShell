
$collection = $null

$collection = import-csv -path c:\temp\allPC.csv -Delimiter ";" 
   




foreach ($Computer in $collection)
{
  if (Test-Connection -computername $computer.name -Quiet -Count 1)
     {
        
 foreach ($computer in $collection)
 {
     $computer = $computer.name
 
 $Computer

 $Options = New-Object System.Management.EnumerationOptions
 $Options.Rewindable = $False

 $Scope = new-Object System.Management.ManagementScope("\\$Computer\Root\cimv2\sms")
 
 #class SMS_SystemConsoleUsage

     $Query = New-Object System.Management.ObjectQuery "SELECT * FROM SMS_SystemConsoleUsage"
     $Results = New-Object System.Management.ManagementObjectSearcher $Scope, $Query, $Options
     $Items = $Results.Get()

 ForEach ($Item In $Items)
 {    $computer 
     "TotalConsoleUsers: " + $Item.TotalConsoleUsers 
     "TopConsoleUser: " + $Item.TopConsoleUser 
 } 
 
 
 #class SMS_SystemConsoleUser
 
     $Query = New-Object System.Management.ObjectQuery "SELECT * FROM SMS_SystemConsoleUser"
     $Results = New-Object System.Management.ManagementObjectSearcher $Scope, $Query, $Options
     $Items = $Results.Get()

 ForEach ($Item In $Items)
 {   $computer
     "System Console User: " + $Item.SystemConsoleUser   
     write-host ("------------")
     write-host ("")
 } 

 } 

     } 

else {
        write-host $computer.name "svarar inte" -BackgroundColor Red
     }  
}



