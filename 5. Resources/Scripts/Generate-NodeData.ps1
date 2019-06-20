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
    DebugMode                      = "{NONE}"
    DownloadManagerCustomData      = ""
    DownloadManagerName            = ""
    LCMCompatibleVersions          = "{1.0, 2.0}"
    LCMState                       = "Idle"
    LCMStateDetail                 = ""
    LCMVersion                     = "2.0"
    MaximumDownloadSizeMB          = "500"
    PartialConfigurations          = ""
    RebootNodeIfNeeded             = "`$False"
    RefreshFrequencyMins           = "30"
    RefreshMode                    = "PUSH"
    ReportManagers                 = "{}"
    ResourceModuleManagers         = "{}"
    SignatureValidationPolicy      = "NONE"
    SignatureValidations           = "{}"
    StatusRetentionTimeInDays      = "10"
}

Function Generate-NodeData {
    param(
        [Parameter(Mandatory=$True)]
        [Hashtable]$LCMSettings,
        [Parameter(Mandatory=$True)]     
        [String]$Domain,
        [Parameter()]     
        [String]$Installation
    )
    
    $InstallationPath = New-Item -ItemType Directory -Path "$RepoPath\$Installation" 
    $SearchBase = "OU=$Installation,OU=Installations,DC=$Domain,DC=ds,DC=army,DC=mil"
    $OrgOUs = Get-ADOrganizationalUnit -SearchBase $Searchbase -SearchScope OneLevel
    
    Foreach ($OrgOU in $OrgOUs) {
        
        $orgname = $orgOU.name
        $orgPath = New-Item -ItemType Directory -Path "$InstallationPath\$($OrgOU.Name)"
        $orgSubOus = Get-ADOrganizationalunit -SearchBase $OrgOU.DistinguishedName  
        
        Foreach ($subOU in $orgSubOUs) {

            $Subname = $SubOU.name
            $Servers = Get-ADComputer -SearchBase $SubOU.DistinguishedName -Filter {OperatingSystem -like "Windows Server"}  
            
            If ($Servers -gt 0) {
                
                $Servercount = $Servers.count
                Write-Host "Generating Configuration Data for $ServerCount $Orgname servers in the $subName OU."
                $subPath = New-Item -ItemType Directory -Path "$orgPath\$($SubOU.Name)"
                
                Foreach ($Server in $Servers) {

                    $ConfigContent = "@{`n`tNodeName                            =   $($Server.name)`n`nLocalConfigurationManager =`n@{`n"

                    Foreach ($Setting in $LCMSettings) { 
                        
                        If ($Null -ne $Setting.value) { 
                        
                            $ConfigContent += "$($Setting.name)`t=$($Setting.Value)`n" 
                        }
                    }
                    
                    $ConfigContent +=
@"
                        ConfigurationsToApply  = 
                        @{

                            PowerSTIG_MemberServer = 
                                @{
                                    OSRole  =       "MS"
                                    OSVersion =     "2012R2"
                                    STIGVersion =   "2.13"
                                    Domainname =    "$Domain"
                                    Forestname =    "$Forest"
                            }
                        }
                    }
"@

                    New-Item -ItemType  -Path "$Subpath\$($Server.name).psd1" | Set-Content $Content
                }
                Else {
                    Write-Host "$($subOU.name) OU does not contain any $orgName Servers."
                }
            }
        }
    }
}
