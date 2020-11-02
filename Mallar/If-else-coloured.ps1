$strComputer = "."

$colItems = get-wmiobject -class "Win32_Process" -namespace "root\CIMV2" `
-computername $strComputer | write-output

foreach ($objItem in $colItems) {
      if ($objItem.WorkingSetSize -gt 3000000) {
      write-host  $objItem.Name, $objItem.WorkingSetSize -foregroundcolor "magenta" }
     else {write-host  $objItem.Name, $objItem.WorkingSetSize}
}
