
cls
$collection = $null


#$collection = import-csv -path c:\temp\allPC.csv -Delimiter ";"  

$collection = get-adcomputer -filter * -SearchBase  "OU=Got,OU=Computers,OU=CEVT,DC=auto,DC=geely,DC=com" | select name


foreach ($Computer in $collection)
{
  if (Test-Connection -computername $computer.name -Quiet -Count 1)
     {
    # write-host $Computer.name "svarar fint" -BackgroundColor Green
         
                                 
             
                 $computer = $computer.name 
                 $Options = New-Object System.Management.EnumerationOptions
                 $Options.Rewindable = $False
                 $Scope = new-Object System.Management.ManagementScope("\\$Computer\Root\cimv2\sms")
 
         #class SMS_SystemConsoleUsage

                 $Query = New-Object System.Management.ObjectQuery "SELECT * FROM SMS_SystemConsoleUsage"
                 $Results = New-Object System.Management.ManagementObjectSearcher $Scope, $Query, $Options                
                 $computers = $Results.Get()
                

                     ForEach ($computer In $computers)
                     {    
                          "Computername:" + $computer.PSComputerName
                          "TotalConsoleUsers: " + $computer.TotalConsoleUsers 
                          "TopConsoleUser: " + $computer.TopConsoleUser                       
                          
                          
                     } 
 
 
 #class SMS_SystemConsoleUser
 
                 $Query = New-Object System.Management.ObjectQuery "SELECT * FROM SMS_SystemConsoleUser"
                 $Results = New-Object System.Management.ManagementObjectSearcher $Scope, $Query, $Options
                 $computers = $Results.Get()

                     ForEach ($computer In $computers)
                     {    
                         "System Console User: " + $computer.SystemConsoleUser   
                           "*************************** " 
                        
                     } 

 } 

     } 

                        else {
                                write-host $computer.name "svarar inte" -BackgroundColor Red
                             }  



#  & '.\get all pingable pcs topconsole users.ps1' | Out-File c:\temp\results.csv
