#Set-ExecutionPolicy Unrestricted -Force

<#

Import-module Activedirectory

$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://segot-s108.auto.geely.com/PowerShell/ -Authentication Kerberos -Credential $UserCredential

Import-PSSession $Session

. 'C:\Program Files\Microsoft\Exchange Server\V14\bin\RemoteExchange.ps1'
Connect-ExchangeServer -auto

cd 'C:\Exchange Scripts'
#>



<# Index
Get-Userinfo
Get-UsersInfoLastCreated
Get-UserMissingField
New-Remotesession
Move-DisabledUser
Move-DisabledDesignUser
Get-Directreports
Move-NewComputer
Get-Computerinfo
Add-ElektraPC
Add-PPMrole
Create-Costcenters
New-RandomPassword
Connect-Exonline
#>

# GET ALL GROUPS AND PROPERTIES FOR A USER
# Example: Get-userinfo z1tony.palsson
# This shows properties and groups
# To Verify that the account is correct

Function Get-Userinfo{

    [CmdletBinding()]

param(
[string[]]$username
)

foreach ($name in $username) {
Get-ADuser $name -Properties * | 
Select DisplayName,Samaccountname,Company,Created,Mail,Mobilephone,extensionAttribute1,extensionAttribute3,extensionAttribute4,@{Name='Manager';Expression={(Get-ADUser $_.Manager).sAMAccountName}},Department,LastLogonDate,Enabled,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}}


Write-Host -ForegroundColor Green "All groups $name is member of"
Get-ADPrincipalGroupMembership -Identity $name | 
select Name 

}
}


# GET THE GROUP FOR NEW USERS
# Example: Get-UsersinfoLastCreated 10
# This shows all groups for the 10 last created users. To verify that new users are correctly created

Function Get-UsersInfoLastCreated{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String]$last
       
    )


Get-ADUser -Filter * -SearchBase "OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com"  |  
ForEach { get-aduser $_.samaccountname -Properties *} | sort created | select samaccountname,created -last $last |
Foreach { Get-ADUser $_.samaccountname -properties *}|

foreach {write-host "User:" $_.Name -foreground green 
Write-host "Created:" $_.created -foreground Green 

Get-ADPrincipalGroupMembership $_.SamAccountName | 
foreach {write-host "Member Of:" $_.name} 
Get-ADUser $_.samaccountname -Properties * |
Foreach { write-host "Mobilephone:" $_.Mobilephone}
Get-ADUser $_.samaccountname -Properties * |
Foreach { write-host "Office:" $_.Office}
Get-ADUser $_.samaccountname -Properties * |
Foreach { write-host "Manager:"$_.manager}
Get-ADUser $_.samaccountname -Properties * |
Foreach { write-host "Description:" $_.Description}
Get-ADUser $_.samaccountname -Properties * |
Foreach { write-host "Company:" $_.Company}
Get-ADUser $_.samaccountname -Properties * |
Foreach { write-host "*****************************************" $_.null}
}
}




# Function to sort out users with missing fields
# Example "Get-UserMissingField -last 10 -Missing mobilephone"

Function Get-UserMissingField{
[CmdletBinding()]
    param(
        
        [Parameter(Mandatory=$true)]
        [String]$last,
        [String]$Missing
        
       
    )

Get-ADUser -SearchBase "OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com"  -Filter {$Missing -notlike "*"} | 
ForEach { get-aduser $_.samaccountname -Properties *} | sort created | select samaccountname,created -last $last  |
ForEach { get-aduser $_.samaccountname -Properties *} | 
Select DisplayName,Samaccountname,City,Office,Homedirectory,Company,Mobilephone,Pager, Title,created,@{name="Manager";expression={($_.Manager -split ",OU=")[0]}},@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}},mail,Description,Department,AccountExpirationDate
}


# CONNECT TO A REMOTE SERVER
# Example: "New-RemoteSession -name segot-s108"

