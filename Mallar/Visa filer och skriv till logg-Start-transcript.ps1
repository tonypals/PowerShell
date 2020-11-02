$date = get-date -Format d
$Logfile = "c:\temp\test.txt"
$path = "c:\temp"
 
Start-Transcript -Path $Logfile
 
#Doing some stuff with the Verbose parameter
 
Get-ChildItem $path -Recurse | select name
 

 
Write-Output 'Writing some text to the log file'
 
Stop-Transcript

ii "$Logfile"