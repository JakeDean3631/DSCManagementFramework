Function Set-ConfigData {
    [cmdletbinding()]
    param(
        [Parameter()]
        [string]
        $NodeDataPath,

        [Parameter()]
        [string]
        $ParentPath,

        [Parameter()]
        [array]
        $Servers,

        [Parameter()]
        [string]
        $OSRole = "MS",

        [Parameter()]
        [string]
        $OSVersion = "2012R2",

        [Parameter()]
        [string]
        $StigVersion = "2.15",

        [Parameter()]
        [string]
        $DomainName = "USAFRICOM",

        [Parameter()]
        [string]
        $ForestName = "Mil",

        [Parameter()]
        [string]
        $OrgSettings = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG OrgSettings\Windows-2012R2-MS-2.15.org.xml",

        [Parameter()]
        [hashtable]
        $LCMSettings = @{
            ActionAfterReboot              = ""
            AgentId                        = ""
            AllowModuleOverwrite           = $True
            CertificateID                  = ""
            ConfigurationDownloadManagers  = ""
            ConfigurationID                = ""
            ConfigurationMode              = "ApplyAndAutoCorrect"
            ConfigurationModeFrequencyMins = "15"
            Credential                     = ""
            DebugMode                      = ""
            DownloadManagerCustomData      = ""
            DownloadManagerName            = ""
            LCMStateDetail                 = ""
            MaximumDownloadSizeMB          = "500"
            PartialConfigurations          = ""
            RebootNodeIfNeeded             = $False
            RefreshFrequencyMins           = "30"
            RefreshMode                    = "PUSH"
            ReportManagers                 = "{}"
            ResourceModuleManagers         = "{}"
            SignatureValidationPolicy      = ""
            SignatureValidations           = "{}"
            StatusRetentionTimeInDays      = "10"
        }
    )

    Foreach ($Server in $Servers)
    {

        $ConfigContent = "@{`n`tNodeName = `"$($Server)`"`n`n"
        $ConfigContent += "`tLocalConfigurationManager = @{`n"

        Foreach ($Setting in $LCMSettings.Keys) {

            If ( ($Null -ne $LcmSettings.$Setting ) -and ("{}" -ne $lcmsettings.$Setting) -and ("" -ne $LcmSettings.$Setting) )
            {
                $ConfigContent += "`n`t`t$($Setting)"

                if ( $Setting.Length -lt 8 )
                {
                    $ConfigContent += "`t`t`t`t`t`t`t= "
                }
                Elseif ( $Setting.Length -lt 12 )
                {
                    $ConfigContent += "`t`t`t`t`t`t= "
                }
                Elseif ( $Setting.Length -lt 16 )
                {
                    $ConfigContent += "`t`t`t`t`t= "
                }
                Elseif ( $Setting.Length -lt 20 )
                {
                    $ConfigContent += "`t`t`t`t= "
                }
                Elseif ( $Setting.Length -lt 24 )
                {
                    $ConfigContent += "`t`t`t= "
                }
                Elseif ( $Setting.Length -lt 28 )
                {
                    $ConfigContent += "`t`t= "
                }
                Elseif ( $Setting.Length -lt 32 )
                {
                    $ConfigContent += "`t= "
                }

                If ( ($LcmSettings.$Setting -eq $True ) -or ($LcmSettings.$Setting -eq $False) )
                {
                    $ConfigContent += "`$$($LcmSettings.$Setting)"
                }
                #elseif ($LcmSettings.$Setting -)
                Else
                {
                    $ConfigContent += "`"$($LcmSettings.$Setting)`""
                }
            }
        }
        $ConfigContent += "`n`t}"
        $ConfigContent += "`n`n`tConfigurationsToApply  = @{"
        $ConfigContent += "`n`t`tPowerSTIG_WindowsServer = @{"
        $ConfigContent += "`n`t`t`tOSRole       = `"$OsRole`""
        $ConfigContent += "`n`t`t`tOsVersion    = `"$OsVersion`""
        $ConfigContent += "`n`t`t`tStigVersion  = `"$StigVersion`""
        $ConfigContent += "`n`t`t`tDomainName   = `"$DomainName`""
        $ConfigContent += "`n`t`t`tForestName   = `"$ForestName`""
        $ConfigContent += "`n`t`t`tOrgSettings  = `"$OrgSettings`""
        $ConfigContent += "`n`t`t}"
        $ConfigContent += "`n`t}"
        $ConfigContent += "`n}"

        New-Item $NodeDataPath\$ParentPath -Force
        Set-Content -path $NodeDataPath\$Server $ConfigContent
    }
}
