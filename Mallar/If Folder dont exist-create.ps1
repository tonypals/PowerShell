﻿$path = "C:\temp"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

