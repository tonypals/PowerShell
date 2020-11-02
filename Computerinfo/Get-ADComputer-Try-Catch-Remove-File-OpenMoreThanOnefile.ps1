<#
This script takes Computer info and add to a file. If the Computer don't exist it will be displayed in a TXT-file.
#>


# Set Variables
$Date = Get-date -Format "yyMMdd"
$Exists = "c:\temp\Computers_exists_$Date.csv"
$NOTExist = "c:\temp\Computers_dontexist_$Date.txt"
$existingcomputers = @()
$nonexistingcomputers = @()
$search = "DC=auto,DC=geely,DC=com"
$computer=$null
$computer=$null
$props=@()

# Removes Export-Files if existing

    if (Test-Path $Exists) {
      Remove-Item $Exists
    }  
    if (Test-Path $NOTExist) {
      Remove-Item $NOTExist
    }

# Get all Enabled CEVT computers. Change the Searchbase if needed 
    #$computers = Get-ADcomputer -Filter {enabled -ne $false } -Properties * -SearchBase $search 

# Import Computers from a CSV with SamAccountName in the Header
    #$computers = Import-csv -path C:\temp\datorersomkanskefinns.csv -Delimiter ";"

    $computers = Get-content C:\temp\Move-LynkCO_Computers.txt


# Sets all Properties that should be choosen

$props=@(
   'Name', 
    'DistinguishedName'
   'Description',
   'LastLogonDate'

)


foreach ($computer in $computers){
try{
        $adcomputer =    get-adcomputer $computer -properties * | 
        select $props
        $existingcomputers += $adcomputer      

    } # EndOf Try

    catch {
        #write-host "Unable to find $computer" -ForegroundColor Yellow
        $nonexistingcomputers += $computer
          } # Endof Catch


                         } # EndOf Foreach


# Export computers found to a CSV-file
    $existingcomputers | Export-csv -path $Exists -Delimiter ";" -NoTypeInformation -Append

# Export computer NOT Found to a Text-file
    $nonexistingcomputers | out-file $NOTExist -Append



#ls 'C:\temp' -R|?{$_.Name -like "*computer*"}| ii

Get-Childitem 'C:\Temp' -Recurse | Where-Object {$_.Name -like "*computers_*"} | Invoke-Item










