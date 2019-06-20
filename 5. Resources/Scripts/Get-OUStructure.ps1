
Function Get-DataStructure {
    [cmdletbinding()]
    param(

        [Parameter()]
        [string]
        $RootPath,

        [Parameter()]
        [psobject]
        $RootOrgUnit

    )
    $dataFileCount = 0
    Write-Host -ForegroundColor DarkCyan "Gathering Sub-Organizational Units under the provided Root OU - "  -NoNewline
    Write-Host -ForegroundColor DarkYellow "$($RootOrgUnit.name) "

    $parentOUs = Get-ADOrganizationalUnit -SearchBase $RootOrgUnit.DistinguishedName -filter * -SearchScope OneLevel
    Write-Host -ForegroundColor DarkCyan " Discovered "  -NoNewline
    Write-Host -ForegroundColor DarkYellow "$($parentOUs.count) " -NoNewLine
    Write-Host -ForegroundColor DarkCyan "Organizational Units."
    $nodeDataPath = "$rootPath\1. nodeData\test"

    Foreach ( $parentOU in $parentOUs)
    {
        $serverOU   = $null
        $servers    = $null

        Write-Host -ForegroundColor DarkCyan "Beginning Server Configuration Data creation for the " -NoNewline
        Write-Host -ForegroundColor DarkYellow "$($parentOU.name) " -NoNewLine
        Write-Host -ForegroundColor DarkCyan "Organizational Unit."

        $serverOU = Get-ADOrganizationalUnit -SearchBase "$($parentOU.DistinguishedName)" -filter { Name -like "Servers" } -SearchScope OneLevel

        if ( $null -ne $serverOU )
        {
            Write-Host -ForegroundColor DarkCyan "      Server Organizational unit found. Searching for Server Objects."
            $servers = Get-ADComputer -SearchBase $ServerOU.Distinguishedname -Filter *

            if ( $servers.count -gt 0 )
            {

                Write-Host -ForegroundColor DarkYellow "        $($Servers.Count) "     -NoNewLine
                Write-Host -ForegroundColor DarkCyan "Server Object found under "             -NoNewline
                Write-Host -ForegroundColor DarkYellow "$($parentOU.name)'s "   -NoNewLine
                Write-Host -ForegroundColor DarkCyan "Servers Organizational unit."
                Write-Host -ForegroundColor DarkCyan "      Generating Server Configuration Data." -NoNewline
                #Create the Parent OU Folder
                $params = @{
                    Itemtype    = "Directory"
                    Path        = $nodeDataPath
                    Name        = $parentOU.name
                    Force       = $true
                }

                $parentOUPath = "$($params.path)\$($params.Name)"

                if ( $false -eq (Test-Path $parentOUPath ) )
                {
                    $parentOUPath = New-Item @params
                }
                else
                {
                    Write-Host "`r`n"
                    Write-Warning -ForegroundColor DarkCyan "Folder Already exists for $($parentOU.name).`r`n"
                }

                foreach ( $Server in $Servers )
                {
                    #Create the Server psd1 file
                    $params = @{
                        Path        = $parentOUPath
                        Name        = "$($server.name).psd1"
                        Force       = $true
                    }

                    $filepath = "$($params.Path)\$($Params.name)"

                    if ( $false -eq (Test-Path $filePath) )
                    {
                        $serverDataFile = New-Item @params
                        #Set data within server configdata file.
                        Set-ConfigData -DataFile $serverDataFile
                        $ouFileCount += 1
                        $dataFileCount += 1
                    }
                    else 
                    {
                        Write-Host "`r`n"
                        Write-Warning -ForegroundColor DarkCyan "File Already exists for $($server.name).`r`n"
                    }
                }
                Write-Host -ForegroundColor Green "...Done.`r`n"
            }
            else
            {
                Write-Host "`r`n"
                Write-Warning "There are no Server objects contained in the $($parentOU.name) Server Organizational Unit.`r`n" 
            }

        }
        else
        {
            Write-Host -ForegroundColor DarkCyan "There is not a Server Organizational Unit under the " -NoNewLine
            Write-Host -ForegroundColor DarkYellow "$($parentOU.name) " -NoNewLine
            Write-Host -ForegroundColor DarkCyan "Organizational Unit.`r`n"
        }
    }
    Write-Host -ForegroundColor DarkCyan "Configuration Data creation complete. "
    Write-Host -ForegroundColor DarkCyan "Generated configuration data for a total of " -NoNewLine
    Write-Host -ForegroundColor DarkYellow "$dataFileCount " -NoNewLine
    Write-Host -ForegroundColor DarkCyan "Newly discovered servers. "
}


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
        [string]
        $DataFile,

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

        $ConfigContent = "@{`n`tNodeName = `"$($Server.name)`"`n`n"
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
        $ConfigContent += "`n`t`tPowerSTIG_MemberServer = @{"
        $ConfigContent += "`n`t`t`tOSRole       = `"$OsRole`""
        $ConfigContent += "`n`t`t`tOsVersion    = `"$OsVersion`""
        $ConfigContent += "`n`t`t`tStigVersion  = `"$StigVersion`""
        $ConfigContent += "`n`t`t`tDomainName   = `"$DomainName`""
        $ConfigContent += "`n`t`t`tForestName   = `"$ForestName`""
        $ConfigContent += "`n`t`t`tOrgSettings  = `"$OrgSettings`""
        $ConfigContent += "`n`t`t}"
        $ConfigContent += "`n`t}"
        $ConfigContent += "`n}"

        Set-Content -path $DataFile $ConfigContent
    }
}