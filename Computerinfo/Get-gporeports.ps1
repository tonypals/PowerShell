import-module grouppolicy
# Get one GPO
Get-GPOReport -name <GPO-name> -ReportType HTML -Path c:\gporeport\<gpo-name>.html 

Get-GPOReport -All -Domain <domainname> -ReportType Html -Path c:\gporeport\GPO_Report_All.html