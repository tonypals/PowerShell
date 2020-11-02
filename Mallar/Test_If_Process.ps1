# get Firefox process

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
Clear-Host
$word = Get-Process | Where-Object {$_.Name -like "*word*"}
if ($word) {
  # try gracefully first
  $word.CloseMainWindow()
  # kill after five seconds
  start-Sleep 5
  if (!$word.HasExited) {
    $word | Stop-Process -Force -Verbose
    write-host "Word is stopped"

  }
}
Remove-Variable word