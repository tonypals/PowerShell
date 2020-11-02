


#$User = Read-host "Type in your z8-account"
$user = "z8tony.palsson"
$PWord = ConvertTo-SecureString -String "password" -AsPlainText -Force
$Credential = Get-Credential -Credential "auto\$user"
$net = $(New-Object -ComObject WScript.Network)
$net.MapNetworkDrive("s:", "\\segot-s102\c$")