$ErrorActionPreference = "SilentlyContinue"
$excludeDirectories = 'desktop.ini','appdata'


$user = "z7ctxinstall"


$path = "c:\users"

Get-ChildItem -Recurse -Hidden  $path -force | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-100)} 
sort lastwritetime

select lastwritetime,name 

 
out-file c:\temp\z7ctx.txt

ii c:\temp\z7ctx.txt




Get-ChildItem $path -Hidden -Recurse | select lastwritetime,name | sort lastwritetime

Get-ChildItem $path  -hidden -Recurse  | 
Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-30)} | 
select lastwritetime,name | sort lastwritetime



Get-ChildItem $path -Recurse 



