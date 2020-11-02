

#$pass="uQ9YBy=4sT!!" | ConvertTo-SecureString -AsPlainText -Force


$PasswordAsString  | ConvertTo-SecureString -AsPlainText -Force

#$pass= ConvertTo-SecureString -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PsCredential('gridcore-archive',$PasswordAsString)
New-PSDrive -name r -Root \\ocap01.cevt.se\gridcore-archive$ -Credential $cred -PSProvider filesystem



#remove-psdrive r