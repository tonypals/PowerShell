$FileName = "c:\temp\exports\filename.txt"
if (Test-Path $FileName) {
  Remove-Item $FileName
}