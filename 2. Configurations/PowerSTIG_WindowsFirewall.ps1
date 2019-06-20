Configuration PowerSTIG_WindowsFirewall
{
    param(
        [Parameter()]
        [version]
        $StigVersion,

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
            WindowsFirewall BaseLine
            {
                StigVersion = $StigVersion
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $Exception)
        {
            WindowsFirewall BaseLine
            {
                StigVersion = $StigVersion
                SkipRule    = $SkipRule
            }
        }
        elseif ($null -eq $skiprul -and $null -ne $Exception) {
            WindowsFirewall BaseLine
            {
                StigVersion = $StigVersion
                Exception   = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            WindowsFirewall Baseline
            {
                StigVersion = $StigVersion
                Exception   = $Exception
                SkipRule    = $SkipRule
            }
        }
    }
    else
    {
        if ( ($null -eq $SkipRule) -and ($null -eq $Exception) )
        {
            WindowsFirewall BaseLine
            {
                StigVersion = $StigVersion
                OrgSettings = $OrgSettings
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $exception)
        {
            WindowsFirewall BaseLine
            {
                StigVersion = $StigVersion
                OrgSettings = $OrgSettings
                SkipRule    = $SkipRule
            }
        }
        elseif ( $null -eq $skiprule -and $null -ne $Exception ) {
            WindowsFirewall BaseLine
            {
                StigVersion = $StigVersion
                OrgSettings = $OrgSettings
                Exception   = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            WindowsFirewall Baseline
            {
                StigVersion = $StigVersion
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