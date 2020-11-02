
$mailboxes = get-mailbox "mastercar*"

foreach ($Mailbox in $mailboxes)
{
    


#$mailbox = Read-host "Type in Equipment or Roomname: ex MASTERCAR_111_VEP4-7DCT"

Get-Mailbox $mailbox.Identity | FL Name,RecipientTypeDetails,PrimarySmtpAddress,grant*

Get-CalendarProcessing $mailbox.Identity | fl  ResourceDelegates,booking*,autom*

}