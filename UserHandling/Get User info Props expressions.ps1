Function Get-PropsInfo {

$path = (get-addomain).distinguishedname
$Date = Get-Date -Format "yy-MM-dd_HHmm"

#region OUs

# CEVT Users:
    $AllCEVT = "OU=CEVT,$path"
    $CEVTEmployees = "OU=CEVT,OU=Cevt users,OU=CEVT,$path"
    $Consultants = "OU=Consultants,OU=Cevt users,OU=CEVT,$path"
    $consultantsIT = "OU=consultants-it,OU=Cevt users,OU=CEVT,$path"
    $suppliers = "OU=Supplier,OU=Cevt users,OU=CEVT,$path"
    $Partner = "OU=Partner,OU=Cevt users,OU=CEVT,$path"
 

# Geely Design Users:
    $GeelyDesign = "OU=Geely Design Users,OU=CEVT,$path"

 

# LynkCo Users: 
$LynkCo = "OU=Geely Sales Users,OU=CEVT,$path"

 

# Change here which OU's to search in:
#$OU= @($AllCEVT)
#$OU= @($suppliers,$Consultants,$Geelydesign,$LynkCo,$partner,$CEVTEmployees)
#endregion OUS

$OUs= @($suppliers,$Consultants,$partner,$CEVTEmployees) 

$users = @()


 foreach($ou in $ous){
 $users += get-aduser -SearchBase $OU -Filter {enabled -ne $false } -Properties * | where samaccountname -NotLike 'z*'  } 
 

    foreach ($user in $users){
#region props
        $props=@(
            @{Name='Samaccountname';Expression={($user.Samaccountname)}},
            @{Name='Type';Expression={($user.extensionAttribute1)}},
            @{Name='CostCenter';Expression={($user.extensionAttribute3)}},
            @{Name='Cpu_SF';Expression={($user.extensionAttribute4)}},     
            @{Name='Orphan CostCenter';Expression={($user.extensionAttribute13)}},
            @{Name="OU (auto.geely.com\CEVT\)";E={(Split-Path $User.CanonicalName).Replace("auto.geely.com\CEVT\","")}},
            @{Name="MemberOfCCDyn"; Expression={($user.MemberOf | where { $_ -like "CN=CEVT-CCDyn*" }).split(',')[0].TrimStart("CN=CEVT-CCDyn-")}},
            @{Name="CCdyndesc";expression={(($user.MemberOf | where { $_ -like "CN=CEVT-CCDyn*" }) | get-adgroup -Properties Description | select Description).Description}},
            #@{Name="MemberOfCCDynLynkCo"; Expression={ ($_.memberof | 
            #foreach { ($_ | where { $_ -like "CN=LynkCo-CCDyn*" }) }).split(',')[0].TrimStart("CN=LynkCo-CCDyn-") }},
            @{name="Mail";expression={($user.mail)}},
            @{Name='Manager';Expression={($user.Manager).split(',')[0].TrimStart("CN=")}},
            @{Name='ManagerEnabled';Expression={(get-aduser $user.Manager -Properties enabled).enabled}},
            @{Name='Created';Expression={($user.created)}},
            @{Name='Company';Expression={($user.company)}}
          )
#endregion props
 

 $user   |  select $props 
    }  
 }
 
 $OutFile = "c:\temp\Users_$date.csv"
Get-PropsInfo | export-Csv $OutFile -notypeinfo -encoding Unicode -Delimiter ";" -Append

 

Invoke-Item $Outfile