Function New-RemoteSession{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String]$Name
       
    )
    $cred = Get-Credential -Credential auto\z8tony.palsson
Enter-PSSession -ComputerName $name -Credential $cred

}

# DISABLE A USER
# The account is disabled, moved to disabled accounts and has a new Description
# EXAMPLE:   Move-disableduser -user tony.test -admin Johan 

Function Move-DisabledUser{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String]$User,
        [String]$Admin

    )

$Date = Get-Date -Format d 
$Description = "Disabled $date //$Admin"


# Change the Description 

    Set-ADUser $User -Description $Description 

# Move users to Disabled Accounts OU"

    get-aduser $user | move-adobject -TargetPath "OU=Disabled accounts,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com"    

# Disable accounts

  Disable-ADAccount -Identity $User

  

# Show Summary
    get-aduser -Identity $User -Properties * | select distinguishedname,samaccountname,description,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}},enabled |ft      
}

# DISABLE A DESIGN USER
# The account is disabled, moved to disabled accounts and has a new Description
# EXAMPLE:   Move-DisabledDesignUser -user tony.test -admin Johan 

Function Move-DisabledDesignUser{

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [String]$User,
        [String]$Admin

    )

$Date = Get-Date -Format d 
$Description = "Disabled $date //$Admin"


# Change the Description 

    Set-ADUser $User -Description $Description 

# Move users to Disabled Accounts OU"

    get-aduser $user | move-adobject -TargetPath "OU=!Disabled Accounts,OU=CEVT,OU=GeelyStaff,DC=auto,DC=geely,DC=com"    

# Disable accounts

  Disable-ADAccount -Identity $User

  

# Show Summary
    get-aduser -Identity $User -Properties * | select distinguishedname,samaccountname,description,@{name="OU";expression={($_.DistinguishedName -split ",OU=")[1]}},enabled |ft      
}




# MOVE NEW COMPUTERS TO CORRECT OU AND GROUPS
# Example: "Move-NewComputer -computer segot-l40811"

Function Move-NewComputer{

    [CmdletBinding()]
    param(
       [Parameter(Mandatory=$true)]




[string]$Computer,
$Group1 = "G-CEVT-Apps-Baseapps",
$Group2 = "CEVT-PC-Laptops",
$Group3 = "G-CEVT-Apps-CAD-WS"
)


If ($Computer -like "Segot-l*") {
    Clear-Host
   
    
get-adcomputer -Identity $Computer | Move-ADObject -TargetPath 'OU=Laptops,OU=Cevt Computers,OU=CEVT,DC=auto,DC=geely,DC=com'


# To Correct Groups

Add-ADGroupMember -Identity $Group1 -Members (Get-ADComputer -Identity $Computer)
Add-ADGroupMember -Identity $Group2 -Members (Get-ADComputer -Identity $Computer)


# Get Result

get-adcomputer -Identity $computer -Properties * | select dist*
Get-ADComputer $Computer -Properties memberof | select -Expand memberof
Write-Output *********
    Write-Output "This is a Laptop"
 Write-Output ********
    
}


 
Else {
    get-adcomputer -Identity $Computer | Move-ADObject -TargetPath 'OU=workstations,OU=Cevt Computers,OU=CEVT,DC=auto,DC=geely,DC=com'


# To Correct Groups

Add-ADGroupMember -Identity $Group1 -Members (Get-ADComputer -Identity $Computer)
Add-ADGroupMember -Identity $Group3 -Members (Get-ADComputer -Identity $Computer)


# Get Result

get-adcomputer -Identity $computer -Properties * | select dist*
Get-ADComputer $Computer -Properties memberof | select -Expand memberof
Write-Output *********
    Write-Output "This is a workstation"
 Write-Output ********
}

}

# This script shows:
# Lastloggedon User with LastactiveTime
# Current Screen resolution on all screens connected
# Total RAM, 
# Model and Manufacturer
# Computername
# Number of cores
# IPaddress



