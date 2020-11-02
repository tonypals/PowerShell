
 # This script is the template for a Function

function Trigger-Retrival
{
[cmdletbinding()]

param (
    [string[]]$computername
    )
    
    # Add the script that should be run here:

     $_action = "{00000000-0000-0000-0000-000000000021}"
$computer = "GOT500VI790"+$computername
Invoke-WmiMethod -ComputerName $Computer -Namespace root\CCM -Class SMS_Client -Name TriggerSchedule -ArgumentList "$_action"

    }




 
 
