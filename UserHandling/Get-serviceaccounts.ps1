﻿Get-WmiObject win32_service | select name, startname,startmode | sort startname 