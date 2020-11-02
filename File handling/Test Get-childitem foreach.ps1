$computers = 'testpc01','testpc02'
foreach($computer in $computers){
    Invoke-Command -ComputerName $computername -ScriptBlock {
        Get-ChildItem c:\users -Directory |
            foreach{
                Get-ChildItem "C:\users\$($_.name)" -Recurse | 
                # Create a new text file foreach user with OneDrive content
                Out-File "\\fileshare\$($_.name).txt"
            }
    }
}