#Shows all Enabled Computers with "Dis*" in the description

cls
$path = $null
$path = (get-addomain).distinguishedname
$Filename = "h:\Exports\Enabled with Wrong Description-$(get-date -format d).csv"

# Checks if file exists, Deletes if exists

if (Test-Path $FileName) 

    {Remove-Item $FileName}


Get-ADComputer -Properties * -Filter {(Enabled -eq $True)} | where {($_.description -like "*disabled*" ) -or ($_.description -like "*move*")} |
select name,description,enabled,whencreated,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}} |
export-csv -Path $Filename -Delimiter ";" -NoTypeInformation -Encoding Unicode    

#Clean the screen and show message
 cls
 dir $Filename
 Write-host ""
 Write-host " Då var det klart!" -ForegroundColor Green
