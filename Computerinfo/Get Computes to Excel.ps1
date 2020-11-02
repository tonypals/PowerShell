$erroractionpreference = "SilentlyContinue"
$a = New-Object -comobject Excel.Application
$a.visible = $True 
Add-Type -AssemblyName Microsoft.Office.Interop.Excel
$xlFixedFormat = [Microsoft.Office.Interop.Excel.XlFileFormat]::xlWorkbookDefault


$a.Visible = $true

$b = $a.Workbooks.Add()
$c = $b.Worksheets.Item(1)

$c.Cells.Item(1,1) = "Server Name"
$c.Cells.Item(1,2) = "Drive"
$c.Cells.Item(1,3) = "Total Size (GB)"
$c.Cells.Item(1,4) = "Free Space (GB)"
$c.Cells.Item(1,5) = "Free Space (%)"

$d = $c.UsedRange
$d.Interior.ColorIndex = 19
$d.Font.ColorIndex = 11
$d.Font.Bold = $True

$intRow = 2

$colComputers = get-content "c:\temp\servers.txt"
foreach ($strComputer in $colComputers)
{
$colDisks = get-wmiobject Win32_LogicalDisk -computername $strComputer -Filter "DriveType = 3" 
foreach ($objdisk in $colDisks)
{
$c.Cells.Item($intRow, 1) = $strComputer.ToUpper()
$c.Cells.Item($intRow, 2) = $objDisk.DeviceID
$c.Cells.Item($intRow, 3) = "{0:N0}" -f ($objDisk.Size/1GB)
$c.Cells.Item($intRow, 4) = "{0:N0}" -f ($objDisk.FreeSpace/1GB)
$c.Cells.Item($intRow, 5) = "{0:P0}" -f ([double]$objDisk.FreeSpace/[double]$objDisk.Size)
$intRow = $intRow + 1
}
}

$a.workbooks.OpenText($file,437,1,1,1,$True,$True,$False,$False,$True,$False)
$a.ActiveWorkbook.SaveAs("C:\Users\Username\Desktop\myfile.xls", $xlFixedFormat)

$a.Workbooks.Close()
$a.Quit() 