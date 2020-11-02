remove-item c:\temp\af*.*,c:\temp\bful*.*

$Boxa = "MASTERCAR_308_VEP4_7DCT"
$Boxb = "MASTERCAR_H56_GEP3_PHEV_7DCT"

<#
MASTERCAR 111 VEP4-7DCT                                                                                                                                                                    
MASTERCAR 177 GEP-M76                                                                                                                                                                      
MASTERCAR 190 GEP-M76                                                                                                                                                                      
MASTERCAR 206 VEP4-7DCT                                                                                                                                                                    
MASTERCAR 227 VEP4-AWF21    

NEW********                                                                                                                                                               
MASTERCAR_308_VEP4_7DCT                                                                                                                                                                    
MASTERCAR_H56_GEP3_PHEV_7DCT
#>


$a = Get-Mailbox $boxa | FL 
$a1 = Get-CalendarProcessing $boxa | fl 
$afull = $a+$a1
$afull | Out-File c:\temp\afull.txt
$b = Get-Mailbox $boxb | FL 
$b1 = Get-CalendarProcessing $boxb | fl  
$bfull = $b + $b1
$bfull | Out-File c:\temp\bfull.txt
$file1 =  "C:\temp\afull.txt"
$file2 =  "C:\temp\bfull.txt"

#Compare-Object (Get-Content $file1) (Get-Content $file2) | where {$_.SideIndicator -eq "<="}  | out-file c:\temp\"$boxa"_To_"$boxb".txt
Compare-Object (Get-Content $file1) (Get-Content $file2) -IncludeEqual | out-file c:\temp\"$boxa"_To_"$boxb".txt

ii c:\temp\"$boxa"_To_"$boxb".txt

remove-item c:\temp\af*.*,c:\temp\bful*.*


