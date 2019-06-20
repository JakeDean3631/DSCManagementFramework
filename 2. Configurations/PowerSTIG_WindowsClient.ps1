Configuration PowerSTIG_WindowsClient
{
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $OsVersion,

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
            WindowsClient BaseLine
            {
                OsVersion = [String]$OSVersion
                StigVersion = $StigVersion
                DomainName = $DomainName
                Forestname = $Forestname
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $Exception)
        {
            WindowsClient BaseLine
            {
                OsVersion = [String]$OSVersion
                StigVersion = $StigVersion
                DomainName = $DomainName
                ForestName = $ForestName
                SkipRule = $SkipRule
            }
        }
        elseif ($null -eq $skiprul -and $null -ne $Exception) {
            WindowsClient BaseLine
            {
                OsVersion = [String]$OSVersion
                StigVersion = $StigVersion
                DomainName = $DomainName
                ForestName = $ForestName
                Exception = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            WindowsClient Baseline
            {
                OsVersion   = [String]$OSVersion
                StigVersion = $StigVersion
                DomainName  = $DomainName
                ForestName  = $ForestName
                Exception   = $Exception
                SkipRule    = $SkipRule
            }
        }
    }
    else
    {
        if ( ($null -eq $SkipRule) -and ($null -eq $Exception) )
        {
            WindowsClient BaseLine
            {
                OsVersion = [String]$OSVersion
                StigVersion = $StigVersion
                DomainName = $DomainName
                Forestname = $Forestname
                OrgSettings = $OrgSettings
            }
        }

        elseif ($null -ne $SkipRule -and $null -eq $exception)
        {
            WindowsClient BaseLine
            {
                OsVersion = [String]$OSVersion
                StigVersion = $StigVersion
                DomainName = $DomainName
                ForestName = $ForestName
                OrgSettings = $OrgSettings
                SkipRule = $SkipRule
            }
        }
        elseif ( $null -eq $skiprule -and $null -ne $Exception ) {
            WindowsClient BaseLine
            {
                OsVersion = [String]$OSVersion
                StigVersion = $StigVersion
                DomainName = $DomainName
                ForestName = $ForestName
                OrgSettings = $OrgSettings
                Exception = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            WindowsClient Baseline
            {
                OsVersion = [String]$OSVersion
                StigVersion = $StigVersion
                DomainName = $DomainName
                ForestName = $ForestName
                OrgSettings = $OrgSettings
                Exception = $Exception
                SkipRule = $SkipRule
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