 <# 

This script compares users and computers in the CEVT-OU For Computers.
If a user is a CEVT-user and the Computer is not in the CEVT- the computer will be moved to the LYNKCO-OU


#>


$tbl = New-Object System.Data.DataTable "Lync&CO Users and Computers"
$col1 = New-Object System.Data.DataColumn UserName
$col2 = New-Object System.Data.DataColumn DistinguishedName
$col3 = New-Object System.Data.DataColumn ComputerName
$col4 = New-Object System.Data.DataColumn ComputerOU
$col5 = New-Object System.Data.DataColumn extensionAttribute1
$col6 = New-Object System.Data.DataColumn extensionAttribute3
$tbl.Columns.Add($col1)                                                                           # From CEVT to LYNKCO
$tbl.Columns.Add($col2)
$tbl.Columns.Add($col3)
$tbl.Columns.Add($col4)
$tbl.Columns.Add($col5)
$tbl.Columns.Add($col6)




$wronguser = @()
$wrongComputer = @()
$LyncComputer = Get-ADComputer -Filter * -SearchBase "OU=GOT,OU=Computers,OU=CEVT,DC=auto,DC=geely,DC=com"
foreach($Computer in $LyncComputer)
    {
        $ComputerName = $Computer.DNSHostName
        $URI = "http://SE-GOT-ASINFO01.auto.geely.com/GetAssetOwner/getAssetOwner.asmx"
        $WebService = New-WebServiceProxy -Uri $URI -ErrorAction Stop
        $Invocation = $WebService.GetUser($ComputerName)
        $PrimaryUser = $Invocation.Username
        $isLyncComputer= Get-ADComputer $Computer -Properties * 
        try{
            $IsLyncuser = Get-ADUser $PrimaryUser -Properties *
            
            if(!($IsLyncuser.extensionAttribute1 -eq 'GMSS.Employee') -or ($IsLyncuser.extensionAttribute1 -eq 'GMSS.Consultant'))
                {
                    Write-Host "Computer correct" -ForegroundColor Green
                }
                else{
                    $row = $tbl.NewRow()
                    $row.UserName = $IsLyncuser.DisplayName
                    $row.DistinguishedName = $IsLyncuser.DistinguishedName
                    $row.ComputerName = $isLyncComputer.DNSHostName
                    $row.ComputerOU = $isLyncComputer.DistinguishedName                                                # From CEVT to LYNKCO
                    $row.extensionAttribute1 = $IsLyncuser.extensionAttribute1
                    $row.extensionAttribute3 = $IsLyncuser.extensionAttribute3
                    $tbl.rows.Add($row)

                }
            } catch {
                write-host "Did not find user" -ForegroundColor Red
            }


    }

    
    $tbl | export-csv 'C:\temp\Move Computers from CEVT to LynkCO.csv' -Delimiter ";" -NoTypeInformation -Append -Encoding Unicode
    ii 'C:\temp\Move Computers from CEVT to LynkCO.csv'

     # Here we can choose if we want to Move the Computers and set a Description


$Date = Get-Date -Format d 

# Description for Disabled Computers:
    $Description = "Moved from CEVT-OU $date  //Tony Pålsson"
                                                                                            # From CEVT to LYNKCO
foreach ($computer in $tbl.computername)
{ 

write-host $computer -ForegroundColor Green

# Change these for some ACTION:

        #Set-Adcomputer $computer -Description $Description 
        #get-adcomputer $computer | move-adobject -TargetPath "OU=GOT,OU=Computers,OU=lynkco,DC=auto,DC=geely,DC=com"

# Get Result:


    Get-ADcomputer $computer.TrimEnd(".auto.geely.com") -Properties * | select dist*,name,enabled,Description,LASTLOGONDATE


}
