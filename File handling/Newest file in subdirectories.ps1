# Find newest file of each subfolder
# http://sirsql.net/content/2011/07/07/201176grabbing-the-newest-file-from-subdirectories-using-powershel-html/

$Path = "c:\users" #Root path to look for files
 
#Grab a recursive list of all subfolders
$SubFolders = gci $Path -Recurse -Exclude *.js | Where-Object {$_.PSIsContainer}| ForEach-Object -Process {$_.FullName}
 
#Iterate through the list of subfolders and grab the first file in each
ForEach ($Folder in $SubFolders)
    {
    $FullFileName = dir $Folder | Where-Object {!$_.PSIsContainer} | Sort-Object {$_.LastWriteTime} -Descending | Select-Object -First 1 
    
    #For every file grab it's location and output the robocopy command ready for use
    ForEach ($File in $FullFileName)
        {
        $FilePath = $File.DirectoryName
        $FileName = $File.Name
        $FileLastWriteTime = $File.LastWriteTime
        echo "$FileLastWriteTime,$FilePath,$FileName"  #>> "NewestPSTEachDir_nnn.csv"
        }
    }