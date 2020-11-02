<#
(Get-Content C:\temp\X_$date.csv) | 
% {$_ -replace ‘domain users;‘, “”} | 
% {$_ -replace ‘CEVT-FineGrain‘, “”} | 
% {$_ -replace ‘G-cevt-users;‘, “”} | 
% {$_ -replace ‘G-CEVT-VPN-CERT;‘, “”} | 
% {$_ -replace ‘CEVT-Office365-EMS-License;‘, “”} | 
% {$_ -replace ‘CEVT-Office365-E3-SE-License;‘, “”} | 
% {$_ -replace ‘G-CEVT-SharePoint-Users;‘, “”} | 
% {$_ -replace ‘GD-GOT-Users;‘, “”} | 
% {$_ -replace ‘CEVT_GVG10;‘, “”} | 

out-file -FilePath C:\temp\ALL-Design_$Date.csv -Force -Encoding ascii
ii C:\temp\ALL-Design_$Date.csv

 
 #>

 
(Get-Content C:\temp\changeFrom.csv) | 
% {$_ -replace ‘,OU=Exchange Resources,OU=CEVT,DC=auto,DC=geely,DC=com‘, “”} | 
% {$_ -replace ‘CN=‘, “”} | 
% {$_ -replace ‘,OU=Supplier,OU=CEVT Users,OU=CEVT,DC=auto,DC=geely,DC=com‘, “”} | 
% {$_ -replace ‘OU=CEVT,DC=auto,DC=geely,DC=com‘, “”} | 
% {$_ -replace ‘CEVT-Office365-EMS-License;‘, “”} | 
% {$_ -replace ‘CEVT-Office365-E3-SE-License;‘, “”} | 
% {$_ -replace ‘G-CEVT-SharePoint-Users;‘, “”} | 
% {$_ -replace ‘GD-GOT-Users;‘, “”} | 
% {$_ -replace ‘CEVT_GVG10;‘, “”} | 

out-file -FilePath C:\temp\changeto.csv -Force -Encoding ascii
ii C:\temp\changeto.csv

 
 #>