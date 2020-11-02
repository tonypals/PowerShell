#Rensa hårddisken
#Hämta håddiskutrymme innan. Efter, Visar hur mycket som har rensats (på varje ställe)


#Steg 1
#Hämta storleken på alla områden som potentiellt kan rensas.
#Presentera totala storleken, samt uppspesad storlek.
    
    #Temp mappar
    #Stänga av hibernate
    #Windows uppdateringar
    #papperskorgen
    #temporära internet filer.
    #miniatyrer
    #SCCM cachen
    
    #visa storleken på offline filer
    #Visa storleken på B:
    #Visa storleken på iPhone backup
    
    #räkna storleken på varje på profil, visa när de senast har används.
        #Visa storleken på innehållet i vare profil. OST fil, hämtade filer, Skrivbord...
        #temp mappar
    #kolla användarens mina dokument
    
#Steg 2
#Rensa alla ställen som går alltid går att rensa.
#Rensa alla ställen som är frivilliga

#Steg 3
#Presentera hur mycket utrymme som frigjorts. Totala storleken, samt uppspesad storlek. Ledigt utrymme innan och efter. Potensiell kvarstående rensningspotentioal.




##Todo
<#
Räkna storleken på offline files.
Dela upp papperkorgen per användare

#>




#Minadokument
#Hämta län och lägg in rätt sökväg oberoende län.
<#
foreach ($user in $users)
{
    get-childitem "\\lansstyrelsen.se\it\home\$user\My Documents" -Recurse  | Measure-Object -Property length -sum | select -ExpandProperty sum
}
#>


$ErrorActionPreference = "silentlycontinue"

function LST-Get-DiskUsage
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $pc
    )

    Begin
    {
    }
    Process
    {
        Set-Location c:\
        #Temp
        $PC = "gotlt25792"
        #Skapar en tom array för data
        $datauser = @()
        $datacomputer = @()
        foreach ($dator in $PC)
        {
            try
            {
                Test-Connection $dator -count 2 -ErrorAction stop | out-null
                Write-Host "$dator är online" -ForegroundColor green
            
                #Hämtar alla användarnamn på datorn.
                $users = get-childitem "\\$dator\c$\users" -Exclude Public, p*, da*, *old | select -ExpandProperty name
                #Hämtar saker som inte används på 30 dagar från cachen
                $OldCache = (get-wmiobject -ComputerName $dator -query "SELECT * FROM CacheInfoEx" -namespace "ROOT\ccm\SoftMgmtAgent" | Where-Object { ([datetime](Date) - ([System.Management.ManagementDateTimeConverter]::ToDateTime($_.LastReferenced))).Days -gt 30  }).location;

                #fyller dator arrayen med data
                $computerarray = [ordered]@{
                    computer = $dator
                    temp = get-childitem "\\$dator\c$\windows\temp" | Measure-Object -Property length -sum | select -ExpandProperty sum
                    hibernate = get-childitem "\\$dator\c$\" -Force | where {$_.name -eq "hiberfil.sys"} | select -ExpandProperty Length
                    "windows update" = get-childitem "\\$dator\c$\Windows\SoftwareDistribution\Download" | Measure-Object -Property length -sum | select -ExpandProperty sum
                    "recycle bin" = get-childitem "\\$dator\c$\`$Recycle.Bin" -force -Recurse | %{$_.Length} | Measure-Object -sum | select -ExpandProperty sum
                    "sccm cache" =  if ($OldCache)
                    {
                        $OldCache = $OldCache.replace("C:\", "\\$dator\c$\")
                        $oldcache | %{ gci -Path $_ -Recurse -Force } | Measure-Object -Property length -sum | select -ExpandProperty sum
                    };
                    "B disken" = Get-ChildItem "\\$dator\c$\localdisk" -Recurse -Force | Measure-Object -Property length -sum | select -ExpandProperty sum
                    #get-childitem "\\$dator\c$\windows\ccmcache" -Recurse  | Measure-Object -Property length -sum | select -ExpandProperty sum
                    }
                    $datacomputer += New-Object -TypeName psobject -Property $computerarray
                    
                foreach ($user in $users)
                {
                    $userarray = [ordered]@{
                    computer = $dator
                    user = $user
                    tempSize = (get-childitem "\\$dator\c$\Users\$user\AppData\Local\Temp" -Recurse -Force | Measure-Object -Property length -sum | select -ExpandProperty sum)
                    thumbnails = (get-childitem "\\$dator\c$\Users\$user\AppData\Local\Microsoft\Windows\Explorer" -Recurse -Force | where {$_.name -like "*.db"}  | Measure-Object -Property length -sum | select -ExpandProperty sum)
                    "iPhone backup" = (get-childitem "\\$dator\c$\Users\$user\AppData\Roaming\Apple Computer\MobileSync\Backup" -Recurse -Force -ea SilentlyContinue | Measure-Object -Property length -sum | select -ExpandProperty sum)
                    "ost files" = (get-childitem "\\$dator\c$\Users\$user\AppData\Local\Microsoft\Outlook" -Force -ea SilentlyContinue | where { $_.name -like "*.ost"} | Measure-Object  -Property length -sum | select -ExpandProperty sum) 
                    "count ost-files" = (get-childitem "\\$dator\c$\Users\$user\AppData\Local\Microsoft\Outlook" -Force -ea SilentlyContinue | where {$_.name -like "*.ost"}).count
                    desktop = (get-childitem "\\$dator\c$\Users\$user\Desktop" -Recurse -Force | Measure-Object -Property length -sum | select -ExpandProperty sum)
                    download = (get-childitem "\\$dator\c$\Users\$user\Downloads" -Recurse -Force | Measure-Object -Property length -sum | select -ExpandProperty sum)
                    #"last accessed" = ""

                    #Profile = get-childitem "\\$dator\c$\Users\$user" -Recurse -Force | Measure-Object -Property length -sum | select -ExpandProperty sum
                    }
                    $datauser += New-Object -TypeName psobject -Property $userarray
                }
            }    
            catch
            {
                write-host "$dator är inte online" -ForegroundColor Red
            }
        }
        $datacomputer | ft -AutoSize
        $datauser | ft -AutoSize


        #temp internet files
        #get-childitem "\\$pc\Users\880823-003\AppData\Local\Temporary Internet Files\content.ie5" -Force
        #C:\Users\880823-003\AppData\Local\Temporary Internet Files\content.ie5
        #$users = get-childitem "\\$pc\c$\users" -Exclude Public | select -ExpandProperty name
    }
    End
    {
    }
}

