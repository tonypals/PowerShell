[cmdletbinding()]

param (
    [string[]]$computername
    )

Foreach ($computer in $computername) {
    try {
        $session = New-CimSession -computername $computer -erroraction stop
        $os = Get-CimInstance -ClassName win32_operatingsystem -CimSession $session
        $cs = Get-CimInstance -ClassName win32_operatingsystem -CimSession $session

        $Properties = @{Computername = $computer
                        status = 'Connected'
                        spversion= $os.servicepackmajorversion
                        osversion= $os.version
                        Model = $cs.model
                        mfgr = $cs.manufacturer}
          
       }
       catch {
            Write-Verbose " Couldn't connect to $computer"  
            $Properties = @{Computername = $computer
                            status = 'Disconnected'
                            spversion= $null
                            osversion= $null
                            mfgr = $null}  
       } 
       Finally {
                $obj = New-Object -TypeName psobject -Property $Properties
                    Write-Output $obj
                }
      }
                       
       
       
       
                   