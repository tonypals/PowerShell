
    
$ComputerName = 'CSEGOTLD924FWM4.auto.geely.com'


  $URI = "http://SE-GOT-ASINFO01.auto.geely.com/GetAssetOwner/getAssetOwner.asmx"
 #   Write-Log -Level Info -Message "Getting URL as $URI"
    $WebService = New-WebServiceProxy -Uri $URI -ErrorAction Stop


        $Invocation = $WebService.GetUser($ComputerName)
        $SDUser = $Invocation.Username
 




