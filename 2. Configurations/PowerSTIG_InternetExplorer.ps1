Configuration PowerSTIG_InternetExplorer
{
    param(
        [Parameter(Mandatory = $true)]
        [int]
        $BrowserVersion,

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
        if ( $null -eq $SkipRule -and $null -eq $Exception )
        {
            InternetExplorer Baseline
            {
                BrowserVersion  = [String]$BrowserVersion
                StigVersion     = $StigVersion
            }
        }
        elseif ( $null -ne $SkipRule -and $null -eq $Exception )
        {
            InternetExplorer Baseline
            {
                BrowserVersion  = [String]$BrowserVersion
                StigVersion     = $StigVersion
                Skiprule        = $SkipRule
            }
        }
        elseif ( $null -eq $SkipRule -and $null -ne $Exception )
        {
            InternetExplorer Baseline
            {
                BrowserVersion  = [String]$BrowserVersion
                StigVersion     = $StigVersion
                Exception       = $Exception
            }
        }
        elseif ( $null -ne $SkipRule -and $null -ne $Exception )
        {
            InternetExplorer Baseline
            {
                BrowserVersion  = [String]$BrowserVersion
                StigVersion     = $StigVersion
                Skiprule        = $SkipRule
                Exception       = $Exception
            }
        }
    }
    else
    {
        if ( $null -eq $SkipRule -and $null -eq $Exception )
        {
            InternetExplorer Baseline
            {
                BrowserVersion  = [String]$BrowserVersion
                StigVersion     = $StigVersion
                OrgSettings     = $OrgSettings
            }
        }
        elseif ( $null -ne $SkipRule -and $null -eq $Exception )
        {
            InternetExplorer Baseline
            {
                BrowserVersion  = [String]$BrowserVersion
                StigVersion     = $StigVersion
                OrgSettings     = $OrgSettings
                Skiprule        = $SkipRule
            }
        }
        elseif ( $null -eq $SkipRule -and $null -ne $Exception )
        {
            InternetExplorer Baseline
            {
                BrowserVersion  = [String]$BrowserVersion
                StigVersion     = $StigVersion
                OrgSettings     = $OrgSettings
                Exception       = $Exception
            }
        }
        elseif ( $null -ne $SkipRule -and $null -ne $Exception )
        {
            InternetExplorer Baseline
            {
                BrowserVersion  = [String]$BrowserVersion
                StigVersion     = $StigVersion
                OrgSettings     = $OrgSettings
                Skiprule        = $SkipRule
                Exception       = $Exception
            }
        }
    }

    foreach ( $rule in $SkipRule.Keys )
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
