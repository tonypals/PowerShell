$limit = (Get-Date).AddDays(-1000)
$path = "E:\shares\hil_pte"

# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | 
Where-Object { !$_.PSIsContainer -and $_.lastwritetime -lt $limit } | 
select -First 20 | 
out-file c:\temp\OlderThan1000Days.txt

ii c:\temp\OlderThan1000Days.txt