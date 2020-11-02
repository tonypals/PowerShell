
#$startFolder = "\\segot-s040\cevt\IT-Software"

$startFolder = "C:\Users\tony.palsson\OneDrive - CEVT\Powershell"


#New-PSDrive –Name  X –PSProvider FileSystem –Root "\\segot-s040\cevt\IT-Software" –Persist


cd $startFolder

ls -Force | 
Add-Member -Force -Passthru -Type ScriptProperty -Name Length -Value {ls $this -Recurse -Force |
 Measure -Sum Length | Select -Expand Sum } | 
 Sort-Object Length -Descending | Format-Table @{label="TotalSize (MB)";expression={[Math]::Truncate($_.Length / 1MB)};width=14}, @{label="Mode";expression={$_.Mode};width=8}, Name