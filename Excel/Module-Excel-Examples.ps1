get-service | export-excel -now   # Shows the file Filtrered

get-service | export-excel c:\temp\testexcel.xlsx # saves the file Unfiltrered

get-service | Export-Excel c:\temp\testexcel.xlsx -Show -AutoSize -AutoFilter # shows the file from the saved area, Filtered



rm c:\temp\test.xlsx -ErrorAction ignore  # remove testfile

$Data = Get-Service | select status,name,displayname,startType
$Text1 = New-ConditionalText stop

$Text2 = New-ConditionalText runn Blue Cyan
$Text3 = New-Conditionaltext svc wheat green

$data | Export-Excel c:\temp\test.xlsx -show -AutoSize # NO markings

rm c:\temp\test.xlsx -ErrorAction ignore  # remove testfile

$data | Export-Excel c:\temp\test.xlsx -show -AutoSize -ConditionalFormat $Text1 

$data | Export-Excel c:\temp\test.xlsx -show -AutoSize -autofilter -ConditionalFormat $Text1,$Text2,$Text3 ## Add info to a file and mark with red


########## Skapa pilar


rm c:\temp\test.xlsx -ErrorAction ignore  # remove testfile

$Data = Get-process | where company | select company,name,pm,handles,*mem*

$Cfmt = New-ConditionalFormattingIconSet -Range "D:D" -ConditionalFormat ThreeIconSet -IconType Arrows
$ctext = New-ConditionalText Microsoft wheat Green

#$Data | Export-Excel c:\temp\test.xlsx -show -AutoSize -ConditionalFormat $Cfmt

$Data | Export-Excel c:\temp\test.xlsx -show -AutoSize -ConditionalFormat $Cfmt -ConditionalText $ctext

