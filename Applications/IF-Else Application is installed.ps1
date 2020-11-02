$date = get-date -Format d
$Logfile = "c:\temp\$software_$(gc env:computername).log"

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}


$software = "*Word*";
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -like $software }) -ne $null

If(-Not $installed) {
	LogWrite "$date " " '$software' NOT is installed."; 
} else {
	LogWrite "$date " " '$software' is installed."
}

ii "c:\temp\$software_$(gc env:computername).log"