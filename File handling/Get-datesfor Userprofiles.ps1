

$array= @()

$Path = "C:\Users"
$UserFolders = $Path | GCI -Directory

ForEach ($UserFolder in $UserFolders)
{

$UserName = $UserFolder.Name
$NtuserDatDate = (Get-Item "$Path\$UserName\NTUSer.dat" -force).LastWriteTime 
$PathDate = (Get-item $Path\$UserName -Force).lastwritetime


   
  
                    
                     $Result = New-Object -TypeName PSObject -Property @{            
                    "Username" = $UserName
                    "NTUserDatDate" = $NtuserDatDate
                    "Pathdate" = $pathdate
                    }
                    $Result  
    
   
   

    
}