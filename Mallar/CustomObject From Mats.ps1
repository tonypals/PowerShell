$a = "A","B","C"

$c = ForEach ($b in $a) {
     [PSCustomObject]@{
        Aaa = $b
        Owner = "Test"
        Group = "Group $b"
    }#PSCustomObject
}#ForEach

$c 