<#
https://lazywinadmin.com/2014/03/powershell-read-excel-file-using-com.html

[cmdletbinding()]
PARAM (
    [Parameter(Mandatory,
        HelpMessage = "You must specify the full path of the file")]
    [ValidateScript( { Test-Path -Path $_ })]
    $Path,
    [Parameter(Mandatory,
        HelpMessage = "You must specify the SheetName of the Excel file")]
    $Sheet)

    #>

#Specify the path of the excel file
$FilePath = "C:\temp\dropUtanMacro.xlsx"

#Specify the Sheet name
$SheetName = "Buildspecs"

# Create an Object Excel.Application using Com interface
$objExcel = New-Object -ComObject Excel.Application
# Disable the 'visible' property so the document won't open in excel
$objExcel.Visible = $false
# Open the Excel file and save it in $WorkBook
$WorkBook = $objExcel.Workbooks.Open($FilePath)
# Load the WorkSheet 'BuildSpecs'
$WorkSheet = $WorkBook.sheets.item($SheetName)

[pscustomobject][ordered]@{
    "Education Responsible"      = $WorkSheet.Range("A2").Text
    "Education StartDate"        = $WorkSheet.Range("B2").Text
    NumberOfUsers                = $WorkSheet.Range("C2").Text
    Company                      = $WorkSheet.Range("D2").Text

}