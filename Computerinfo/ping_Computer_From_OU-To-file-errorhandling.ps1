$collection = gc  C:\temp\exportOpen.txt

foreach ($item in $collection)
{
  if (Test-Connection -computername $item -Quiet -Count 1) {
   #Get-ADComputer $item | select samaccountname | export-csv  c:\temp\online.csv -Delimiter ";" -Encoding Unicode -Append
   Get-ADComputer $item | select samaccountname | Out-File c:\temp\online3.txt -Append
} else {
   # $item | out-file c:\temp\NOTonline.txt
}  
}