#Presentera
$datacomputer | ft -AutoSize
$datauser | ft -AutoSize





foreach ($comp in $datacomputer)
{
    write-host "dator" $comp.computer "kan rensa totalt"
    foreach ($item in ($comp | Get-Member | where {$_.membertype -eq "noteproperty" -and $_.name -ne "computer"}))
    {
        #$item.Name
        #$comp.($item | select -ExpandProperty name)
        $summa += $comp.($item | select -ExpandProperty name)
        #$summa
    }
    write-host ($summa/1gb).ToString().substring(0,4) "gb"
    ($comp.temp + $comp.hibernate + $comp.'windows update' + $comp.'recycle bin' + $comp.'sccm cache' + $comp.'B disken')
    Clear-Variable summa
    write-host `n
}


[int]$test = [math]::Round($mattem /1gb,2)
$datauser | ft -AutoSize
foreach ($anv in $datauser)
{
    write-host "dator" $anv.computer "kan rensa totalt" $anv.user
    foreach ($item in ($anv | Get-Member | where {$_.membertype -eq "noteproperty" -and $_.name -ne "computer" -and $_.name -ne "user"  -and $_.name -ne "count ost-files"}))
    {
        $item.Name
        [math]::Round($anv.($item | select -ExpandProperty name),2)
        [int]$summa += [int]$anv.($item | select -ExpandProperty name)
        write-host ([int]$anv.($item | select -ExpandProperty name)) "mb"
    }
    write-host ($summa/1gb).ToString() "gb"
    #($anv.tempsize + $anv.thumbnails + $anv.'iphone backup' + $anv.'ost files' + $anv.'desktop' + $anv.'download')/1gb
    Clear-Variable summa
    write-host `n
}

##Rensa SCCM Cachen
function lst-RensaCCM ($PC)
{
            #get CCMCache path
            $Cachepath = ([wmi]"\\$pc\ROOT\ccm\SoftMgmtAgent:CacheConfig.ConfigKey='Cache'").Location
            
            #Get comps not referenced for more than 30 days
            $OldCache = get-wmiobject -ComputerName $pc -query "SELECT * FROM CacheInfoEx" -namespace "ROOT\ccm\SoftMgmtAgent" | Where-Object { ([datetime](Date) - ([System.Management.ManagementDateTimeConverter]::ToDateTime($_.LastReferenced))).Days -gt 30  }
            if ($OldCache)
            {
                $OldCache = ($OldCache.location).replace("C:\", "\\$pc\c$\")
                $oldcache | %{ gci -Path $_ -Recurse -Force } | Measure-Object -Property length -sum | select -ExpandProperty sum
            }

            
            #delete comps on Disk
            $OldCache | % { Remove-comp -Path $_.Location -Recurse -Force -ea SilentlyContinue }
            #delete comps on WMI
            $OldCache | Remove-WmiObject
            
            #Get all cached comps from Disk
            $CacheFoldersDisk = (get-childitem $Cachepath).FullName
            #Get all cached comps from WMI
            $CacheFoldersWMI = get-wmiobject -query "SELECT * FROM CacheInfoEx" -namespace "ROOT\ccm\SoftMgmtAgent"
            
            #Remove orphaned Folders from Disk
            $CacheFoldersDisk | % { if($_ -notin $CacheFoldersWMI.Location) { remove-comp -path $_ -recurse -force -ea SilentlyContinue} }
            
            #Remove orphaned WMI Objects
            $CacheFoldersWMI| % { if($_.Location -notin $CacheFoldersDisk) { $_ | Remove-WmiObject }}
       
            
            
       write-host $pc "har rensat cachen"
}