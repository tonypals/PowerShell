# This script is the template for a Function
# . Synopsis 
#  Shows all applications installed on one PC
# .Example Get-installedappsOnePC -computer 40

function Get-installedAppsOnePC
{
[cmdletbinding()]

param (
    [string[]]$computername
    )
    
    cls
            
           
            cls
            $computername
            Get-WmiObject -Namespace "root\cimv2" -Class Win32_product -ComputerName $computername | 
                select name | 
                sort name # | 
                

            $a =Get-WmiObject -Namespace "root\cimv2" -Class Win32_product -ComputerName $computername | 
                select Name 

            $antal = $a.Count
           write-host "Number of applications: $antal" 
            Pause}



    
 



