Configuration PowerSTIG_WindowsServer
{
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $OsVersion,

        [Parameter(Mandatory = $true)]
        [string]
        $OsRole,

        [Parameter()]
        [version]
        $StigVersion,

        [Parameter()]
        [string]
        $ForestName,

        [Parameter()]
        [string]
        $DomainName,

        [Parameter()]
        [hashtable]
        $Exception,

        [Parameter()]
        [string]
        $OrgSettings,

        [Parameter()]
        [string[]]
        $SkipRule
    )

    Import-DSCResource -Module PowerSTIG

    if ( $null -eq $OrgSettings )
    {
        if ( ($null -eq $SkipRule) -and ($null -eq $Exception) )
        {
            WindowsServer BaseLine
            {
                OsVersion   = $OSVersion
                OsRole      = $OSRole
                StigVersion = $StigVersion
                DomainName  = $DomainName
                Forestname  = $Forestname
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $Exception)
        {
            WindowsServer BaseLine
            {
                OsVersion   = $OSVersion
                OsRole      = $OSRole
                StigVersion = $StigVersion
                DomainName  = $DomainName
                Forestname  = $Forestname
                SkipRule    = $SkipRule
            }
        }
        elseif ($null -eq $skiprul -and $null -ne $Exception) {
            WindowsServer BaseLine
            {
                OsVersion   = $OSVersion
                OsRole      = $OSRole
                StigVersion = $StigVersion
                DomainName  = $DomainName
                Forestname  = $Forestname
                Exception   = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            WindowsServer Baseline
            {
                OsVersion   = $OSVersion
                OsRole      = $OSRole
                StigVersion = $StigVersion
                DomainName  = $DomainName
                Forestname  = $Forestname
                Exception   = $Exception
                SkipRule    = $SkipRule
            }
        }
    }
    else
    {
        if ( ($null -eq $SkipRule) -and ($null -eq $Exception) )
        {
            WindowsServer BaseLine
            {
                OsVersion   = $OSVersion
                OsRole      = $OSRole
                StigVersion = $StigVersion
                DomainName  = $DomainName
                Forestname  = $Forestname
                OrgSettings = $OrgSettings
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $exception)
        {
            WindowsServer BaseLine
            {
                OsVersion   = $OSVersion
                OsRole      = $OSRole
                StigVersion = $StigVersion
                DomainName  = $DomainName
                Forestname  = $Forestname
                OrgSettings = $OrgSettings
                SkipRule    = $SkipRule
            }
        }
        elseif ( $null -eq $skiprule -and $null -ne $Exception ) {
            WindowsServer BaseLine
            {
                OsVersion   = $OSVersion
                OsRole      = $OSRole
                StigVersion = $StigVersion
                DomainName  = $DomainName
                Forestname  = $Forestname
                OrgSettings = $OrgSettings
                Exception   = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            WindowsServer Baseline
            {
                OsVersion   = $OSVersion
                OsRole      = $OSRole
                StigVersion = $StigVersion
                DomainName  = $DomainName
                Forestname  = $Forestname
                OrgSettings = $OrgSettings
                Exception   = $Exception
                SkipRule    = $SkipRule
            }
        }
    }

    foreach($rule in $SkipRule.Keys)
    {
        Registry Exception_Rule
        {
            Ensure = "Present"
            Key = "HKEY_LOCAL_MACHINE\SOFTWARE\STIGExceptions\"
            ValueName = $rule
            ValueData = $(Get-Date -format "MMddyyyy")
            ValueType = "String"
            Force = $true
        }
    }
}