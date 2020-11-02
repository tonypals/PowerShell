
    Remove-Variable compu*

    Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH)ConfigurationManager.psd1) 
    cd ps1:

#$Computername = import-csv C:\temp\Deletecomputers.csv
$Computername = "SEGOT-LMG1SVG "

foreach ($computer in $Computername) {

$name = $computer.Computername
        #Remove-CMDevice -Name $name -Force
        #Remove-ADComputer -Identity $name -Confirm:$false



Get-ADComputer $name | select name
Get-CMDevice -Name $name | select name 
      
      
        Write-host "*****************************"

}

