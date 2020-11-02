 cls
 $name = Read-host "Skriv in datornamn, Tex vaslt37819"



Enter-PSSession -Credential p700613-001 -ComputerName $name
 
 Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Control\Class -Recurse -ErrorAction silentlyContinue | Get-ItemProperty | 
                ForEach-Object {if  ($_.RoamingPreferredBandType -ge 0 -and $_.driverDesc -notlike "*WAN*") { 
                $path = $_.pspath 
               
                $roam = get-itemproperty $path | select roamingpreferredbandtype
                
                
               
                                                                         }
                                }
                                $x = $roam.RoamingPreferredBandType
                                if ($x -eq 2)
                                {
                                    cls
                                
                                 Write-host ""
                                 Write-host "RoamingPreferredBandType är satt till: 5Ghz för dator $env:computername" -ForegroundColor Green
                                 Write-host ""

                                }
                              
                                else
                                 {
                                  cls
                                
                                 Write-host ""
                                 Write-host "RoamingPreferredBandType är INTE satt till 5Ghz för dator $env:computername" -ForegroundColor Red
                                 Write-host ""

                              $svar = Read-host "Vill du ändra till 5 Ghz? Skriv 1 och tryck enter"                                
                              if ($Svar -eq 1)
                              {<#
.SYNOPSIS
  Backup of Registryvalue and change Wifi-card to 5,2 Ghz

.DESCRIPTION
  Creates a New Registryvalue, if not existing. Then copies the Value from RoamingPreferredBandType from the active WIFI-Networkcard.
  Then sets the Value for RoamingPreferredBandType to "2", which is the value for 5.2 Ghz

.PARAMETER <Parameter_Name>
  <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS
  <Inputs if any, otherwise state None>

.OUTPUTS
  <Outputs if any, otherwise state None>

.NOTES
  Version:        1.0
  Author:         Tony Pålsson
  Creation Date:  2018-06-12
  Purpose/Change: Initial script development

.EXAMPLE
 Set-Preferred
  
  <Example goes here. Repeat this attribute for more than one example>
#>
<#
           #Requires -RunAsAdministrator

           # Value "0" is Autosetting
           # Value "1" is 2,4 Ghz                                                                           
           # Value "2" is 5,2 Ghz
#>
#---------------------------------------------------------[Script Parameters]------------------------------------------------------

#Param (
  #Script parameters go here
  #	[parameter(Mandatory=$true)]
  # [string]$string1,
  # [parameter(Mandatory=$true)]
  # [string]$string2,
  # [switch]$switch
#)

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = 'SilentlyContinue'

#Import Modules & Snap-ins

#----------------------------------------------------------[Declarations]----------------------------------------------------------

# Creates new folders if not existing

$TARGETDIR = "hklm:\software\WinCli"
$TARGETDIR1 = "hklm:\software\WinCli\WLAN"
$TARGETDIR2 = "hklm:\software\WinCli\WLAN\OLDRoamingPreferredBandType"


#-----------------------------------------------------------[Functions]------------------------------------------------------------


Function Set-Preferred {
  Param ()

  Begin {
    Write-Host 'Sets the PreferredBandType to 5.2'
  }

  Process {
    Try {

if( (Test-Path -Path $TARGETDIR2 ) )
{ cls
   hostname 
   

}


if( -Not (Test-Path -Path $TARGETDIR ) )
{
    New-Item -ItemType directory -Path $TARGETDIR
}


if( -Not (Test-Path -Path $TARGETDIR1 ) )
{
    New-Item -ItemType directory -Path $TARGETDIR1
}


if( -Not (Test-Path -Path $TARGETDIR2 ) )
{
    New-Item -ItemType directory -Path $TARGETDIR2
}


# Gets the Value from the setting and copies it to the new destination.
# Changes the RoamingPreferredBandType to "2".

                Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Control\Class -Recurse -ErrorAction silentlyContinue | Get-ItemProperty | 
                ForEach-Object {if  ($_.RoamingPreferredBandType -ge 0 -and $_.driverDesc -notlike "*WAN*") { 
                write-host  "Detta är sökvägen för registervärdet för det trådlösa nätverkskortet:"
                $path
                Write-host ""
                $path = $_.pspath 
                Copy-ItemProperty -Path $path -Destination $targetdir2 -name RoamingPreferredBandType                                                                        
                Set-ItemProperty $path -name "RoamingPreferredBandType" -Value "2"                                                          
                                                                         }
                                }

    }

                                                Catch {
                                                  Write-Host -BackgroundColor Red "Error: $($_.Exception)"
                                                  Break
                                                      }
  }

  End {
   
      Write-Host 'Script kört med lyckat resultat'
      Write-Host ' '
    
  }
}

#>

#-----------------------------------------------------------[Execution]------------------------------------------------------------


Set-Preferred






  # Check if Roaming är satt till 5Ghz. 2 är ok
  
  Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Control\Class -Recurse -ErrorAction silentlyContinue | Get-ItemProperty | 
                ForEach-Object {if  ($_.RoamingPreferredBandType -ge 0 -and $_.driverDesc -notlike "*WAN*") { 
                $path = $_.pspath 
               
                $roam = get-itemproperty $path | select roamingpreferredbandtype
                
                                                                     }
                                }
                               
                                $x = $roam.RoamingPreferredBandType
                                if ($x -eq 2)
                                {
                                    Write-host "RoamingPreferredBandType är satt till: $x" -ForegroundColor Green
                                }
                                else
                                {
                                    
                                }
                                 
  





                                  
                              }
                              else
                              {
                                  
                              }
                                
                                 
                                 }
  