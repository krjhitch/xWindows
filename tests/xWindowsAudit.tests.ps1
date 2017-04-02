Set-Location 'C:\Windows\System32'

Get-Module -ListAvailable -FullyQualifiedName xWindows

configuration 'xWindowsAuditTests' {
    Import-DscResource -ModuleName xWindows
    node 'localhost' {
        xWindowsAudit 'Test1' { #Test setting both to true
            AuditSubCategory = 'IPsec Main Mode'
            Success          = $true
            Failure          = $true
        }

        xWindowsAudit 'Test2' { #Test setting both to false
            AuditSubCategory = 'Network Policy Server'
            Success = $false
            Failure = $false
        }

        xWindowsAudit 'Test3' { #Test setting one to true and one to false
            AuditSubCategory = 'File System'
            Success = $false
            Failure = $true
        }

        xWindowsAudit 'Test4' { #Test setting one value and not setting the other
            AuditSubCategory = 'Certification Services'
            Success = $true
        }

        xWindowsAudit 'Test5' { #Test setting one value and not setting the other
            AuditSubCategory = 'Sensitive Privilege Use'
            Failure = $true
        }
    }
}

xWindowsAuditTests
Start-DscConfiguration .\xWindowsAuditTests -Wait -Force -verbose -ErrorAction Stop