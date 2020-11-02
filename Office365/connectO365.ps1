
#$credential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell `  -Credential z8tony.palsson@cevt.se `  -Authentication Basic -AllowRedirection


Import-PSSession $Session

#get-command -Module tmp_ap4mhok0.aw0

#https://outlook.office365.com/powershell-liveid/