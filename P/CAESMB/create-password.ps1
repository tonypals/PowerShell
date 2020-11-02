#==========================================================================
#
# CREATE SECURE PASSWORD FILES
#
# AUTHOR: Dennis Span (https://dennisspan.com)
# DATE  : 05.04.2017
#
# COMMENT:
# -This script generates a 256-bit AES key file and a password file
# -In order to use this PowerShell script, start it interactively (select this file
#  in Windows Explorer. With a right-mouse click select 'Run with PowerShell')
#
#==========================================================================
 
# Define variables

# Define variables
#$Path = "\\se-got-ctxfile1\ctxshare$\AciveDirectory\CAESMB"

$path = "\\segot-s040\cevt\Common\Tony\Passwords1005"

If (Test-Path P:)
  {write-host "Finns redan" -ForegroundColor Green}

else 

{net use p: $Path}


$Directory = "P:\"
$KeyFile = Join-Path $Directory  "AES_KEY_FILE.key"
$PasswordFile = Join-Path $Directory "AES_PASSWORD_FILE.txt"
 
# Text for the console
Write-Host "CREATE SECURE PASSWORD FILE"
Write-Host ""
Write-Host "Comments:"
Write-Host "This script creates a 256-bit AES key file and a password file"
Write-Host "containing the password you enter below."
Write-Host ""
Write-Host "Two files will be generated in the directory $($Directory):"
Write-Host "-$($KeyFile)"
Write-Host "-$($PasswordFile)"
Write-Host ""
Write-Host "Enter password and press ENTER:"
$Password = Read-Host -AsSecureString
 
Write-Host ""
 
# Create the AES key file
try {
 $Key = New-Object Byte[] 32
 [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
 $Key | out-file $KeyFile
        $KeyFileCreated = $True
 Write-Host "The key file $KeyFile was created successfully"
} catch {
 write-Host "An error occurred trying to create the key file $KeyFile (error: $($Error[0])"
}
 
Start-Sleep 2
 
# Add the plaintext password to the password file (and encrypt it based on the AES key file)
If ( $KeyFileCreated -eq $True ) {
 try {
 $Key = Get-Content $KeyFile
 $Password | ConvertFrom-SecureString -key $Key | Out-File $PasswordFile
 Write-Host "The key file $PasswordFile was created successfully"
 } catch {
 write-Host "An error occurred trying to create the password file $PasswordFile (error: $($Error[0])"
 }
}
 
Write-Host ""
write-Host "End of script (press any key to quit)"
 
#$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")