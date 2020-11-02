# Export och Import CSV av Användare

                $Date = Get-date -Format "yyMMdd-(HH.mm)"
                
                $ExportPath = "C:\Temp\UsersExport-$date.csv"
            
                   
                    if (Test-Path $ExportPath) {
                    Remove-Item $ExportPath
                    }
                    
                $Users = import-csv -Path C:\temp\1.csv -Delimiter ";" 

                        foreach ($User in $Users){

                        Get-AdUser $user.samaccountname -Properties * | 
                                            select samaccountname,mail,
                                            Company, 
@{L="OU (auto.geely.com\CEVT\)";E={(Split-Path $_.CanonicalName).Replace("auto.geely.com\CEVT\","")}} |
                                           

                                            export-csv -Path $ExportPath -Delimiter ";" -NoTypeInformation -Append

                                                 } # End Foreach

                                                 ii $ExportPath