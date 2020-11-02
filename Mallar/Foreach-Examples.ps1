# Shows 3 different ways to use Foreach


*******************

get-process | select -Property name,@{n='Total';e={$_.vm + $_.pm}}

*******************

$procs = get-process 
foreach ($Proc in $procs)
{
    $total = $proc.pm + $proc.vm
    
    write-output "$($proc.name) $($total)"
}

*******************

get-process | ForEach-Object {
    Write-Output "$($_.name) $($_.vm + $_.pm)"
    }

    *******************
# Man kan även mäta hur lång tid de olika raderna tar

    *******************

measure-command { 
                get-process | 
                select -Property name,@{n='Total';e={$_.vm + $_.pm}}}

*******************

measure-command { 
                    $procs = get-process 
                    foreach ($Proc in $procs)
                    {
                        $total = $proc.pm + $proc.vm
    
                write-output "$($proc.name) $($total)"
            }
            }
*******************

measure-command { 
                get-process | ForEach-Object {
                Write-Output "$($_.name) $($_.vm + $_.pm)"
                }
                }
    