Function Get-Computerinfo{

    [CmdletBinding()]
    param(
        #[Parameter(Mandatory=$false)]
        [String[]]$Computername
       
    )

Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH)ConfigurationManager.psd1) 
cd ps1:

$Computername = read-host -prompt "Please enter the machine name: "  
$Prim =Get-CMUserDeviceAffinity -DeviceName $Computername  | select uniqueusername
write-host "The Primary User/Users are:" $prim.uniqueusername


$nam = Get-CMDevice -Name "$Computername" | select username
write-host "The username in SCCM is" $nam.username -ForegroundColor Green

Write-host ""

# Shows Name and number of Cores

$colItems = get-wmiobject -class "Win32_Processor" -namespace "root\CIMV2" -computername $Computername
foreach ($objItem in $colItems){
write-host "System Name: " $objItem.SystemName
Write-host "Number of Cores " $objItem.NumberOfCores
}

#Shows Screen resolution

$colItems = get-wmiobject -class "Win32_ComputerSystem" -namespace "root\CIMV2" -computername $Computername
$Res = Get-WmiObject -Class Win32_DesktopMonitor -ComputerName $Computername | Select-Object ScreenWidth,ScreenHeight
$serial = Get-WmiObject win32_bios -ComputerName $Computername| select Serialnumber
$Biosversion =Get-WmiObject win32_bios -ComputerName $Computername| select SMBIOSBIOSVersion


$OS = Get-WmiObject -Class Win32_OperatingSystem -Computer $Computername
$InstalledDate = $OS.ConvertToDateTime($OS.Installdate)
Write-host "Datorn är installerad "$InstalledDate.DateTime



foreach ($Screen in $res){
Write-host "Screen Resolution" $Screen | select ScreenWidth,ScreenHeight 
}

# Shows RAM

foreach ($objItem in $colItems){
$displayGB = [math]::round($objItem.TotalPhysicalMemory/1024/1024/1024, 0)
write-host "Total Physical Memory: " $displayGB "GB"
write-host "Model:                 "$objItem.Model
Write-host "Manufacturer:          "$objItem.Manufacturer


}

# Shows Serialnumber

Foreach ($Number in $serial){
Write-host $Number 
Write-host $Biosversion
}

# Shows DiskSpace

