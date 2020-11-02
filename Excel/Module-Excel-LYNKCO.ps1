if (Get-Module -ListAvailable -Name importexcel) {
  # this is a test 

  # This is another test
} 
else {
    install-module importexcel
}
rm c:\temp\test.xlsx -ErrorAction ignore  # remove testfile
$data = Get-ADUser -Filter {enabled -ne $false} -Properties * -SearchBase "OU=Geely Sales Users,OU=CEVT,DC=auto,DC=geely,DC=com" | select name,company,mail,surname


$Text1 = New-ConditionalText Borg
$Text2 = New-ConditionalText Fredrika Blue Cyan
$Text3 = New-Conditionaltext irene wheat green

$data | 
Export-Excel c:\temp\test.xlsx -show -AutoSize -autofilter -ConditionalFormat $Text1,$Text2,$Text3 ## Add info to a file and mark with red


