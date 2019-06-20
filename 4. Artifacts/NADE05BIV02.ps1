Configuration PowerSTIG_WindowsDefender
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
            WindowsDefender BaseLine
            {
                StigVersion = $StigVersion
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $Exception)
        {
            WindowsDefender BaseLine
            {
                StigVersion = $StigVersion
                SkipRule    = $SkipRule
            }
        }
        elseif ($null -eq $skiprul -and $null -ne $Exception) {
            WindowsDefender BaseLine
            {
                StigVersion = $StigVersion
                Exception   = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            WindowsDefender Baseline
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
            WindowsDefender BaseLine
            {
                StigVersion = $StigVersion
                OrgSettings = $OrgSettings
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $exception)
        {
            WindowsDefender BaseLine
            {
                StigVersion = $StigVersion
                OrgSettings = $OrgSettings
                SkipRule    = $SkipRule
            }
        }
        elseif ( $null -eq $skiprule -and $null -ne $Exception ) {
            WindowsDefender BaseLine
            {
                StigVersion = $StigVersion
                OrgSettings = $OrgSettings
                Exception   = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            WindowsDefender Baseline
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
Configuration PowerSTIG_OracleJRE
{
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $ConfigPath,

        [Parameter(Mandatory = $true)]
        [string]
        $PropertiesPath,

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
            OracleJRE BaseLine
            {
                ConfigPath      = $ConfigPath
                StigVersion     = $StigVersion
                PropertiesPath  = $PropertiesPath
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $Exception)
        {
            OracleJRE BaseLine
            {
                ConfigPath      = $ConfigPath
                StigVersion     = $StigVersion
                PropertiesPath  = $PropertiesPath
                SkipRule        = $SkipRule
            }
        }
        elseif ($null -eq $skiprul -and $null -ne $Exception) {
            OracleJRE BaseLine
            {
                ConfigPath      = $ConfigPath
                StigVersion     = $StigVersion
                PropertiesPath  = $PropertiesPath
                Exception       = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            OracleJRE Baseline
            {
                ConfigPath      = $ConfigPath
                StigVersion     = $StigVersion
                PropertiesPath  = $PropertiesPath
                Exception       = $Exception
                SkipRule        = $SkipRule
            }
        }
    }
    else
    {
        if ( ($null -eq $SkipRule) -and ($null -eq $Exception) )
        {
            OracleJRE BaseLine
            {
                ConfigPath      = $ConfigPath
                StigVersion     = $StigVersion
                PropertiesPath  = $PropertiesPath
                OrgSettings     = $OrgSettings
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $exception)
        {
            OracleJRE BaseLine
            {
                ConfigPath      = $ConfigPath
                StigVersion     = $StigVersion
                PropertiesPath  = $PropertiesPath
                OrgSettings     = $OrgSettings
                SkipRule        = $SkipRule
            }
        }
        elseif ( $null -eq $skiprule -and $null -ne $Exception ) {
            OracleJRE BaseLine
            {
                ConfigPath      = $ConfigPath
                StigVersion     = $StigVersion
                PropertiesPath  = $PropertiesPath
                OrgSettings     = $OrgSettings
                Exception       = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            OracleJRE Baseline
            {
                ConfigPath      = $ConfigPath
                StigVersion     = $StigVersion
                PropertiesPath  = $PropertiesPath
                OrgSettings     = $OrgSettings
                Exception       = $Exception
                SkipRule        = $SkipRule
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
Configuration PowerSTIG_DotNetFramework
{
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $FrameworkVersion,

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
            DotNetFramework Baseline
            {
                FrameworkVersion    = $FrameworkVersion
                StigVersion         = $StigVersion
            }
        }
        elseif ( $null -ne $SkipRule -and $null -eq $Exception )
        {
            DotNetFramework Baseline
            {
                FrameworkVersion    = $FrameworkVersion
                StigVersion         = $StigVersion
                Skiprule            = $SkipRule
            }
        }
        elseif ( $null -eq $SkipRule -and $null -ne $Exception )
        {
            DotNetFramework Baseline
            {
                FrameworkVersion    = $FrameworkVersion
                StigVersion         = $StigVersion
                Exception           = $Exception
            }
        }
        elseif ( $null -ne $SkipRule -and $null -ne $Exception )
        {
            DotNetFramework Baseline
            {
                FrameworkVersion    = $FrameworkVersion
                StigVersion         = $StigVersion
                Skiprule            = $SkipRule
                Exception           = $Exception
            }
        }
    }
    else
    {
        if ( $null -eq $SkipRule -and $null -eq $Exception )
        {
            DotNetFramework Baseline
            {
                FrameworkVersion    = $FrameworkVersion
                StigVersion         = $StigVersion
                OrgSettings         = $OrgSettings
            }
        }
        elseif ( $null -ne $SkipRule -and $null -eq $Exception )
        {
            DotNetFramework Baseline
            {
                FrameworkVersion    = $FrameworkVersion
                StigVersion         = $StigVersion
                OrgSettings         = $OrgSettings
                Skiprule            = $SkipRule
            }
        }
        elseif ( $null -eq $SkipRule -and $null -ne $Exception )
        {
            DotNetFramework Baseline
            {
                FrameworkVersion    = $FrameworkVersion
                StigVersion         = $StigVersion
                OrgSettings         = $OrgSettings
                Exception           = $Exception
            }
        }
        elseif ( $null -ne $SkipRule -and $null -ne $Exception )
        {
            DotNetFramework Baseline
            {
                FrameworkVersion    = $FrameworkVersion
                StigVersion         = $StigVersion
                OrgSettings         = $OrgSettings
                Skiprule            = $SkipRule
                Exception           = $Exception
            }
        }
    }

    foreach($rule in $SkipRule.Keys)
    {
        Registry Exception_Rule
        {
            Ensure      = "Present"
            Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\STIGExceptions\"
            ValueName   = $rule
            ValueData   = $(Get-Date -format "MMddyyyy")
            ValueType   = "String"
            Force       = $true
        }
    }
}
Configuration PowerSTIG_Office_Outlook
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
Configuration PowerSTIG_SQLServer
{

    param(
        [Parameter(Mandatory = $true)]
        [string]
        $SqlVersion,

        [Parameter(Mandatory = $true)]
        [string]
        $SqlRole,

        [Parameter()]
        [version]
        $StigVersion,

        [Parameter(Mandatory = $true)]
        [string[]]
        $ServerInstance,

        [Parameter()]
        [string[]]
        $Database,

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
            SqlServer BaseLine
            {
                SqlVersion      = $SqlVersion
                SqlRole         = $SqlRole
                StigVersion     = $StigVersion
                ServerInstance  = $ServerInstance
                Database        = $Database
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $Exception)
        {
            SqlServer BaseLine
            {
                SqlVersion      = $SqlVersion
                SqlRole         = $SqlRole
                StigVersion     = $StigVersion
                ServerInstance  = $ServerInstance
                Database        = $Database
                SkipRule        = $SkipRule
            }
        }
        elseif ($null -eq $skiprul -and $null -ne $Exception) {
            SqlServer BaseLine
            {
                SqlVersion      = $SqlVersion
                SqlRole         = $SqlRole
                StigVersion     = $StigVersion
                ServerInstance  = $ServerInstance
                Database        = $Database
                Exception       = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            SqlServer Baseline
            {
                SqlVersion      = $SqlVersion
                SqlRole         = $SqlRole
                StigVersion     = $StigVersion
                ServerInstance  = $ServerInstance
                Database        = $Database
                Exception       = $Exception
                SkipRule        = $SkipRule
            }
        }
    }
    else
    {
        if ( ($null -eq $SkipRule) -and ($null -eq $Exception) )
        {
            SqlServer BaseLine
            {
                SqlVersion      = $SqlVersion
                SqlRole         = $SqlRole
                StigVersion     = $StigVersion
                ServerInstance  = $ServerInstance
                Database        = $Database
                OrgSettings     = $OrgSettings
            }
        }
        elseif ($null -ne $SkipRule -and $null -eq $exception)
        {
            SqlServer BaseLine
            {
                SqlVersion      = $SqlVersion
                SqlRole         = $SqlRole
                StigVersion     = $StigVersion
                ServerInstance  = $ServerInstance
                Database        = $Database
                OrgSettings     = $OrgSettings
                SkipRule        = $SkipRule
            }
        }
        elseif ( $null -eq $skiprule -and $null -ne $Exception ) {
            SqlServer BaseLine
            {
                SqlVersion      = $SqlVersion
                SqlRole         = $SqlRole
                StigVersion     = $StigVersion
                ServerInstance  = $ServerInstance
                Database        = $Database
                OrgSettings     = $OrgSettings
                Exception       = $Exception
            }
        }
        elseif ( ($null -ne $Exception ) -and ($null -ne $SkipRule) )
        {
            SqlServer Baseline
            {
                SqlVersion      = $SqlVersion
                SqlRole         = $SqlRole
                StigVersion     = $StigVersion
                ServerInstance  = $ServerInstance
                Database        = $Database
                OrgSettings     = $OrgSettings
                Exception       = $Exception
                SkipRule        = $SkipRule
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
Configuration PowerSTIG_FireFox
{
    param(
        [Parameter()]
        [string]
        $InstallDirectory = "$env:ProgramFiles\Mozilla Firefox",

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
            FireFox Baseline
            {
                InstallDirectory    = $InstallDirectory
                StigVersion         = $StigVersion
            }
        }
        elseif ( $null -ne $SkipRule -and $null -eq $Exception )
        {
            FireFox Baseline
            {
                InstallDirectory    = $InstallDirectory
                StigVersion         = $StigVersion
                Skiprule            = $SkipRule
            }
        }
        elseif ( $null -eq $SkipRule -and $null -ne $Exception )
        {
            FireFox Baseline
            {
                InstallDirectory    = $InstallDirectory
                StigVersion         = $StigVersion
                Exception           = $Exception
            }
        }
        elseif ( $null -ne $SkipRule -and $null -ne $Exception )
        {
            FireFox Baseline
            {
                InstallDirectory    = $InstallDirectory
                StigVersion         = $StigVersion
                Skiprule            = $SkipRule
                Exception           = $Exception
            }
        }
    }
    else
    {
        if ( $null -eq $SkipRule -and $null -eq $Exception )
        {
            FireFox Baseline
            {
                InstallDirectory    = $InstallDirectory
                StigVersion         = $StigVersion
                OrgSettings         = $OrgSettings
            }
        }
        elseif ( $null -ne $SkipRule -and $null -eq $Exception )
        {
            FireFox Baseline
            {
                InstallDirectory    = $InstallDirectory
                StigVersion         = $StigVersion
                OrgSettings         = $OrgSettings
                Skiprule            = $SkipRule
            }
        }
        elseif ( $null -eq $SkipRule -and $null -ne $Exception )
        {
            FireFox Baseline
            {
                InstallDirectory    = $InstallDirectory
                StigVersion         = $StigVersion
                OrgSettings         = $OrgSettings
                Exception           = $Exception
            }
        }
        elseif ( $null -ne $SkipRule -and $null -ne $Exception )
        {
            FireFox Baseline
            {
                InstallDirectory    = $InstallDirectory
                StigVersion         = $StigVersion
                OrgSettings         = $OrgSettings
                Skiprule            = $SkipRule
                Exception           = $Exception
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
Configuration PowerSTIG_Office_Powerpoint
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
Configuration PowerSTIG_WebServer
{

    param(
        [Parameter(Mandatory = $true)]
        [version]
        $IISVersion,

        [Parameter(Mandatory = $true)]
        [string]
        $LogPath,

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
            IISServer Baseline
            {
                IISVersion      = $IISVersion
                LogPath         = $LogPath
                StigVersion     = $StigVersion
            }
        }
        elseif ( $null -ne $SkipRule -and $null -eq $Exception )
        {
            IISServer Baseline
            {
                IISVersion      = $IisVersion
                LogPath         = $LogPath
                StigVersion     = $StigVersion
                Skiprule        = $SkipRule
            }
        }
        elseif ( $null -eq $SkipRule -and $null -ne $Exception )
        {
            IISServer Baseline
            {
                IISVersion      = $IisVersion
                LogPath         = $LogPath
                StigVersion     = $StigVersion
                Exception       = $Exception
            }
        }
        elseif ( $null -ne $SkipRule -and $null -ne $Exception )
        {
            IISServer Baseline
            {
                IISVersion      = $IisVersion
                LogPath         = $LogPath
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
            IISServer Baseline
            {
                IISVersion      = $IisVersion
                LogPath         = $LogPath
                StigVersion     = $StigVersion
                OrgSettings     = $OrgSettings
            }
        }
        elseif ( $null -ne $SkipRule -and $null -eq $Exception )
        {
            IISServer Baseline
            {
                IISVersion      = $IisVersion
                LogPath         = $LogPath
                StigVersion     = $StigVersion
                OrgSettings     = $OrgSettings
                Skiprule        = $SkipRule
            }
        }
        elseif ( $null -eq $SkipRule -and $null -ne $Exception )
        {
            IISServer Baseline
            {
                IISVersion      = $IisVersion
                LogPath         = $LogPath
                StigVersion     = $StigVersion
                OrgSettings     = $OrgSettings
                Exception       = $Exception
            }
        }
        elseif ( $null -ne $SkipRule -and $null -ne $Exception )
        {
            IISServer Baseline
            {
                IISVersion      = $IisVersion
                LogPath         = $LogPath
                StigVersion     = $StigVersion
                OrgSettings     = $OrgSettings
                Skiprule        = $SkipRule
                Exception       = $Exception
            }
        }
    }

    foreach($rule in $SkipRule.Keys)
    {
        Registry Exception_Rule
        {
            Ensure      = "Present"
            Key         = "HKEY_LOCAL_MACHINE\SOFTWARE\STIGExceptions\"
            ValueName   = $rule
            ValueData   = $(Get-Date -format "MMddyyyy")
            ValueType   = "String"
            Force       = $true
        }
    }
}
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
Configuration PowerSTIG_Office_Excel
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
Configuration MainConfig
{
	Node $AllNodes.Where{$_.NodeName -eq "NADE05BIV02"}.NodeName
	{
		PowerSTIG_WindowsDefender PowerSTIG_WindowsDefender
		{
			StigVersion = $node.appliedconfigurations.PowerSTIG_WindowsDefender["StigVersion"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_WindowsDefender["OrgSettings"]
		}

		PowerSTIG_WindowsServer PowerSTIG_WindowsServer
		{
			OsVersion = $node.appliedconfigurations.PowerSTIG_WindowsServer["OsVersion"]
			OsRole = $node.appliedconfigurations.PowerSTIG_WindowsServer["OsRole"]
			StigVersion = $node.appliedconfigurations.PowerSTIG_WindowsServer["StigVersion"]
			ForestName = $node.appliedconfigurations.PowerSTIG_WindowsServer["ForestName"]
			DomainName = $node.appliedconfigurations.PowerSTIG_WindowsServer["DomainName"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_WindowsServer["OrgSettings"]
		}

		PowerSTIG_OracleJRE PowerSTIG_OracleJRE
		{
			ConfigPath = $node.appliedconfigurations.PowerSTIG_OracleJRE["ConfigPath"]
			PropertiesPath = $node.appliedconfigurations.PowerSTIG_OracleJRE["PropertiesPath"]
			StigVersion = $node.appliedconfigurations.PowerSTIG_OracleJRE["StigVersion"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_OracleJRE["OrgSettings"]
		}

		PowerSTIG_DotNetFrameWork PowerSTIG_DotNetFrameWork
		{
			FrameworkVersion = $node.appliedconfigurations.PowerSTIG_DotNetFrameWork["FrameworkVersion"]
			StigVersion = $node.appliedconfigurations.PowerSTIG_DotNetFrameWork["StigVersion"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_DotNetFrameWork["OrgSettings"]
		}

		PowerSTIG_Office_Outlook PowerSTIG_Office_Outlook
		{
			OfficeApp = $node.appliedconfigurations.PowerSTIG_Office_Outlook["OfficeApp"]
			StigVersion = $node.appliedconfigurations.PowerSTIG_Office_Outlook["StigVersion"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_Office_Outlook["OrgSettings"]
		}

		PowerSTIG_SqlServer PowerSTIG_SqlServer
		{
			SqlVersion = $node.appliedconfigurations.PowerSTIG_SqlServer["SqlVersion"]
			SqlRole = $node.appliedconfigurations.PowerSTIG_SqlServer["SqlRole"]
			StigVersion = $node.appliedconfigurations.PowerSTIG_SqlServer["StigVersion"]
			ServerInstance = $node.appliedconfigurations.PowerSTIG_SqlServer["ServerInstance"]
			Database = $node.appliedconfigurations.PowerSTIG_SqlServer["Database"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_SqlServer["OrgSettings"]
		}

		PowerSTIG_FireFox PowerSTIG_FireFox
		{
			InstallDirectory = $node.appliedconfigurations.PowerSTIG_FireFox["InstallDirectory"]
			StigVersion = $node.appliedconfigurations.PowerSTIG_FireFox["StigVersion"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_FireFox["OrgSettings"]
		}

		PowerSTIG_Office_Word PowerSTIG_Office_Word
		{
			OfficeApp = $node.appliedconfigurations.PowerSTIG_Office_Word["OfficeApp"]
			StigVersion = $node.appliedconfigurations.PowerSTIG_Office_Word["StigVersion"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_Office_Word["OrgSettings"]
		}

		PowerSTIG_WindowsFireWall PowerSTIG_WindowsFireWall
		{
			StigVersion = $node.appliedconfigurations.PowerSTIG_WindowsFireWall["StigVersion"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_WindowsFireWall["OrgSettings"]
		}

		PowerSTIG_Office_PowerPoint PowerSTIG_Office_PowerPoint
		{
			OfficeApp = $node.appliedconfigurations.PowerSTIG_Office_PowerPoint["OfficeApp"]
			StigVersion = $node.appliedconfigurations.PowerSTIG_Office_PowerPoint["StigVersion"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_Office_PowerPoint["OrgSettings"]
		}

		PowerSTIG_WebServer PowerSTIG_WebServer
		{
			IISVersion = $node.appliedconfigurations.PowerSTIG_WebServer["IISVersion"]
			LogPath = $node.appliedconfigurations.PowerSTIG_WebServer["LogPath"]
			StigVersion = $node.appliedconfigurations.PowerSTIG_WebServer["StigVersion"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_WebServer["OrgSettings"]
		}

		PowerSTIG_InternetExplorer PowerSTIG_InternetExplorer
		{
			BrowserVersion = $node.appliedconfigurations.PowerSTIG_InternetExplorer["BrowserVersion"]
			StigVersion = $node.appliedconfigurations.PowerSTIG_InternetExplorer["StigVersion"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_InternetExplorer["OrgSettings"]
		}

		PowerSTIG_Office_Excel PowerSTIG_Office_Excel
		{
			OfficeApp = $node.appliedconfigurations.PowerSTIG_Office_Excel["OfficeApp"]
			StigVersion = $node.appliedconfigurations.PowerSTIG_Office_Excel["StigVersion"]
			OrgSettings = $node.appliedconfigurations.PowerSTIG_Office_Excel["OrgSettings"]
		}
	}
}

[DscLocalConfigurationManager()]
Configuration LocalConfigurationManager
{
	Node $AllNodes.Where{$_.NodeName -eq "NADE05BIV02"}.NodeName
	{
		Settings {
			RefreshFrequencyMins = $Node.LocalconfigurationManager.RefreshFrequencyMins
			ConfigurationModeFrequencyMins = $Node.LocalconfigurationManager.ConfigurationModeFrequencyMins
			ConfigurationMode = $Node.LocalconfigurationManager.ConfigurationMode
			StatusRetentionTimeInDays = $Node.LocalconfigurationManager.StatusRetentionTimeInDays
			RefreshMode = $Node.LocalconfigurationManager.RefreshMode
			AllowModuleOverwrite = $Node.LocalconfigurationManager.AllowModuleOverwrite
			MaximumDownloadSizeMB = $Node.LocalconfigurationManager.MaximumDownloadSizeMB
			RebootNodeIfNeeded = $Node.LocalconfigurationManager.RebootNodeIfNeeded
		}
	}
}
