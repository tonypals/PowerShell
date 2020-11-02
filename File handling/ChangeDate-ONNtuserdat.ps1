#the ability for GPO to delete profiles based on date and USMT migrations based on date.

$ErrorActionPreference = "SilentlyContinue"
$Report = $Null
$Path = "C:\Users"
$UserFolders = $Path | Get-ChildItem -Directory

ForEach ($UserFolder in $UserFolders)
{
$UserName = $UserFolder.Name
If (Test-Path "$Path\$UserName\NTUSer.dat")
    {
    $Dat = Get-Item "$Path\$UserName\NTUSer.dat" -force
    #$DatTime = $Dat.LastWriteTime
    If ($UserFolder.Name -ne "default"){
       # $Dat.LastWriteTime = $UserFolder.LastWriteTime
    }
    Write-Host $UserName $DatTime
    Write-Host (Get-item $Path\$UserName -Force).LastWriteTime
    $Report = $Report + "$UserName`t$DatTime`r`n"
    $Dat = $Null
    }
}


********************************************************************************
försöker få ut en lista som jämför modifydate på foldern med ntuser.dat datum

#the ability for GPO to delete profiles based on date and USMT migrations based on date.

$ErrorActionPreference = "SilentlyContinue"
$Report = $Null
$Path = "C:\Users"
$UserFolders = $Path | Get-ChildItem -Directory

ForEach ($UserFolder in $UserFolders)
{
$UserName = $UserFolder.Name

   $NtuserDatDate = (Get-Item "$Path\$UserName\NTUSer.dat" -force).LastWriteTime
   $PathDate = (Get-item $Path\$UserName -Force).lastwritetime
   
    #Write-Host "$UserName NTuser.dat-Date: $NtuserDatDate"
    #Write-Host "Pathdate: $pathdate"
    $Report = $Report + "$UserName`t NTuserdate: $NtuserDatDate`r`n,Pathdate: $pathdate`r`n"
    $report 
    $report | export-csv -Path c:\temp\ntuser.csv -Encoding Unicode -Delimiter ";" -NoTypeInformation -Append

    Invoke-Item c:\temp\ntuser.csv
   
    $Dat = $Null

    
}