# Site configuration
$SiteCode = "PS1" # Site code 
$ProviderMachineName = "SEGOT-S106.auto.geely.com" # SMS Provider machine name

# Customizations
$initParams = @{}
#$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
#$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

# Do not change anything below this line

# Import the ConfigurationManager.psd1 module 
if((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Connect to the site's drive if it is not already present
if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams

$AllComputers = Get-CMDevice -CollectionName 'All Workstation Clients (excl VDI)' | where {$_.DeviceOS -like "*Windows*"} | select Name
$ComputerGroup = 'G-CEVT-UserProfileCleanUp'
$CostCenters = '58571000'

$Array = @()

foreach($Comp in $AllComputers)
    {
        $Device = Get-CMUserDeviceAffinity -DeviceName $($comp.name)  | where {$_.sources -eq '4'}
        $Resource = $device.ResourceName
        $UserName = $Device.UniqueUserName |where {($Device.UniqueUserName -notlike "auto\z7*") -or ($Device.UniqueUserName -notlike "auto\z8*")}
        $Source = $Device.Sources
       
        if(($UserName).count -gt 1)
         {
         foreach($Mutiple in $UserName)
            {
                      $UserDevice = @()
                      $UserDevice = New-Object system.object
                      $UserDevice | Add-Member -Type NoteProperty -Value $Resource[0] -Name 'Device'
                      $UserDevice | Add-Member -Type NoteProperty -Value $Mutiple -Name 'UserName'
                      $UserDevice | Add-Member -Type NoteProperty -Value $Sources -Name 'Sources'
                      $Array += $UserDevice
            }    
         }else{
            $UserDevice = @()
            $UserDevice = New-Object system.object
            $UserDevice | Add-Member -Type NoteProperty -Value $Resource -Name 'Device'
            $UserDevice | Add-Member -Type NoteProperty -Value $UserName -Name 'UserName'
            $UserDevice | Add-Member -Type NoteProperty -Value $Sources -Name 'Sources'
            $Array += $UserDevice
        }
    }


foreach($user in $array)
    {
        $UserName = $User.UserName -replace '.*\\'
        try 
            {
                $computer = Get-ADComputer $user.device
                $GroupMembers = (Get-ADGroupMember $ComputerGroup).name
                $UserAttribute = Get-ADUser $UserName -Properties * | select Name,extensionAttribute3
                if($CostCenters.Contains($UserAttribute))
                    {
                        #write-host $User.Device $user.UserName
                        $UserName = $User.UserName -replace '.*\\'
                        Get-ADUser $UserName -Properties * | select Name,extensionAttribute3 
                       
                        #Add-ADGroupMember $ComputerGroup -Members $computer
                    }
                    elseif(!($CostCenters.Contains($UserAttribute)) -and ($GroupMembers -contains $computer.Name) )
                        {
                     
                             Remove-ADGroupMember $ComputerGroup -Members $computer -WhatIf
                             Write-Output "Computer: $Computer is not an member of the correct costcenter"
                            
                        
                        }
                   

            }
        catch 
            {
               # Write-host "Did not find $username"
            }   
    }

