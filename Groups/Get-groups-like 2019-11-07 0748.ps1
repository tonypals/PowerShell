$fileoutput = "c:\temp\multigroup.csv"
if (Test-Path $fileoutput) {
  Remove-Item $Fileoutput
}

# Get Groups with name like ** 
$Date = get-date -Format HHmmss

$OutFileName = "c:\temp\exports\grouplist_$date.csv"
if (Test-Path $OUtFileName) {
  Remove-Item $OutFileName
}

$TempImport = "c:\temp\exports\Tempimport.txt"
if (Test-Path $TempImport) {
  Remove-Item $TempImport}

$ErrorLog = "C:\temp\Exports\Errors_$Date.txt"

$TempErrorLog = "C:\temp\Exports\tempError.txt"
if (Test-Path $TempErrorLog) {
  Remove-Item $TempErrorLog}

$SortedImport = "c:\temp\exports\cleanimport.txt"
if (Test-Path $SortedImport) {
  Remove-Item $SortedImport}

$Import= "c:\temp\exports\import.txt"
if (Test-Path $Import) {
  Remove-Item $Import}



# Get all groups named "Admin" and all Groups in the "Admin Groups-OU"


     Get-ADGroup -filter {Name -like '*citrix*' -and name -notlike 'LYNKCO-Users-Outlook-Settings' -and name -notlike 'G-CEVT-Exchange-OP'} -SearchBase  "OU=CEVT,DC=auto,DC=geely,DC=com"  -Properties name | select name | sort name | out-file $TempImport
    
    #Get-ADGroup -filter {Name -like '*admin*' -and name -notlike 'LYNKCO-Users-Outlook-Settings' -and name -notlike 'G-CEVT-Exchange-OP'} -SearchBase  "OU=CEVT,DC=auto,DC=geely,DC=com"  -Properties name | select name | sort name | out-file $TempImport 
    #Get-Adgroup -Filter * -SearchBase  "OU=Admin-Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Properties name | select name | sort name | out-file $TempImport -Append

    $content = Get-Content $TempImport

    # Remove all empty space in the end of each Row

            $content | 
            Foreach {$_.TrimEnd()} | 
            Set-Content $TempImport
   

# Clean up the importfile from Blanks, Name and Rows

    (get-content $TempImport) -replace 'name','' -replace '----' -notmatch '^\s*$'  > $SortedImport

# Remove all Duplicates in the SortedImport-file

    $hash = @{}      # define a new empty hash table
    Get-Content $SortedImport | 
    ForEach-Object{if($hash.$_ -eq $null) { $_ }; $hash.$_ = 1} > $Import

# Import the Clean-Sorted list without any Duplicates

    $groups = Get-Content $Import


$selectgroups= $groups | 
                Get-Adgroup -Properties *
    $report = foreach($group in $selectgroups)
    {
       Try
       {
            $group |
            get-adgroupmember  |
            Get-ADUser -property enabled,lastlogondate | 
            Select @{n="Group";e={$group.Name}}, 
            @{n="Description";e={$group.Description}},
            @{n="WhenCreated";e={$group.whencreated}},
            @{name="OU";expression={($Group.DistinguishedName -split ",OU=")[1]}},  # Tillagt
            samaccountname, 
            enabled,
            lastlogondate -ErrorAction stop
        }
        Catch
        {        Write-Output "Error: $_" | Tee-Object $ErrorLog -Append
        }

    }
$report  |Export-Csv $OutFileName -Delimiter ";" -NoTypeInformation

Remove-item $TempImport,$SortedImport,$Import

ii $OutFileName