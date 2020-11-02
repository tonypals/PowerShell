# Detta scriptet kopierar filer från c:\temp till c:\temp\oldfiles
# Det sparar filer som är nyare än 10 dagar
# Mapparna FilesToKeep och OldFiles är Exkluderade

$fileDirectory = "c:\temp"
$Destination = "c:\temp\oldfiles"

$MoveDate = (Get-Date).Adddays(-20)
$excludelist = 'foldertokeep', 'oldfiles'

cd $fileDirectory


    Get-Childitem $fileDirectory | 
      where { $excludeList -notcontains $_ } |
  
  foreach {
                   $files = $_
                   foreach ($file in $files) 

                {#Kontrollerar hur gammal filen är
                 if ($file.LastWriteTime -lt $movedate)

                    {# Flyttar filerna
                      move-item $file $Destination    }
                }
           
          }
  # Visar innehållet i mappen dit filerna flyttats.
  gci C:\temp\OLDfiles















