<######################

Här samlar jag alla bra saker att ha i ett script

#########################################>


# Export och Import CSV av Användare

                $Date = Get-date -Format "yyMMdd"#-(HH.mm)"
                $ImportPath = "C:\Temp\Users.txt"
                $ExportPath = "C:\Temp\UsersExport-$date.csv"
            
                   
                    if (Test-Path $ExportPath) {
                    Remove-Item $ExportPath
                    }
                    
                $Users = get-content -path $ImportPath

                        foreach ($User in $Users){

                        Get-AdUser $user -Properties mail | 
                                            select samaccountname,mail |
                                            export-csv -Path $ExportPath -Delimiter ";" -NoTypeInformation -Append

                                                 } # End Foreach


                ii $ExportPath



# Export och Import CSV gällande Datorer


                $Date = Get-date -Format "yyMMdd-(HH.mm)"
                $Path = "C:\Temp\ComputerInfo_$date.csv"



                $Computers = Import-csv -path c:\Temp\ComputerImport.csv -Delimiter ";"

                    foreach ($Computer in $Computers){

                    Get-ADComputer $Computer

                                                       } # End Foreach

                ii $Path

# ********************************


# Export och Import CSV av Användare

                $Date = Get-date -Format "yyMMdd-(HH.mm)"
                $Path = "C:\Temp\Users_$date.csv"



                $User = Import-csv -path c:\temp\UserImport.csv -Delimiter ";"

                        foreach ($User in $Users){

                        Get-AdUser $user

                                                 } # End Foreach


                ii $Path

# ***************************


$Date = Get-date -Format "yyMMdd-(HH.mm)"
$Path = "C:\Temp\ComputerInfo_$date.csv"
$FileName = "c:\temp\exports\filename.txt"
if (Test-Path $FileName) {
  Remove-Item $FileName
}


*********************************************************************************

$search = "OU=CEVT,DC=auto,DC=geely,DC=com"


$props=@(
   'Name',
   'SAMAccountName',
   'Description',
   'Enabled',
   'created',
   'modified',
   'Company',
   @{Name="MemberOf";expression={($_.memberof | %{(Get-ADGroup $_).sAMAccountName}) -join ";"}},
   'LastLogonDate',
   @{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}}
   'LockedOut'
   @{name="OU2";expression={($_.DistinguishedName -split ",OU=")[2]}}
   @{name="OU3";expression={($_.DistinguishedName -split ",OU=")[3]}}
)

Get-ADUser -Filter {enabled -ne $false } -Properties * -SearchBase $search | 
select $props | 
select samaccountname,Company,OU2,OU3,manager | export-Csv "C:\temp\AllCEVT-users-with-NR-OU.csv" -notypeinfo -encoding "UTF8" -Append

ii C:\temp\AllCEVT-users-with-NR-OU.csv

***************************************************************************
$Policy = "CEVT-Client-AccessDirectorSetting"
$Path = "C:\temp\Policy_$Policy.xml"

Get-GPOReport -Name $Policy -ReportType xml -Path $path

[xml]$test = Get-Content $Path
$users = $test.GPO.Computer.ExtensionData.extension.LocalUsersAndGroups.Group.Properties.Members.Member | select name
$users.name.trimstart("AUTO\")


$existingusers = @()
$nonexistingusers = @()


foreach ($user in $users.name.trimstart("AUTO\")){
try{
        $aduser =    get-aduser $user -properties * | select samaccountname, enabled
        $existingusers += $aduser

    }
    catch {
        #write-host "Unable to find $user" -ForegroundColor Yellow
        $nonexistingusers += $user
    }


}
$existingusers
$nonexistingusers

ls 'C:\temp' -R|?{$_.Name -like "*exist*"}|ii