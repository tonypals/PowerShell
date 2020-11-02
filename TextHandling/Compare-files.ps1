remove-item c:\temp\af*.*,c:\temp\bful*.*





$afull = "1"
$afull | Out-File c:\temp\afull.txt
 
$bfull = "1 2 "
$bfull | Out-File c:\temp\bfull.txt
$file1 =  "C:\temp\afull.txt"
$file2 =  "C:\temp\bfull.txt"

#Compare-Object (Get-Content $file1) (Get-Content $file2) | where {$_.SideIndicator -eq "<="}  | out-file c:\temp\"$boxa"_To_"$boxb".txt
Compare-Object (Get-Content $file1) (Get-Content $file2) -IncludeEqual | out-file c:\temp\"$boxa"_To_"$boxb".txt

ii c:\temp\"$boxa"_To_"$boxb".txt

remove-item c:\temp\af*.*,c:\temp\bful*.*


