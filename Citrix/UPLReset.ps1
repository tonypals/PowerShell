
# 2020-05-28 TonyPålsson
# This script deletes the folder with the name auto_username where Citrix UPL stores *VHD-files
# The user must have logged of, otherwise a popup comes up.
# If the user has logged of the folder and all subfolders will be deleted and a text is written to the logfile.
# If the script is ran and no folder exist this is also added to the Logfile.


$wshell = New-Object -ComObject Wscript.Shell
$answer = $wshell.Popup("Have you, properly, signed out from the VDI you are about to reset?",0,"Alert",0x4)

if($answer -eq 7){$wshell.Popup("Resetting canceled!")}

else {

    $fileToCheck = "\\se-got-ctxfile1\UPL\users\auto_$env:UserName"

if (Test-Path $fileToCheck)
{ 

try{
    Remove-Item $fileToCheck -Recurse -Force -ErrorAction stop    
    $message = "Deleted File auto_$env:UserName at "+(Get-Date)
    $message | Out-File -Append \\se-got-ctxfile1\UPL\users\Logs\Log.txt
    $wshell.Popup("Reset is completed. You can start the VDI again.")
   

    }

catch{
    $wshell.Popup("It seems like you just have disconnected the VDI. 
Please do a proper sign out! 
Use the Logoff VDI icon on the VDI Desktop")
      $message = "Tried to reset without proper logoff auto_$env:UserName at "+(Get-Date)
    $message | Out-File -Append \\se-got-ctxfile1\UPL\users\Logs\Log.txt
    #(Use the "Logoff VDI icon")
     }

}

else 
{   # If there is no file the user can login

    $wshell.Popup("Reset has already been executed. Login to create a fresh profile.")
    $message = "Failed to delete auto_$env:UserName at "+(Get-Date)
    $message | Out-File -Append \\se-got-ctxfile1\UPL\users\Logs\Log.txt
}

    }



    
 

