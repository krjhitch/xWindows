#Copy-Item -Path '.\' -Destination 'C:\Program Files\WindowsPowerShell\Modules' -Recurse
Import-Module .\xWindows.psd1 -Verbose
Get-DSCResource -Module xWindows
Get-Module -ListAvailable -FullyQualifiedName xWindows -Verbose