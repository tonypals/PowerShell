$ping = New-Object System.Net.Networkinformation.Ping
100..125 | % { $ping.send(“172.31.201.$_”) | where status -Like success | select address, status } | ogv