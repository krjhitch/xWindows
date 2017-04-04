Copy-Item -Path '.' -Destination 'C:\Program Files\WindowsPowerShell\Modules\xWindows' -Recurse -Verbose
#Import-Module .\xWindows -Verbose
Get-DSCResource -Module xWindows
Get-Module -ListAvailable -FullyQualifiedName xWindows -Verbose

dir 'C:\Program Files\WindowsPowerShell\Modules'
dir 'C:\Program Files\WindowsPowerShell\Modules\xWindows'

Write-Host 'PSModulePaths'
$env:PSModulePath -split ';'