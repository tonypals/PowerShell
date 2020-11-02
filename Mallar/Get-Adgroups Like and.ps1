Get-ADGroup -filter {Name -notLike '*dept*' -and Name -Like '*cae*' -and Name -like '*admin*'-and Name -notlike '*srv*'} -Properties * | select name



Get-ADGroup -filter {Name -notLike '*dept*' -and Name -Like '*ouadmin*' -and Name -notlike '*jira*'-and Name -notlike '*srv*'} -Properties * 