Get-WmiObject Win32_logicaldisk -ComputerName $Computername  `
        | Format-Table DeviceID, MediaType, `
        @{Name="Size(GB)";Expression={[decimal]("{0:N0}" -f($_.size/1gb))}}, `
        @{Name="Free Space(GB)";Expression={[decimal]("{0:N0}" -f($_.freespace/1gb))}}, `
        @{Name="Free (%)";Expression={"{0,6:P0}" -f(($_.freespace/1gb) / ($_.size/1gb))}} `
        -AutoSize

# Shows IP and Macaddress

$strComputer =$Computername
$colItems = Get-WmiObject -Class "Win32_NetworkAdapterConfiguration" -ComputerName $strComputer -Filter "IpEnabled = TRUE"
ForEach ($objItem in $colItems)
{
    write-host "IP Address: " $objItem.IpAddress[0]  "Mac: " $objItem.MacAddress
}
}

Write-Verbose "Script succeded running"





Function Add-ElektraPC{


# Add a PC to the Application group for Elektra
# Example: add-elektraPC SEGOT-L51514


    [CmdletBinding()]
    param(
        #[Parameter(Mandatory=$false)]
        [String]$PCname
       
    )

    # Add the PC to the Group
Add-ADGroupMember -Identity G-CEVT-Apps-Elektra (get-adcomputer -identity $PCName)

# Get result
Get-ADPrincipalGroupMembership (Get-ADComputer $PCName).DistinguishedName | select name


}




<# Tony Pålsson 2016-11-30
.Synopsis
   Add correct Accessgroups and licenses for PPM-users
.DESCRIPTION
   The user can have one of 3 roles. Teammember, Systemengineer/UPL or PortfolioViewer.
   A Teammember gets the lowest license form: Essentials
   The other roles gets Professional license.
   The script removes the other licenses from other roles.
.EXAMPLE
   Type Add-PPMrole, press enter. 
   Type in the samaccountname ex z1tony.palsson and choose one of the roles.
   It takes 15 sec to show the result.
.EXAMPLE
   Another example of how to use this cmdlet
#>



Function Add-PPMRole{
#g
    [CmdletBinding()]
    param(
       
       
    )


[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
$PPMUser = [Microsoft.VisualBasic.Interaction]::InputBox("Enter the Username, Firstname.Lastname", "Username")

$log =  "c:\temp\PPM_users.log"
$date = get-date -format d
Remove-Variable user*
$Title = "Add Role"
$Info = "              Choose correct Role for the User"
 
$options = [System.Management.Automation.Host.ChoiceDescription[]] @("&TeamMember", "&SystemEngineer", "&PortfolioViewer")
[int]$defaultchoice = 1
$opt =  $host.UI.PromptForChoice($Title , $Info , $Options,$defaultchoice)

switch($opt)
{
# Add Teammember access and deletes the other Roles
0 { Add-ADGroupMember -Identity CEVT-Office365-ProjectOnline-Access-TeamMember -Members $PPMUser 
    Add-ADGroupMember -Identity  CEVT-Office365-ProjectEssentials-License -Members $PPMUser

    Remove-ADGroupMember -Identity CEVT-Office365-ProjectOnline-Access-PortfolioViewer -Members $PPMUser -Confirm:$false
    Remove-ADGroupMember -Identity CEVT-Office365-ProjectPro-License -Members $PPMUser -Confirm:$false
    Remove-ADGroupMember -Identity CEVT-Office365-ProjectOnline-Access-SystemEngineerUPL -Members $PPMUser -Confirm:$false
    write-host "Pause 10sec" -ForegroundColor Green
        #Start-Sleep 10

# Result to logfile "c:\temp\PPM_users.log"
    $date + " " + $PPMUser | Out-File $log -append
    Get-ADPrincipalGroupMembership -Identity $PPMUser  | where {($_.name -like “cevt-office365-project*”)} | select name | Out-File $log -append 
    
# Show result on screen
    $PPMUser 
    Get-ADPrincipalGroupMembership -Identity $PPMUser  | where {($_.name -like “cevt-office365-project*”)} | select name 
}

# Add Systemengineer access and deletes the other Roles
1 { 
    Add-ADGroupMember -Identity CEVT-Office365-ProjectOnline-Access-SystemEngineerUPL -Members $PPMUser
    Add-ADGroupMember -Identity  CEVT-Office365-ProjectPro-License -Members $PPMUser

    Remove-ADGroupMember -Identity CEVT-Office365-Projectessentials-License -Members $PPMUser -Confirm:$false
    Remove-ADGroupMember -Identity CEVT-Office365-ProjectOnline-Access-TeamMember -Members $PPMUser -Confirm:$false
    Remove-ADGroupMember -Identity CEVT-Office365-ProjectOnline-Access-PortfolioViewer -Members $PPMUser -Confirm:$false
    write-host "Pause 10sec" -ForegroundColor Green
        #Start-Sleep 10

# Result to logfile "c:\temp\PPM_users.log"
    $date + " " + $PPMUser | Out-File $log -append
    Get-ADPrincipalGroupMembership -Identity $PPMUser  | where {($_.name -like “cevt-office365-project*”)} | select name | Out-File $log -append 
# Show result on screen    
        $PPMUser 
        Get-ADPrincipalGroupMembership -Identity $PPMUser  | where {($_.name -like “cevt-office365-project*”)} | select name 
}

# Add PortfolioViewer access and deletes the other Roles
2 {
    Add-ADGroupMember -Identity CEVT-Office365-ProjectOnline-Access-PortfolioViewer -Members $PPMUser
    Add-ADGroupMember -Identity  CEVT-Office365-ProjectPro-License -Members $PPMUser

    Remove-ADGroupMember -Identity CEVT-Office365-Projectessentials-License -Members $PPMUser -Confirm:$false
    Remove-ADGroupMember -Identity CEVT-Office365-ProjectOnline-Access-TeamMember -Members $PPMUser -Confirm:$false
    Remove-ADGroupMember -Identity CEVT-Office365-ProjectOnline-Access-SystemEngineerUPL -Members $PPMUser -Confirm:$false
    write-host "Pause 10" -ForegroundColor Green
        #Start-Sleep 10

# Result to logfile "c:\temp\PPM_users.log"
    $date + " " + $PPMUser | Out-File $log -append
    Get-ADPrincipalGroupMembership -Identity $PPMUser  | where {($_.name -like “cevt-office365-project*”)} | select name | Out-File $log -append 
# Show result on screen   
    $PPMUser 
    Get-ADPrincipalGroupMembership -Identity $PPMUser  | where {($_.name -like “cevt-office365-project*”)} | select name 
    

}
}
}

Function Create-CostcentersCEVT{

    [CmdletBinding()]
    param(
       
       
    )


    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
    $Group = [Microsoft.VisualBasic.Interaction]::InputBox("Type the CostcenterName `nEx. Design_Visualization `nNO Spaces in the name", "Costcenter-name")
    $Number = [Microsoft.VisualBasic.Interaction]::InputBox("Type the CostCenternumber `nEx: 91160", "CostCenter Number")
    $Unit = [Microsoft.VisualBasic.Interaction]::InputBox("Type the UnitName `nEx: Design Operations", "Unit Name")
    $Manager = [Microsoft.VisualBasic.Interaction]::InputBox("Type the name of the Manager `nEx: ulf.danertz", "The managers samaccountname")

    $ConsultantGroupName = "CEVT-Dept-$Group-Consultants"
    $EmployeeGroupName = "CEVT-Dept-$Group-Employees"
    $VCCGroupName = "CEVT-Dept-$Group-VCC"
    $Description = "$Number Department / Unit $unit $Manager"
    $info = "Additions and removal from this group should be approved by the group manager ( Managed By ), request is sent to servicedesk@cevt.se"



    New-ADGroup -GroupCategory:"Security" -GroupScope:"Universal" -Name $ConsultantGroupName -Path:"OU=Consultants,OU=Unit-dept Groups,OU=CEVT Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Description $Description 
    New-ADGroup -GroupCategory:"Security" -GroupScope:"Universal" -Name $employeeGroupName -Path:"OU=Employees,OU=Unit-dept Groups,OU=CEVT Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Description $Description
    New-ADGroup -GroupCategory:"Security" -GroupScope:"Universal" -Name $VCCGroupName -Path:"OU=VCC,OU=Unit-dept Groups,OU=CEVT Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Description $Description

    Set-ADGroup $consultantgroupname -ManagedBy $manager -replace @{info="$info"}
    Set-ADGroup $EmployeeGroupName -ManagedBy $manager -replace @{info="$info"}
    Set-ADGroup $VCCGroupName -ManagedBy $manager -replace @{info="$info"}

    $employeegroupname
    $description

    Add-ADGroupMember -Identity $EmployeeGroupName -Members $Manager
    Write-host "This Manager is added to the EmployeeGroup: $EmployeeGroupName"
    get-ADGroupMember -Identity $EmployeeGroupName | select Name

    
    Write-host -ForegroundColor green "The Manager $manager is added to $EmployeeGroupName and set as "Manage by" for all 3 groups created" 
    Write-host -ForegroundColor Green "Don't forget to add the new DEPT groups to the Unit groups ""$Unit"""
    write-host ""
    Write-host -ForegroundColor Green "Ex. CEVT-Dept-Direct Material-Employees should belong to CEVT-Unit-Purchasing-Employees"
    }

