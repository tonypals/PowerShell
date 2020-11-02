Get-DhcpServerv4Scope -ComputerName "segot-devdc01" | 
Select ScopeId, Name, LeaseDuration | foreach { $pipe = $_ ; Get-DhcpServerv4Lease -ComputerName "SEGOT-S101" -ScopeId $_.ScopeId } | 
Select IPAddress, HostName, @{E={$_.ClientId -Replace "-",":"};L="MAC"}, LeaseExpiryTime, @{E={($pipe).LeaseDuration};L="LeaseDuration (D:HH:MM:SS)"}, @{Expression={($pipe).Name};Label="Description"} | 
OGV