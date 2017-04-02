Copy-Item -Path '.\' -Destination 'C:\Program Files\WindowsPowerShell\Modules' -Recurse
Import-Module xWindows -Verbose
Get-DSCResource -Module xWindows