#Set-ADGroup $sam -replace @{info="Additions and removal from this group should be approved by the group manager ( Managed By ), request is sent to servicedesk@cevt.se"}

<#
.SYNOPSIS
    Creates random password string of length 1 to 100.
.DESCRIPTION
    Creates random password with ability to choose what characters are in the string and the length, the symbols can be specificlly defined.
.EXAMPLE
    New-RandomPassword -Length 8 -Lowercase
    In this example, a random string that consists of 8 lowercase charcters will be returned.
.EXAMPLE
    New-RandomPassword -Length 8 -Lowercase -Uppercase -Numbers -Symbols
    In this example, a random string that consists of 8 lowercase, uppercase, alpha-numeric and symbols will be returned.
.LINK
    http://www.asciitable.com/
    https://gist.github.com/PowerShellSith
#>
function Load-NewrandomPassword 
{
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        # Length, Type uint32, Length of the random string to create.
        [Parameter(Mandatory=$true,
                   Position=0)]
        [ValidatePattern('[0-9]+')]
        [ValidateRange(1,100)]
        [uint32]
        $Length,

        # Lowercase, Type switch, Use lowercase characters.
        [Parameter(Mandatory=$false)]
        [switch]
        $Lowercase=$false,
        
        # Uppercase, Type switch, Use uppercase characters.
        [Parameter(Mandatory=$false)]
        [switch]
        $Uppercase=$false,

        # Numbers, Type switch, Use alphanumeric characters.
        [Parameter(Mandatory=$false)]
        [switch]
        $Numbers=$false,

        # Symbols, Type switch, Use symbol characters.
        [Parameter(Mandatory=$false)]
        [switch]$Symbols=$false
        )
    Begin
    {
        if (-not($Lowercase -or $Uppercase -or $Numbers -or $Symbols)) 
        {
            throw "You must specify one of: -Lowercase -Uppercase -Numbers -Symbols"
        }

        # Specifies bitmap values for character sets selected.
        $CHARSET_LOWER=1
        $CHARSET_UPPER=2
        $CHARSET_NUMBER=4
        $CHARSET_SYMBOL=8

        # Creates character arrays for the different character classes, based on ASCII character values.
        $charsLower=97..122 | %{ [Char] $_ }
        $charsUpper=65..90 | %{ [Char] $_ }
        $charsNumber=48..57 | %{ [Char] $_ }
        $charsSymbol=35,36,40,41,42,44,45,46,47,58,59,63,64,92,95 | %{ [Char] $_ }
    }
    Process
    {
        # Contains the array of characters to use.
        $charList=@()
        # Contains bitmap of the character sets selected.
        $charSets=0
        if ($Lowercase) 
        {
            $charList+=$charsLower
            $charSets=$charSets -bor $CHARSET_LOWER
        }
        if ($Uppercase) 
        {
            $charList+=$charsUpper
            $charSets=$charSets -bor $CHARSET_UPPER
        }
        if ($Numbers) 
        {
            $charList+=$charsNumber
            $charSets=$charSets -bor $CHARSET_NUMBER
        }
        if ($Symbols) 
        {
            $charList+=$charsSymbol
            $charSets=$charSets -bor $CHARSET_SYMBOL
        }

        <#
        .SYNOPSIS
            Test string for existence for specified character.
        .DESCRIPTION
            examins each character of a string to determine if it contains a specificed characters
        .EXAMPLE
            Test-StringContents i string
        #>
        function Test-StringContents([String] $test, [Char[]] $chars) 
        {
            foreach ($char in $test.ToCharArray()) 
            {
                if ($chars -ccontains $char) 
                {
                    return $true 
                }
            }
            return $false
        }

        do 
        {
            # No character classes matched yet.
            $flags=0
            $output=""
            # Create output string containing random characters.
            1..$Length | % { $output+=$charList[(get-random -maximum $charList.Length)] }

            # Check if character classes match.
            if ($Lowercase) 
            {
                if (Test-StringContents $output $charsLower) 
                {
                    $flags=$flags -bor $CHARSET_LOWER
                }
            }
            if ($Uppercase) 
            {
                if (Test-StringContents $output $charsUpper) 
                {
                    $flags=$flags -bor $CHARSET_UPPER
                }
            }
            if ($Numbers) 
            {
                if (Test-StringContents $output $charsNumber) 
                {
                    $flags=$flags -bor $CHARSET_NUMBER
                }
            }
            if ($Symbols) 
            {
                if (Test-StringContents $output $charsSymbol) 
                {
                    $flags=$flags -bor $CHARSET_SYMBOL
                }
            }
        }
        until ($flags -eq $charSets)
    }
    End
    {   
    	$output | out-file c:\temp\password.txt -Append
    invoke-item C:\temp\password.txt
    
    }
}

