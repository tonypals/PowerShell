get-adgroupmember "G-CEVT-Apps-CANoe (64 bit)" | select samaccountname | out-file c:\temp\computers65.txt


  (Get-Content C:\temp\computers65.txt) |
        Foreach-Object {$_ -replace '"$"','' } | Set-Content C:\temp\out.txt

        

        $string = get-Content C:\temp\out.txt

        $stringtrim = $string.TrimEnd()

         $stringtrim | Set-Content C:\temp\out2.txt

         ii c:\temp\out2.txt 