Copy-Item -Path '.' -Destination 'C:\Program Files\WindowsPowerShell\Modules\xWindows' -Recurse -Verbose
#Import-Module .\xWindows -Verbose
$env:PSModulePath = 'C:\Program Files\WindowsPowerShell\Modules\'
Get-DSCResource -Module xWindows
Get-Module -ListAvailable -FullyQualifiedName xWindows -Verbose

dir 'C:\Program Files\WindowsPowerShell\Modules'
dir 'C:\Program Files\WindowsPowerShell\Modules\xWindows'

Write-Host 'PSModulePaths'
$env:PSModulePath -split ';'