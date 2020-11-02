﻿    #This Script will find the System Info for local and remote computers.  
    # The output displays Computername,IPAddress,NetworkAdapter,MACAddress,DHCPServer,OS, ComputerModel,Username,Domain,Uptime, TotalMem, FreePhysicalMem, RegisteredUser,ServicePack,NoOfProcessors, ProcessorName,ProcessorType 
 
    #create an Empty Array 
    $array= @() 

     Import-Module (Join-Path $(Split-Path $env:SMS_ADMIN_UI_PATH)ConfigurationManager.psd1) 
    cd ps1:

    # Get all computers from an OU to file
    <#
    get-adcomputer -filter * -SearchBase  "OU=Laptops,OU=CEVT Computers,OU=CEVT,DC=auto,DC=geely,DC=com" | select samaccountname > c:\temp\open.txt


    (Get-Content c:\temp\open.txt).replace('$', '') | Set-Content c:\temp\open3.txt
    (Get-Content c:\temp\open3.txt).replace('samaccountname', '') | Set-Content c:\temp\open4.txt
    (Get-Content c:\temp\open4.txt).replace('--------------', '') | Set-Content c:\temp\open5.txt
    # Delete space in the end of each row
    $content = Get-Content c:\temp\open5.txt
    $content | Foreach {$_.TrimEnd()} | Set-Content c:\temp\open5.txt
    gc C:\temp\open5.txt | where {$_ -ne ""} > C:\temp\exportOpen.txt
    remove-item c:\temp\ope*.txt
    #>

    $computer=Get-Content C:\temp\exportOpen.txt
 

    foreach ($server in $computer) 
                                                                                                                                                                                                                                        { 
 
$IP=[System.net.dns]::GetHostEntry($server).AddressList | %{$_.IPAddressToString} 
 
$wmi=Get-WmiObject win32_ComputerSystem -ComputerName $server 
 
 
$obj=New-Object PSObject 
 
$obj |Add-Member -MemberType NoteProperty -Name "ComputerName" $wmi.Name 
$obj |Add-Member -MemberType NoteProperty -Name "ComputerModel" $wmi.Model 
$obj |Add-Member -MemberType NoteProperty -Name "Username" $wmi.UserName 
$obj |Add-Member -MemberType NoteProperty -Name "Domain" $wmi.domain 
$obj |Add-Member -MemberType NoteProperty -Name "IPAddress" $IP 
$obj |Add-Member -MemberType NoteProperty -Name "NoOfProcessors" $wmi.Numberofprocessors 
#$array +=$obj 
 
$wmi=Get-WmiObject win32_Processor -ComputerName $server 
 
$obj |Add-Member -MemberType NoteProperty -Name "ProcessorName" $wmi.Name 
$obj |Add-Member -MemberType NoteProperty -Name "ProcessorType" $wmi.Caption 
# $array +=$obj 
 
 
 
$wmi=Get-WmiObject win32_OperatingSystem -ComputerName $server 
 
$freeMB = [math]::Round(($wmi.FreePhysicalMemory / 1024) , 0) 
$totalMB = [math]::Round(($wmi.TotalVisibleMemorySize / 1024) , 0) 
 
$UDays = ((Get-Date) - ($wmi.ConvertToDateTime($wmi.LastBootUpTime))).Days 
$UHours = ((Get-Date) - ($wmi.ConvertToDateTime($wmi.LastBootUpTime))).Hours 
$UMins = ((Get-Date) - ($wmi.ConvertToDateTime($wmi.LastBootUpTime))).Minutes 
$Uptime = "Days " + $UDays + " Hours " + $UHours + " Minutes " + $UMins 
 
$obj |Add-Member -MemberType NoteProperty -Name "OS" $wmi.caption 
$obj |Add-Member -MemberType NoteProperty -Name "TotalMem" $totalMB 
 
# Finding the Network Adapter and MAC Address, DHCP Server 
 
$wmi=Get-WmiObject win32_networkadapterconfiguration -ComputerName $server | where {$_.Ipenabled -Match "True"} 
 
$obj |Add-Member -MemberType NoteProperty -Name "NetworkAdapter" $wmi.description 
$obj |Add-Member -MemberType NoteProperty -Name "MACAddress" $wmi.macaddress 

# Get info from SCCM-server

$CM = Get-CMDevice -Name $server

$obj |Add-Member -MemberType NoteProperty -Name "PrimaryUser" $cm.UserName
$obj |Add-Member -MemberType NoteProperty -Name "Lastactivetime" $cm.LastActiveTime

# Get Bios-Info
$Bios = Get-WmiObject win32_bios -ComputerName $server

$obj |Add-Member -MemberType NoteProperty -Name "BIOS-Version" $bios.smbiosbiosversion
$obj |Add-Member -MemberType NoteProperty -Name "Serialnumber" $bios.SerialNumber
#$obj |Add-Member -MemberType NoteProperty -Name "BIOS-Version" $bios.smbiosbiosversion

# Get OS-info
$os = Get-wmiobject -class win32_operatingsystem -ComputerName $server
$obj |Add-Member -MemberType NoteProperty -Name "InstallDate" $OS.ConvertToDateTime($OS.Installdate)
 
$array +=$obj 
    } 
 
 
    $array | 
    select Computername,IPAddress,NetworkAdapter,MACAddress,OS, ComputerModel,Username,TotalMem,PrimaryUser,Lastactivetime,Bios-Version,Serialnumber,Installdate # | Export-Csv c:\temp\systeminfo.csv 