# Get Groups with name like ** 
$Date = get-date -Format HHmmss

$OutFileName = "c:\temp\exports\grouplist_$date.csv"
if (Test-Path $OutFileName) {
  Remove-Item $OutFileName
}
$TempImport = "c:\temp\exports\Dirtyimport.txt"
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

    Get-ADGroup -filter {Name -like '*admin*'} -SearchBase  "OU=CEVT,DC=auto,DC=geely,DC=com"  -Properties name | select name | sort name |out-file $TempImport 
    get-adgroup  -Filter * -SearchBase  "OU=Admin-Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Properties name | select name | sort name | out-file $TempImport -Append

# Clean up the importfile from Blanks, Name and Rows

    (get-content $TempImport) -replace 'name','' -replace '----', '' -notmatch '^\s*$'  > $SortedImport

# Remove all Duplicates in the SortedImport-file

    $hash = @{}      # define a new empty hash table
    gc $SortedImport | 
    %{if($hash.$_ -eq $null) { $_ }; $hash.$_ = 1} > $Import

# Import the Clean-Sorted list without any Duplicates

    $groups = Get-Content $Import

# Create an Array and add info to the CSV-file

$resultsarray =@()

foreach ($Group in $Groups)
{
    try
    {
        $GroupInfo = Get-adgroup $group.TrimEnd() -Properties * 
        $resultsarray += Get-ADGroupMember $group.TrimEnd()| 
        select name,
                    @{Expression={$group};Label="Group Name"},
                    @{Expression={$Groupinfo.description};Label="Group Description"},
                    @{Expression={$Groupinfo.ManagedBy};Label="ManagedBy"},
                    @{Expression={$Groupinfo.WhenCreated};Label="WhenCreated"} 
    }

    # Send all groups that are not identified to a file
    catch
    {
        Write-Output "Error: $_" | Tee-Object $ErrorLog -Append
    }
}

# clean up ErrorLog and remove files
      #(get-content $TempErrorLog) -replace 'Error: An operations error occurred','' -replace 'Error: There is no such object on the server', ''  -notmatch '^\s*$'  > $ErrorLog

    Remove-item  $TempImport,$SortedImport,$Import,$TempErrorLog
      
# Export the array to the CSV-File

    $resultsarray| Export-csv -path $OutFileName -notypeinformation

# Start the file c:\temp\exports\grouplist.csv

    invoke-item $OutFileName 

# Start the File C:\temp\Exports\Errors.txt

    invoke-item $ErrorLog