# xWindowsUserRights Example
```powershell
configuration 'UserPrivs' {
    Import-Module -Name xWindows

    node 'localhost' {
        xWindowsUserRights 'DebugRights' {
            Privilege = 'SeDebugPrivilege'
            Members   = 'Builtin\Administrators'
        }
    }
}
```

# xWindowsSecurityOptions Example

# xWindowsAudit Example