function Get-SecurityDatabase {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    Param()

    $datahash = @{}

    secedit.exe /export /cfg "$env:APPDATA\secpol.cfg" | Out-Null
    Get-Content -Path $env:APPDATA\secpol.cfg | ForEach-Object {
        if($_.StartsWith('['))
        {
            $section = $_
            $datahash.add($section, @())
        }
        else
        {
            [array]$newdata = $datahash.Get_Item($section)
            $newdata += $_
            $datahash.Set_Item($section, $newdata)
        }
    }
    Remove-Item -path $env:APPDATA\secpol.cfg | Out-Null

    return $datahash
}

function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("MinimumPasswordAge ","MaximumPasswordAge ","MinimumPasswordLength ","PasswordComplexity ","PasswordHistorySize ","LockoutBadCount ","RequireLogonToChangePassword ","ForceLogoffWhenHourExpire ","NewAdministratorName ","NewGuestName ","ClearTextPassword ","LSAAnonymousNameLookup ","EnableAdminAccount ","EnableGuestAccount ")]
        [System.String]
        $Option,

        [parameter(Mandatory = $true)]
        [System.String]
        $Value
    )

    $dbinfo = Get-SecurityDatabase

    @{
        Option = [System.String]$Option
        Value  = [System.String]($dbinfo.'[System Access]' -match "^$Option").split('=')[1].replace('"',"").trim()
    }
}

function Set-TargetResource {
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("MinimumPasswordAge ","MaximumPasswordAge ","MinimumPasswordLength ","PasswordComplexity ","PasswordHistorySize ","LockoutBadCount ","RequireLogonToChangePassword ","ForceLogoffWhenHourExpire ","NewAdministratorName ","NewGuestName ","ClearTextPassword ","LSAAnonymousNameLookup ","EnableAdminAccount ","EnableGuestAccount ")]
        [System.String]
        $Option,

        [parameter(Mandatory = $true)]
        [System.String]
        $Value
    )

    try {
        [int]$value | Out-Null
    } 
    catch {
        $Value = '"{0}"' -f $value
    }

    $dbinfo = Get-SecurityDatabase

    Write-Verbose "Was: $($dbinfo.'[System Access]' -match "^$Option")"
    
    $newvalues = $dbinfo.Get_Item("[System Access]") -replace "^$Option.*","$Option = $Value"
    $newdata.Set_Item("[System Access]", $newvalues)

    $newdata.Keys | ForEach-Object {
        Write-Output $_
        $items = $newdata.$_
        $items | % {
            Write-Output $_
        }
    } | Out-File $env:APPDATA\tempsecinf.inf -Force
    $tempDB = "$env:TEMP\tempSecedit.sdb"   
    secedit.exe /configure /db $env:TEMP\tempSecedit.sdb /cfg $env:APPDATA\tempsecinf.inf
    Remove-Item $env:APPDATA\tempsecinf.inf
    Remove-Item $env:Temp\tempSecedit.sdb

    Write-Verbose "Is: $Option = $Value"
}

function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateSet("MinimumPasswordAge ","MaximumPasswordAge ","MinimumPasswordLength ","PasswordComplexity ","PasswordHistorySize ","LockoutBadCount ","RequireLogonToChangePassword ","ForceLogoffWhenHourExpire ","NewAdministratorName ","NewGuestName ","ClearTextPassword ","LSAAnonymousNameLookup ","EnableAdminAccount ","EnableGuestAccount ")]
        [System.String]
        $Option,

        [parameter(Mandatory = $true)]
        [System.String]
        $Value
    )

    $currentValue = (Get-TargetResource @PSBoundParameters).Value
    
    if ($currentvalue -eq $Value) {
        return $true
    }
    return $false
}

Export-ModuleMember -Function *-TargetResource

