


$computers = get-content C:\temp\disabled.txt

foreach ($computer in $computers){

ping $computer

get-adcomputer $Computer  -Properties * | select name,@{N='LastLogon'; E={[DateTime]::FromFileTime($_.LastLogon)}},@{N='LastLogontimestamp'; E={[DateTime]::FromFileTime($_.LastLogontimestamp)}}

}