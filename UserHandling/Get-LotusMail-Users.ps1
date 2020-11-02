# This Script gets a list of users with the name Lotus in the Mail-address and exports to a CSV
# Tony Pålsson 2020-04-24

$Date = get-date -Format d

#region checkfolder
$path = "C:\temp"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}
#endregion checkfolder


Get-aduser -filter {mail -like '*lotus*'} -Properties * |
select samaccountname, mail,lastlogondate | export-csv -Path $Path\LotusUsers_$Date.csv -Delimiter ";" -NoTypeInformation

ii $Path\LotusUsers_$Date.csv