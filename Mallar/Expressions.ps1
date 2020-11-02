$user = "tony.palsson"

get-aduser $user -Properties * | select @{name="namn_fnamn";expression={(get-aduser $user -Properties GivenName).GivenName}},
@{name="namn_enamn";expression={(get-aduser $user -Properties SurName).surname}},
@{name="epost";expression={(get-aduser $user -Properties Mail).mail}},
@{name="tit";expression={(get-aduser $user -Properties Title).title}},
@{Name="org";Expression={"CEVT AB\" +(get-aduser $user -Properties Department).department}},
@{Name='chef';Expression={(Get-ADUser $_.Manager).sAMAccountName}},
@{name="roll_anknr";expression={(((get-aduser $user -Properties MobilePhone).MobilePhone).replace(' ','')).replace('^00','+')}},
@{name="roll_anknr2";expression={(((get-aduser $user -Properties telephonenumber).telephonenumber).replace(' ','')).replace('^00','+')}} 


(get-aduser $user -Properties Department).department