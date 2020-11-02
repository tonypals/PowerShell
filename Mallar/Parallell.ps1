#Workflow definition
workflow Start-Scan
{
    Param
    (
        # Start IP
        [int]
        $startIP,

        # End IP
        [int]
        $endIP,

        #Network Info
        [string]
        $networkSegment
    )

    $sequence = $startIP..$endIP

    #limiting the parallel task to 8 at a time
    foreach -parallel -throttlelimit 8 ($item in $sequence)
    {
        
        if(Test-Connection "$networkSegment$item" -Count 1 -ErrorAction SilentlyContinue)
        {
            $pingResult = New-Object -TypeName PSObject -Property @{
                IP = "$networkSegment$item"
                Status = "ACTIVE"
            }
        }
        else
        {
            $pingResult = New-Object -TypeName PSObject -Property @{
                IP = "$networkSegment$item"
                Status = "INACTIVE"
            }
        }
        $pingResult
    }
}
#End of Workflow definition

#invoking the workflow
#To ping from 192.168.1.1 to 192.168.1.20

$result = Start-Scan 1 254 "10.31.120."
$result | Select IP, Status