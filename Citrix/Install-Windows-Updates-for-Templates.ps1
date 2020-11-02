<#  
 .SYNOPSIS  
  Script to update Template's Windows Updates
    
 .DESCRIPTION
  I use this script to convert my template to a VM, start the VM,
  apply any Windows Update, shutdown the VM, and convert it back
  to a template.
  
#>
#add-pssnapin VMware.VimAutomation.Core

Connect-VIServer se-got-vcenter1.cevt.se

#Show Progress
$showProgress = $true


#Update Template Parameters

	#Update Template Name
	$updateTempName = "W10-FCATEST-AUTO"

	#Update Template Local Account to Run Script
	$updateTempUser = "auto\dev.fredrik.carlsson"
	$updateTempPass = ConvertTo-SecureString 'KLou87!!"jfhryui!!' -AsPlainText -Force


#Log Parameters and Write Log Function
$logRoot = "C:\Scripts\Install Windows Updates for Templates\logs"

$log = New-Object -TypeName "System.Text.StringBuilder" "";

function writeLog {
	$exist = Test-Path $logRoot\update-$updateTempName.log
	$logFile = New-Object System.IO.StreamWriter("$logRoot\update-$($updateTempName).log", $exist)
	$logFile.write($log)
	$logFile.close()
}

[void]$log.appendline((("[Start Batch - ")+(get-date)+("]")))
[void]$log.appendline($error)

#---------------------
#Update Template
#---------------------

try {
	#Get Template
	$template = Get-Template $updateTempName

	#Convert Template to VM
	if($showProgress) { Write-Progress -Activity "Update Template" -Status "Converting Template: $($updateTempName) to VM" -PercentComplete 5 }
	[void]$log.appendline("Converting Template: $($updateTempName) to VM")
	$template | Set-Template -ToVM -Confirm:$false

	#Start VM
	if($showProgress) { Write-Progress -Activity "Update Template" -Status "Starting VM: $($updateTempName)" -PercentComplete 20 }
	[void]$log.appendline("Starting VM: $($updateTempName)")
	Get-VM $updateTempName | Start-VM -RunAsync:$RunAsync

	#Wait for VMware Tools to start
	if($showProgress) { Write-Progress -Activity "Update Template" -Status "Giving VM: $($updateTempName) 30 seconds to start VMwareTools" -PercentComplete 35 }
	[void]$log.appendline("Giving VM: $($updateTempName) 30 seconds to start VMwareTools")
	sleep 30

	#VM Local Account Credentials for Script
	$cred = New-Object System.Management.Automation.PSCredential $updateTempUser, $updateTempPass

	#Script to run on VM
	$script = "Function WSUSUpdate {
		  param ( [switch]`$rebootIfNecessary,
				  [switch]`$forceReboot)  
		`$Criteria = ""IsInstalled=0 and Type='Software'""
		`$Searcher = New-Object -ComObject Microsoft.Update.Searcher
		try {
			`$SearchResult = `$Searcher.Search(`$Criteria).Updates
			if (`$SearchResult.Count -eq 0) {
				Write-Output ""There are no applicable updates.""
				exit
			} 
			else {
				`$Session = New-Object -ComObject Microsoft.Update.Session
				`$Downloader = `$Session.CreateUpdateDownloader()
				`$Downloader.Updates = `$SearchResult
				`$Downloader.Download()
				`$Installer = New-Object -ComObject Microsoft.Update.Installer
				`$Installer.Updates = `$SearchResult
				`$Result = `$Installer.Install()
			}
		}
		catch {
			Write-Output ""There are no applicable updates.""
		}
		If(`$rebootIfNecessary.IsPresent) { If (`$Result.rebootRequired) { Restart-Computer -Force} }
		If(`$forceReboot.IsPresent) { Restart-Computer -Force }
	}
	WSUSUpdate -rebootIfNecessary
	"
	
	#Running Script on Guest VM
	if($showProgress) { Write-Progress -Activity "Update Template" -Status "Running Script on Guest VM: $($updateTempName)" -PercentComplete 50 }
	[void]$log.appendline("Running Script on Guest VM: $($updateTempName)")
	Get-VM $updateTempName | Invoke-VMScript -ScriptText $script -GuestCredential $cred
	
	#Wait for Windows Updates to finish after reboot
	if($showProgress) { Write-Progress -Activity "Update Template" -Status "Giving VM: $($updateTempName) 600 seconds to finish rebooting after Windows Update" -PercentComplete 65 }
	[void]$log.appendline("Giving VM: $($updateTempName) 600 seconds to finish rebooting after Windows Update")
	sleep 60

	#Shutdown the VM
	if($showProgress) { Write-Progress -Activity "Update Template" -Status "Shutting Down VM: $($updateTempName)" -PercentComplete 80 }
	[void]$log.appendline("Shutting Down VM: $($updateTempName)")
	Get-VM $updateTempName | Stop-VMGuest -Confirm:$false

	#Wait for shutdown to finish
	if($showProgress) { Write-Progress -Activity "Update Template" -Status "Giving VM: $($updateTempName) 30 seconds to finish Shutting Down" -PercentComplete 90 }
	[void]$log.appendline("Giving VM: $($updateTempName) 30 seconds to finish Shutting Down")
	sleep 30
	
	#Convert VM back to Template
	if($showProgress) { Write-Progress -Activity "Update Template" -Status "Convert VM: $($updateTempName) back to template" -PercentComplete 100 }
	[void]$log.appendline("Convert VM: $($updateTempName) back to template")
	Get-VM $updateTempName | Set-VM -ToTemplate -Confirm:$false
}
catch { 
	[void]$log.appendline("Error:")
	[void]$log.appendline($error)
	Throw $error
	#stops post-update copy of template
	$updateError = $true
	}
#---------------------
#End of Update Template
#---------------------
	



#Write Log
[void]$log.appendline((("[End Batch - ")+(get-date)+("]")))

writeLog