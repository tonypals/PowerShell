#Grab the text file
$textFile = Get-Content C:\temp\AllProgramsFromAllVDI.txt

#Loop through each line and assign everything produced in the
$result = foreach ($line in $textFile) {
    #Split the line into an array using space as a delimiter
    $array = $line -Split " "
    #Create a new object to return to $result and define the what each "column" would be assigned to
    New-Object -TypeName PSObject -Property @{ComputerName=$array[0];Owner=$array[1];Type=$array[2]}
}

#Export the object to a CSV
$result | Export-CSV C:\Temp\MyCSV.csv -NoTypeInformation

ii C:\Temp\MyCSV.csv