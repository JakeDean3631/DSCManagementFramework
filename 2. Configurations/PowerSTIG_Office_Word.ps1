Configuration PowerSTIG_Office_Word
{
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $OfficeApp,

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

    Import-DscResource -ModuleName 'PowerStig'

    if ( $null -eq $OrgSettings )
    {
        if ( ($null -eq $SkipRule) -and ($null -eq $Exception) )
        {
            Office BaseLine
            {
                OfficeApp    = $OfficeApp
                StigVersion = $StigVersion
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $Exception)
        {
            Office BaseLine
            {
                OfficeApp   = $OfficeApp
                StigVersion = $StigVersion
                SkipRule    = $SkipRule
            }
        }
        elseif ($null -eq $skiprul -and $null -ne $Exception) {
            Office BaseLine
            {
                OfficeApp   = $OfficeApp
                StigVersion = $StigVersion
                Exception   = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            Office Baseline
            {
                OfficeApp   = $OfficeApp
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
            Office BaseLine
            {
                OfficeApp   = $OfficeApp
                StigVersion = $StigVersion
                OrgSettings = $OrgSettings
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $Exception)
        {
            Office BaseLine
            {
                OfficeApp   = $OfficeApp
                StigVersion = $StigVersion
                OrgSettings = $OrgSettings
                SkipRule    = $SkipRule
            }
        }
        elseif ( $null -eq $SkipRule -and $null -ne $Exception ) {
            Office BaseLine
            {
                OfficeApp   = $OfficeApp
                StigVersion = $StigVersion
                OrgSettings = $OrgSettings
                Exception   = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            Office Baseline
            {
                OfficeApp   = $OfficeApp
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
