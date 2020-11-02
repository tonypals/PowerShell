$strCategory = "computer" 
$strOperatingSystem = "Windows*Server*" 
 
$objDomain = New-Object System.DirectoryServices.DirectoryEntry 
 
$objSearcher = New-Object System.DirectoryServices.DirectorySearcher 
$objSearcher.SearchRoot = $objDomain 
 
$objSearcher.Filter = ("OperatingSystem=$strOperatingSystem") 
 
$colProplist = "name" 
foreach ($i in $colPropList){$objSearcher.PropertiesToLoad.Add($i)} 
 
$colResults = $objSearcher.FindAll() 
 
foreach ($objResult in $colResults) 
    { 
    $objComputer = $objResult.Properties;  
    $objComputer.name  | out-file c:\temp\servers.txt -Append
    } 


    ii c:\temp\servers.txt