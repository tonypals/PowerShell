# Få ut vem som äger en dator med namn

$ErrorActionPreference = "silentlycontinue"

# Skapar katalogen C:\Temp ifall den inte finns

    $TARGETDIR = "c:\temp"
    if(!(Test-Path -Path $TARGETDIR )){
        New-Item -ItemType directory -Path $TARGETDIR
                                      }

$Date = Get-date -Format d

<#
    Här kan man ändra så man väljer datorer med ett visst namn. 
    $input = Read-host "Fyll i del av datornamn, Ex Got, Srv, lt"
    $myVar = "*$input*"
    $Computers = Get-adcomputer -Filter {samaccountname -like $myvar} | select samaccountname
#>


   $input = "lt"
   $myVar = "*$input*"
   $Computers = Get-adcomputer -Filter {samaccountname -like $myvar} | select samaccountname



$newlist = @()
    foreach ($Computer in $Computers)
    {
        If($computer.samaccountname -match "ime")
        {
            $newlist +=  $($computer.samaccountname).Substring(0,$($computer.samaccountname).Length-3)
        }
        else
        {
          $newlist += $computer.samaccountname
        }
    
    }

# Skapa Varibeln Test som tar ut alla datorer i Newlist som bara har ett värde.

            $test = ($newlist | group |where {$_.Count -EQ 1}).Name 

# Ta ut information från varje dator som bara har ett värde i AD oc inte är i Outofband-OU.t

                    foreach ($computer2 in $test){
                    
                                                    get-adcomputer $computer2  -Properties *  | 
                                                    select Samaccountname,Description,Operatingsystemversion,Enabled,Lastlogondate,@{Name='Managedby';Expression={(Get-ADUser $_.managedby -Properties * | select displayname).displayname}},@{name="OU";expression={($_.DistinguishedName -split ",OU=")[3]}} |
                                                    export-csv -NoTypeInformation -path c:\temp\$input-ComputersUtanVpro__$date.csv -Delimiter ";" -append -Encoding Unicode

                                                    }

# Öppna den nyskapade CSV-filen döpt med dagens datum

 ii c:\temp\$Input-ComputersUtanVpro__$date.csv 



