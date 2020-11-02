$DeptCons =Get-ADGroup -Filter {name -like "*consultants" -and name -like "*dept*"} -Properties  * | select name,description,managedby

$UnitCons = Get-ADGroup -Filter {name -like "*consultants" -and name -like "*Unit*"} -Properties * | select name,description,managedby

$UnitEmployees = Get-ADGroup -Filter {name -like "*Employees" -and name -like "*Unit*"} -Properties * | select name,description,managedby

$DeptEmployees = Get-ADGroup -Filter {name -like "*Employees" -and name -like "*Dept*"} -Properties * | select name,description,managedby

$UnitVCC =Get-ADGroup -Filter {name -like "*VCC" -and name -like "*Unit*"} -Properties * | select name,description,managedby

$DeptVCC = Get-ADGroup -Filter {name -like "*VCC" -and name -like "*Dept*"} -Properties * | select name,description,managedby

#$DeptCons
#$UnitCons
#$DeptEmployees
#$UnitEmployees
#$deptvcc
#$Unitvcc
$all = $DeptCons+$UnitCons+$DeptEmployees+$UnitEmployees+$deptvcc+$unitvcc

$DeptCons | export-csv -path c:\temp\allConsultantsDept.csv -Delimiter ";" -NoTypeInformation -Encoding Unicode
$UnitCons | export-csv -path c:\temp\allConsultantsUnit.csv -Delimiter ";" -NoTypeInformation -Encoding Unicode
$DeptEmployees | export-csv -path c:\temp\allEmployeeDept.csv -Delimiter ";" -NoTypeInformation -Encoding Unicode
$UnitEmployees | export-csv -path c:\temp\allEmployeeUnit.csv -Delimiter ";" -NoTypeInformation -Encoding Unicode
$deptvcc | export-csv -path c:\temp\allVCCDept.csv -Delimiter ";" -NoTypeInformation -Encoding Unicode
$Unitvcc | export-csv -path c:\temp\allVCCUnit.csv -Delimiter ";" -NoTypeInformation -Encoding Unicode
$all | export-csv -path c:\temp\allUnitsANDDept.csv -Delimiter ";" -NoTypeInformation -Encoding Unicode