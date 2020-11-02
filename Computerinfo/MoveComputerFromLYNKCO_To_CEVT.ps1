<# 

This script compares users and computers in the LYNKCO-OU for Computers.
If a user is a LYNKCO user and the Computer is not in the LYNKCO-ou the computer will be moved to correct OU


#>


$tbl = New-Object System.Data.DataTable "Lync&CO Users and Computers"
$col1 = New-Object System.Data.DataColumn UserName
$col2 = New-Object System.Data.DataColumn DistinguishedName
$col3 = New-Object System.Data.DataColumn ComputerName
$col4 = New-Object System.Data.DataColumn ComputerOU
$col5 = New-Object System.Data.DataColumn extensionAttribute1
$col6 = New-Object System.Data.DataColumn extensionAttribute3                           # From CEVT to LYNKCO
$tbl.Columns.Add($col1)
$tbl.Columns.Add($col2)
$tbl.Columns.Add($col3)
$tbl.Columns.Add($col4)
$tbl.Columns.Add($col5)
$tbl.Columns.Add($col6)
 



$wronguser = @()
$wrongComputer = @()
$LyncComputer = Get-ADComputer -Filter * -SearchBase "OU=GOT,OU=Computers,OU=LYNKCO,DC=auto,DC=geely,DC=com"

foreach($Computer in $LyncComputer)
    { # Gets the PrimaryUser of the computer from SDPlus

        $ComputerName = $Computer.DNSHostName
        $URI = "http://SE-GOT-ASINFO01.auto.geely.com/GetAssetOwner/getAssetOwner.asmx"
        $WebService = New-WebServiceProxy -Uri $URI -ErrorAction Stop
        $Invocation = $WebService.GetUser($ComputerName)
        $PrimaryUser = $Invocation.Username
        $isLyncComputer= Get-ADComputer $Computer -Properties *                                 # From LYNKCO to CEVT

        try{
            $IsLyncuser = Get-ADUser $PrimaryUser -Properties *
            
            if(($IsLyncuser.extensionAttribute1 -eq 'GMSS.Employee') -or ($IsLyncuser.extensionAttribute1 -eq 'GMSS.Consultant') -or $IsLyncuser.extensionAttribute3 -like '20*')
                {
                    Write-Host "Computer correct" -ForegroundColor Green
                }
                else{
                    $row = $tbl.NewRow()
                    $row.UserName = $IsLyncuser.DisplayName
                    $row.DistinguishedName = $IsLyncuser.DistinguishedName
                    $row.ComputerName = $isLyncComputer.DNSHostName
                    $row.ComputerOU = $isLyncComputer.DistinguishedName
                    $row.extensionAttribute1 = $IsLyncuser.extensionAttribute1
                    $row.extensionAttribute3 = $IsLyncuser.extensionAttribute3
                    $tbl.rows.Add($row)

                }
            } catch {
                write-host "Did not find user" $PrimaryUser -ForegroundColor Red                      # From LYNKCO to CEVT
            }


    }



  #$tbl #| export-csv 'C:\temp\Move Computers from LYNKCO TO CEVT.csv' -Delimiter ";" -NoTypeInformation -Append -Encoding Unicode
    #ii 'C:\temp\Move Computers from LYNKCO TO CEVT.csv'

    # Here we can choose if we want to Move the Computers and set a Description


 $Date = Get-date -Format "yyMMdd-(HH.mm)"
 $DateDescription = Get-date -Format d

# Description for Disabled Computers:
    $Description = "Moved from LYNK-OU $DateDescription  //Tony Pålsson"                   # From LYNKCO to CEVT

foreach ($computer in $tbl.computername)
{ 

write-host $computer -ForegroundColor Green

# Change these for some ACTION:

$NewLogfile = "c:\temp\logfile_$date.txt"
Start-Transcript -Path $NewLogfile

        Set-Adcomputer $computer.TrimEnd(".auto.geely.com") -Description $Description 
        get-adcomputer $computer.TrimEnd(".auto.geely.com") | move-adobject -TargetPath "OU=GOT,OU=Computers,OU=CEVT,DC=auto,DC=geely,DC=com"

Write-Output "Moved Computers "$computer" from LYNKCO-OU to OU=GOT,OU=Computers,OU=CEVT"
 
Stop-Transcript

# Get Result:


    Get-ADcomputer $computer.TrimEnd(".auto.geely.com") -Properties * | select dist*,name,enabled,Description,LASTLOGONDATE


}

ii $NewLogfile