function new-Nandompassword
# This loads the Function
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        
    )

   Load-newrandomPassword -symbols -Uppercase -Lowercase -Length 8 -Numbers
}


Function connect-Exonline {
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell `  -Credential z8tony.palsson@cevt.se `  -Authentication Basic -AllowRedirection


Import-PSSession $Session
}

#get-command -Module tmp_ap4mhok0.aw0


Function Create-CostcentersDesign{

    [CmdletBinding()]
    param(
       
       
    )


    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
    $Group = [Microsoft.VisualBasic.Interaction]::InputBox("Type the CostcenterName `nEx. Design_Visualization `nNO Spaces in the name", "Costcenter-name")
    $Number = [Microsoft.VisualBasic.Interaction]::InputBox("Type the CostCenternumber `nEx: 91160", "CostCenter Number")
    #$Unit = [Microsoft.VisualBasic.Interaction]::InputBox("Type the UnitName `nEx: Design Operations", "Unit Name")
    $Manager = [Microsoft.VisualBasic.Interaction]::InputBox("Type the name of the Manager `nEx: ulf.danertz", "The managers samaccountname")

    $ConsultantGroupName = "GD-Dept-$Group-Consultants"
    $EmployeeGroupName = "GD-Dept-$Group-Employees"
    
    $DescEmp = "$Number Department Employees / Unit Design $Manager"
    $DescCons = "$Number Department Consultants / Unit Design $Manager"
    $info = "Additions and removal from this group should be approved by the group manager ( Managed By ), request is sent to servicedesk@GD.se"



    New-ADGroup -GroupCategory:"Security" -GroupScope:"Universal" -Name $ConsultantGroupName -Path:"OU=Consultants,OU=Unit-Dept Groups,OU=GD Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Description $DescCons
    New-ADGroup -GroupCategory:"Security" -GroupScope:"Universal" -Name $employeeGroupName -Path:"OU=Employees,OU=Unit-Dept Groups,OU=GD Groups,OU=CEVT,DC=auto,DC=geely,DC=com" -Description $DescEmp
    

    Set-ADGroup $consultantgroupname -ManagedBy $manager -replace @{info="$info"}
    Set-ADGroup $EmployeeGroupName -ManagedBy $manager -replace @{info="$info"}
    

    $employeegroupname
    $description

    Add-ADGroupMember -Identity $EmployeeGroupName -Members $Manager
    Write-host "This Manager is added to the EmployeeGroup: $EmployeeGroupName"
    get-ADGroupMember -Identity $EmployeeGroupName | select Name

    
    Write-host -ForegroundColor green "The Manager $manager is added to $EmployeeGroupName and set as "Manage by" for the 2 groups created" 
    Write-host -ForegroundColor Green "Don't forget to add the new DEPT groups to the Unit groups "$Unit"
    write-host ""
    Write-host -ForegroundColor Green "Ex. GD-Dept-Direct Material-Employees should belong to GD-Unit-Purchasing-Employees""
    }

