# Tester av Function som skapar en TXT eller en CSV



# Sökväg till filen som ska visa filerna i c:\temp

    $path = "c:\temp\test.txt"

# Skapa Function

    Function 
    Send-Tofile {out-file $path -Encoding unicode}

# Visa alla filer i C:\temp och skica till fil med parametrarna från Function

    Get-ChildItem C:\Temp | Send-Tofile

# Visa den skapade filen

    Get-ChildItem c:\temp\test.txt



# DETTA FUNKAR INTE


# Sökväg till filen som ska visa filerna i c:\temp

    $pathcsv = "c:\temp\test.csv"

# Skapa Function

Function 
    Send-Tocsv {export-csv -Path $pathcsv -Delimiter ";" -Encoding Unicode -NoTypeInformation}

# Visa alla filer i C:\temp och skica till fil med parametrarna från Function

    Get-ChildItem C:\Temp | Send-Tocsv

# Visa den skapade filen


    Get-ChildItem c:\temp\test.csv


<# Felet blir:

    cmdlet Export-Csv at command pipeline position 1
    Supply values for the following parameters:
    InputObject:
#>

function Verb-Noun {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        
    }
}