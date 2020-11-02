
$Name = "s"

$MappedDrive = (Get-PSDrive -Name $Name -ErrorAction SilentlyContinue)

#Check if drive is already mapped
if($MappedDrive)
        {
          #Drive is mapped. Check to see if it mapped to the correct path
          if($MappedDrive.DisplayRoot -ne $Path)
                  {
                  write-host "Drive is not mapped so it gets mapped now"
                    # Drive Mapped to the incorrect path. Remove and readd:
                      net use s: /d 
                      net use s: \\segot-s102\c$
                  }
        }
else
                 {
                      Write-host "Drive is not mapped"
                      net use s: \\segot-s102\c$
                 }

#region removeCSV
$FileName1 = "H:\Powershell\TCtraining\FormToFill.csv"
if (Test-Path $FileName1) {
  Remove-Item $FileName1
}
#endregion removecsv
        
#region Convert

Function ExcelToCsv ($File) {
    $myDir = "H:\Powershell\TCtraining"
    $excelFile = "$myDir\" + $File + ".xlsx"
    $Excel = New-Object -ComObject Excel.Application
    $wb = $Excel.Workbooks.Open($excelFile)
	
    foreach ($ws in $wb.Worksheets) {
        $ws.SaveAs("$myDir\" + $File + ".csv", 6)
    }

   $excel.Quit()
}
#endregion convert

$FileName = "FormToFill"
ExcelToCsv -File $FileName

copy $FileName1 S:\Scripts\CEVT-Education


net use s: /d 










