﻿Function ConvertTo-Char
(	
	$Array
)
{
	$Output = ""
	ForEach($char in $Array)
	{	$Output += [char]$char -join ""
	}
	return $Output
}

$Query = Get-WmiObject -Query "Select * FROM WMIMonitorID" -Namespace root\wmi

$Results = ForEach ($Monitor in $Query)
{    
	New-Object PSObject -Property @{
		ComputerName = $env:ComputerName
		Active = $Monitor.Active
		Manufacturer = ConvertTo-Char($Monitor.ManufacturerName)
		UserFriendlyName = ConvertTo-Char($Monitor.userfriendlyname)
		SerialNumber = ConvertTo-Char($Monitor.serialnumberid)
		WeekOfManufacture = $Monitor.WeekOfManufacture
		YearOfManufacture = $Monitor.WeekOfManufacture
	}
}

$Results | Select ComputerName,Active,Manufacturer,UserFriendlyName,SerialNumber,WeekOfManufacture,YearOfManufacture﻿