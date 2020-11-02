$Collection = get-content C:\temp\safet_TXT.txt

foreach ($item in $collection)
{
    $item.Substring(1) | out-file c:\temp\safet_efternamn.txt -Append
}
c:\temp\safet_efternamn.txt