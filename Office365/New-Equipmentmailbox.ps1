Remove-Variable mail*,dele*,small*

$mailbox = Read-host "Type in new name for Equipmentmailbox: Ex "MASTERCAR_308_VEP4_7DCT"
$Delegate = Read-Host "Type the name of one Delegate for the mailbox: Ex "victor.prado"

# Create the mailbox as an Equipmentmailbox
New-Mailbox -Name $mailbox -Equipment

# Variable for mailaddress
$Address = $mailbox + "@cevt.se"

# Change mail to small letters

$SmallAddress = $Address.ToLower()

# Add mailaddress with small letters
Set-Mailbox $mailbox -EmailAddresses @{add="$SmallAddress"}

# Add Delegates and that all can book the equipment	
Set-CalendarProcessing $mailbox –ResourceDelegates $Delegate -AutomateProcessing autoaccept

# Set the primarySMTP and add Delegats as "send on behalf of"
Set-Mailbox -Identity $Mailbox -WindowsEmailAddress $SmallAddress -GrantSendOnBehalfTo $Delegate



# This line can be used to add more user as "Send on behalf of"	
#Set-Mailbox $mailbox -GrantSendOnBehalfTo @{add="magnus.hillerborn"}

# Show result

Get-Mailbox $mailbox | FL Name,RecipientTypeDetails,PrimarySmtpAddress,grant*

Get-CalendarProcessing $mailbox | fl  ResourceDelegates,booking*,autom*