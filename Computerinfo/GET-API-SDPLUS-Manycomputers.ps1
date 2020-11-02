

 # Import the Computers from File
   $file = Get-Content "C:\temp\CompTest.txt"




# Check if the Computer contains .auto.geely.com, If not, it adds
$containsWord = $file | %{$_ -match "auto.geely.com"}

if ($containsWord -contains $true) {
 
} else {
   (get-content "C:\temp\CompTest.txt") | foreach { $_ + '.auto.geely.com' } | set-content "C:\temp\CompTest.txt"
}

$info=$()

$collection = get-content C:\temp\CompTest.txt

foreach ($ComputerName in $Collection)
{ 
  $URI = "http://SE-GOT-ASINFO01.auto.geely.com/GetAssetOwner/getAssetOwner.asmx" 
    $WebService = New-WebServiceProxy -Uri $URI -ErrorAction Stop
        $Invocation = $WebService.GetUser($ComputerName)
        $SDUser = $Invocation.Username

        # Removes .auto.geely.com so get-adcomputer works
                $ADComputer = Get-ADComputer -Properties * -Filter * | Where-Object {$_.dnshostname -like "$computername*"}  | Select -Property Name
                $aduser = Get-aduser $SDUser -Properties * | select samaccountname, Dist*
                #$Aduser = Get-ADuser $SDUser| Where-Object {$_.distinguishedname -like "*geely sales*"}



        $info+= $ADComputer.Name +";"
        $info+= $ADuser.SamAccountName;
        $info+= $ADuser.DistinguishedName

        Write-host "The Computer is" $ADComputer.Name -ForegroundColor Green
        Write-host "The user is" $aduser.SamAccountName -ForegroundColor Green       

}

$info | out-file c:\temp\out2.csv 

ii c:\temp\out2.csv













