$Path = "y:"   #define path to folders to find duplicate files
$Files=gci -File -Recurse -path $Path | Select-Object -property FullName,Length,lastwritetime
$Count=1
$TotalFiles=$Files.Count
$MatchedSourceFiles=@()
ForEach ($SourceFile in $Files)
{
  Write-Progress -Activity "Processing Files" -status "Processing File $Count / $TotalFiles" -PercentComplete ($Count / $TotalFiles * 100)
  $MatchingFiles=@()
  $MatchingFiles=$Files |Where-Object {$_.Length -eq $SourceFile.Length}
  Foreach ($TargetFile in $MatchingFiles)
  {
    if (($SourceFile.FullName -ne $TargetFile.FullName) -and !(($MatchedSourceFiles |
      Select-Object -ExpandProperty File) -contains $TargetFile.FullName))
    {
      Write-Verbose "Matching $($SourceFile.FullName) and $($TargetFile.FullName)"
      Write-Verbose "File sizes match."
      if ((fc.exe /A $SourceFile.FullName $TargetFile.FullName) -contains "FC: no differences encountered")
      {
        Write-Verbose "Match found."
        $MatchingFiles+=$TargetFile.FullName
      }
    }
  }
  if ($MatchingFiles.Count -gt 0)
  {
    $NewObject=[pscustomobject][ordered]@{
      File=$SourceFile.FullName
      FileDate = $SourceFile.LastWriteTime
      MatchingFiles=$TargetFile.fullname
      MatchingFilesDate=$TargetFile.lastwritetime
    }
    $MatchedSourceFiles+=$NewObject
  }
  $Count+=1
}
$MatchedSourceFiles   | export-csv -Path c:\temp\Sabina-H_kolon.csv -Delimiter ";" -NoTypeInformation -Encoding Unicode -Append
ii c:\temp\Sabina-H_kolon.csv