$Policy = "CEVT-Client-AccessDirectorSetting"
$Path = "C:\temp\Policy_$Policy.xml"

Get-GPOReport -Name $Policy -ReportType xml -Path $path

[xml]$test = Get-Content $Path
$users = $test.GPO.Computer.ExtensionData.extension.LocalUsersAndGroups.Group.Properties.Members.Member 





$SAMexistingusers = @()
$SAMnonexistingusers = @()


foreach ($user in $users.name.trimstart("AUTO\")){
try{
        # Get Aduser by Samaccountname

        $aduser =    get-aduser $user -properties * | select samaccountname, enabled
          Write-host $user "Is existing With SamAccountName" -ForegroundColor Green
        $SAMexistingusers += $aduser
        

    }
    catch {
         Write-Host "Didn't find" $user "By SamAccountName" -ForegroundColor Yellow
        $SAMnonexistingusers += $user
        $user |
        Out-file c:\temp\NONExistBySamAccountName.txt -Append
    }


}


$SIDDexists = @()
$SIDnonexist = @()


foreach($usersid in $users) {
    try{

    # Get ADUser by Sid

        $user = Get-ADUser -Identity $usersid.sid | select samaccountname
        Write-host $user.samaccountname "Is existing With SID" -ForegroundColor Green
        $SIDexists += $user
    }
    catch {
        Write-Host "didnt find $($usersid.name) By SID" -ForegroundColor Yellow
        $SIDnonexist += $usersid
        $($usersid).name | 
        Out-file c:\temp\NONExistsBySID.txt -Append
    }
}

Cls
<#
Write-host "Existing Users with Samaccountname: " $SAMexistingusers.Count -ForegroundColor Green
Write-host "Existing Users with SID: " $SIDexists.count -ForegroundColor Green
Write-host ""
Write-host "NONExisting Users with Samaccountname: " $SAMnonexistingusers.Count -ForegroundColor red
Write-host "NONExisting Users with SID: " $SIDnonexist.Count -ForegroundColor red

#>



ls 'C:\temp' -R|?{$_.Name -like "*exist*"}|ii











