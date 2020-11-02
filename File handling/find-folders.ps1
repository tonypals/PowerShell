function find-folder
{ $input | Where-Object {$_.name -eq "windows"}}
gci -Path c:\ | find-folder
