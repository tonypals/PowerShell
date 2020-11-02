New-PSDrive –Name “s” –PSProvider FileSystem –Root “\\segot-s040\home$\users\sabina.goya” 
$path = "s:"

$dict = @{}

Get-ChildItem -Path $Path -Filter *.* -Recurse |
  ForEach-Object {
        $hash = ($_ | Get-FileHash -Algorithm MD5).Hash
        if ($dict.ContainsKey($hash))
        {
            [PSCustomObject]@{
                Original = $dict[$hash]
                OriginalDate = $dict.lastwriteTime
                Duplicate = $_.FullName
                DuplicateDate=$_.LastWriteTime
                }
        }
        else
        {
            $dict[$hash]=$_.FullName
        }
    } |
    export-csv -Path c:\temp\SabinaHash.csv -NoTypeInformation -Encoding Unicode -Delimiter ";" -Append

    ii c:\temp\sabinahash.csv