$pathToFile = "c:\temp\exportest.txt"
$stringtoreplace = "Domain Users;G-CEVT-Users;G-CEVT-SharePoint-Users;GD-GOT-Users;"
$replacewith = ""
$PathOUtfile = "c:\temp\test3.txt"

get-content $pathToFile | % { $_ -replace $stringToReplace, $replaceWith } | set-content $pathOUTFile

$PathOUtfile4 = "c:\temp\test4.txt"
$stringtoreplace = "CEVT-FineGrain;"
$replacewith = ""
get-content $pathOUTFile | % { $_ -replace $stringToReplace, $replaceWith } | set-content $pathOUTFile4


$PathOUtfile5 = "c:\temp\test5.txt"
$stringtoreplace = "G-CEVT-VPN-CERT;"
$replacewith = ""
get-content $pathOUTFile4 | % { $_ -replace $stringToReplace, $replaceWith } | set-content $pathOUTFile5


ii c:\temp\test5.txt
