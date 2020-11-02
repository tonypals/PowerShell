# Test av att få ut Name i logfilen. Select name fungerar inte när man kör hela scriptet, bara rad för rad


# Detta funkar
 
Start-Transcript -Path c:\temp\test.txt 
 
         Get-ChildItem c:\temp -Recurse
 
Stop-Transcript

ii c:\temp\test.txt


       # Detta funkar INTE
       # Men att skriva detta rad för rad i kommandoraden funkar..
       # ELLER att trycka F8 för varje rad
 
        Start-Transcript -Path c:\temp\test.txt 
 
                 Get-ChildItem c:\temp -Recurse | select name
 
        Stop-Transcript

        ii c:\temp\test.txt




     