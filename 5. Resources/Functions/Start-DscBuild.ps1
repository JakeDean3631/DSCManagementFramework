Function Start-DSCBuild
{
    [cmdletbinding()]
    param(

        [Parameter()]
        [string]
        $RootPath = (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent)

    )

    ######################################################################
    #                                                                    #
    #                Prepare Environment and run Pre-tests               #
    #                                                                    #
    ######################################################################

    #region Create Environment Variables
    Clear-Host
    #Root Folder Paths
    $nodeDataPath               = Resolve-Path -Path "$RootPath\*NodeData"
    $configPath                 = Resolve-Path -Path "$RootPath\*Configurations"
    $mofPath                    = Resolve-Path -Path "$RootPath\*Mofs"
    $artifactPath               = Resolve-Path -Path "$RootPath\*Artifacts"
    $resourcePath               = Resolve-Path -Path "$RootPath\*Resources"
    $testPath                   = Resolve-Path -Path "$RootPath\*Tests"
    $reportsPath                = Resolve-Path -Path "$RootPath\*Reports"
    $archivePath                = Resolve-Path -Path "$RootPath\*Archive"

    #Child Folder Paths
    $configMofs                 = Join-Path -Path $testPath       -ChildPath "\Unit"
    $UnitTests                  = Join-Path -Path $testPath       -ChildPath "\Unit"
    $preBuildTestPath           = Join-Path -Path $UnitTests      -ChildPath "\Pre-Build"
    $postBuildTestPath          = Join-Path -Path $UnitTests      -ChildPath "\Post-Build"
    $configurationDataPath      = "$artifactPath\configurationData.psd1"

    #STIG Paths
    $stigDataPath               = Join-Path -Path $resourcePath -ChildPath "STIG Data"
    $stigChecklistPath          = Join-Path -Path $reportsPath  -ChildPath "STIG Checklists"
    $checklistDataPath          = Join-Path -Path $stigDataPath -ChildPath "ChecklistData"
    $stigManualCheckPath        = Join-Path -Path $stigDataPath -ChildPath "Manual Checks"

    #Environmental Arrays
    [array]$configDataFiles     = Get-ChildItem -Path "$nodeDataPath\*.psd1" -Recurse | Where-Object { ( $_.Fullname -notmatch "Staging" ) -and ( $_.Fullname -Notlike "Readme*" ) }
    [array]$configScriptFiles   = Get-ChildItem -Path "$configPath\*.ps1" -Recurse | Where-Object { $_.Fullname -notmatch "Staging" }
    [array]$modules             = Get-ChildItem -Path "$resourcePath\Modules" -Directory -Depth 0
    [array]$buildFunctions      = Get-ChildItem -Path "$resourcePath\Functions"
    [array]$preBuildTests       = Get-ChildItem -Path "$preBuildTestPath\*.tests.ps1"
    [array]$targetMachines      = $configDataFiles.basename

    [int]$countOfConfigurations = ($configDataFiles | Measure-object | Select-Object -expandproperty count)

    #region Import Build Functions
    Write-Host -ForegroundColor DarkCyan        "Beginning Desired State Configuration Build Process`r`n"
    Write-Host -ForegroundColor DarkCyan        "BUILD: Importing Build Functions."
    foreach ($function in $buildfunctions)
    {
        Write-Host -ForegroundColor DarkCyan    "    Importing " -nonewline
        Write-Host -ForegroundColor DarkYellow       "$($function.basename)." -nonewline
        . $function.fullname
        Write-Host -ForegroundColor green "     ...Done"
    }
    Write-Host "`r`n"

    #Remove old Mofs/Artifacts
    Write-Host -ForegroundColor DarkCyan "BUILD: Removing Existing Mofs and build artifacts."
    $removeItems = Get-Childitem "$mofPath\*.mof"
    $removeItems = Get-Childitem "$artifactPath\*.ps*"
    foreach ( $item in $RemoveItems ) {
        Write-Host -ForegroundColor DarkCyan "      Removing " -NoNewline
        Write-Host -ForegroundColor DarkYellow "$($Item.Name)." -NoNewline
        Remove-Item $Item 
        Write-Host -ForegroundColor Green "     ...Done"
    }
    Write-Host "`r`n"

    #Validate Modules on host and target machines
    Write-Host -ForegroundColor DarkCyan "BUILD: Performing DSC Resource Module Validation."
    Copy-DSCModules -TargetMachines $targetMachines -ModulePath "$resourcePath\Modules"
    Write-Host "`r`n"

    #Import required modules
    Write-Host -ForegroundColor DarkCyan "BUILD: Importing required modules on the local system."

    Foreach ($module in $modules)
    {
        Write-Host -ForegroundColor DarkCyan    "    Importing Module - "     -NoNewLine
        Write-Host -ForegroundColor DarkYellow  "$($module.name)"  -NoNewline
        Import-Module $Module.name
        Write-Host -ForegroundColor green "     ...Done"
    }
    Write-Host "`r`n"

    #region Execute pre-build tests
    Write-Host -ForegroundColor DarkCyan "BUILD: Executing pre-build Pester tests"
    Write-Host "`r`n"
    Invoke-Pester -Path $preBuildTestPath
    Write-Host "`r`n"

    ######################################################################
    #                                                                    #
    #                       Combine all PSD1 Files                       #
    #                                                                    #
    ######################################################################
    #region Combine PSD1

    Write-Host -ForegroundColor DarkCyan "BUILD: Beginning Powershell Data File build for $($ConfigDataFiles.count) Identified Servers.`b"
    New-Item -ItemType File -Path $configurationDataPath -Force | Out-Null

    $string = "@{`n`tAllNodes = @(`n"
    $string | Out-File $configurationDataPath -Encoding utf8

    for($i=0;$i -lt $countOfConfigurations;$i++)
    {
        Get-Content -Path $($configDataFiles[$i].FullName) -Encoding UTF8 |
            ForEach-Object {
                "`t`t" + $_ | Out-file $configurationDataPath -Append -Encoding utf8
            }

        if($i -ne ($countOfConfigurations - 1) -and ($countOfConfigurations -ne 1))
        {
            "`t`t," | Out-file $configurationDataPath -Append -Encoding utf8
        }
    }
    "`t)`n}" | Out-File $configurationDataPath -Append -Encoding utf8
    #endregion

    <# Create a combined configuration file for each server
        Loop through the combined data file and create a combined
            configuration script for each server.  MainConfig will be the
            keyword used to execute the creation of MOF files
    #>

    ######################################################################
    #                                                                    #
    #            Build configuration scripts for each server             #
    #                                                                    #
    ######################################################################
    #region Build configs

    foreach($configDataFile in $configDataFiles)
    {
        $machinename = $configDataFile.basename
        $combinedPS1Path =  "$artifactPath\$($configDataFile.BaseName).ps1"
        $data = Invoke-Expression (Get-Content $configDataFile.FullName | Out-String)
        $appliedConfigs = $data.appliedconfigurations.Keys
        $lcmConfig = $data.LocalConfigurationManager.Keys
        $nodeName = $data.NodeName

        Write-Host -ForegroundColor DarkCyan "      Building Configuration Data for " -NoNewLine
        Write-Host -ForegroundColor DarkYellow "$machineName."

        New-Item -ItemType File -Path $combinedPS1Path -Force | Out-Null

        #region Combine data for Configuration Mof

        foreach ( $appliedConfig in $appliedConfigs )
        {

            if(Test-Path $configDataFile.fullname)
            {
                # TODO: Add a test to validate that the configuration is named the same as the file
                Write-Host -ForegroundColor DarkCyan    "           Importing "  -NoNewLine
                Write-Host -ForegroundColor DarkYellow  "$appliedConfig "       -NoNewLine 
                Write-Host -ForegroundColor DarkCyan    "Data."   -NoNewline

                $fileContent = Get-Content "$configPath\$appliedConfig.ps1" -Encoding UTF8 -ErrorAction Stop
                $fileContent | Out-file $combinedPS1Path -Append -Encoding utf8 -ErrorAction Stop
                . "$configPath\$appliedConfig.ps1"
                Invoke-Expression ($fileContent | Out-String) #DevSkim: ignore DS104456
                Write-Host -ForegroundColor Green "         ...Done"
            }
            else
            {
                Throw "The configuration $appliedConfig was specified in the $($configDataFile.fullname) file but no configuration file with the name $appliedConfig was found in the \Configurations folder."
            }
        }

        $mainConfig = "Configuration MainConfig`n{`n`tNode `$AllNodes.Where{`$_.NodeName -eq `"$nodeName`"}.NodeName`n`t{"

        foreach ( $appliedConfig in $appliedConfigs )
        {
            Write-Host -ForegroundColor DarkCyan    "           Generating " -NoNewLine
            Write-Host -ForegroundColor DarkYellow "$AppliedConfig " -NoNewLine
            Write-Host -ForegroundColor DarkCyan "Parameter Data." -NoNewline

            $syntax = Get-Command $appliedConfig -Syntax -ErrorAction Stop
            $appliedConfigParameters = [Regex]::Matches($syntax,"\[{1,2}\-[a-zA-Z0-9]+") |
                Select-Object @{l="Name";e={$_.Value.Substring($_.Value.IndexOf('-')+1)}},
                    @{l="Mandatory";e={if($_.Value.IndexOf('-') -eq 1){$true}else{$false}}}
            $mainConfig += "`n`t`t$appliedConfig $appliedConfig`n`t`t{`n"

            foreach ( $appliedConfigParameter in $appliedConfigParameters )
            {
                if ( $null -ne $data.appliedconfigurations.$appliedConfig[$appliedConfigParameter.name] )
                {
                    $mainConfig += "`t`t`t$($appliedConfigParameter.name) = `$node.appliedconfigurations.$appliedConfig[`"$($appliedConfigParameter.name)`"]`n"
                }
                elseif ( $true -eq $appliedConfigParameter.mandatory )
                {
                    $errorMessage = "$nodeName configuration $appliedConfig has a mandatory parameter $($appliedConfigParameter.name) and was not specified.`n`n"
                    $errorMessage += "$appliedConfig = @{`n"
                    foreach($appliedConfigParameter in $appliedConfigParameters)
                    {
                        $errorMessage += "`t$($appliedconfigParameter.name) = `"VALUE`"`n"
                    }
                    $errorMessage += "}"
                    Throw $errorMessage
                }
            }
            $mainConfig += "`t`t}`n"
            Write-Host -ForegroundColor Green " ...Done"
        }
        $mainConfig += "`t}`n}`n"
        $mainConfig | Out-file $combinedPS1Path -Append -Encoding utf8
    #endregion

    #region Generate data for meta.mof (Local Configuration Manager)

        if ( $null -ne $lcmConfig )
        {
            Write-Host -ForegroundColor DarkCyan    "           Generating " -NoNewLine
            Write-Host -ForegroundColor DarkYellow  "Local Configuration Manager " -NoNewline
            Write-Host -ForegroundColor DarkCyan    "Data." -NoNewline

            [array]$lcmParameters = "ActionAfterReboot","AllowModuleOverWrite","CertificateID","ConfigurationDownloadManagers","ConfigurationID","ConfigurationMode","ConfigurationModeFrequencyMins","DebugMode","StatusRetentionTimeInDays","SignatureValidationPolicy","SignatureValidations","MaximumDownloadSizeMB","PartialConfigurations","RebootNodeIfNeeded","RefreshFrequencyMins","RefreshMode","ReportManagers","ResourceModuleManagers"
            $localConfig = "[DscLocalConfigurationManager()]`n"
            $localConfig += "Configuration LocalConfigurationManager`n{`n`tNode `$AllNodes.Where{`$_.NodeName -eq `"$nodeName`"}.NodeName`n`t{`n`t`tSettings {`n"

            foreach ( $setting in $lcmConfig )
            {
                if ( $Null -ne ( $lcmParameters | Where-Object { $setting -match $_ } ) )
                {
                    $localConfig += "`t`t`t$setting = `$Node.LocalconfigurationManager.$Setting`n"
                }
                else
                {
                    Write-Warning "The term `"$setting`" is not a configurable setting within the Local Configuration Manager."
                }
            }
            $localConfig += "`t`t}`n`t}`n}"
            $localConfig | Out-file $combinedPS1Path -Append -Encoding utf8
            Write-Host -ForegroundColor Green "         ...Done"
        }
        Write-Host -ForegroundColor DarkYellow "    $nodeName " -NoNewLine
        Write-Host -ForegroundColor DarkCyan "configuration file successfully generated.`r`n"

    }
    #endregion

    ######################################################################
    #                                                                    #
    #              Create MOF files for each configuration               #
    #                                                                    #
    ######################################################################
    #region Create MOFs
    $combinedConfigurationFiles = Get-ChildItem "$artifactPath\*.ps1" | Select-Object -ExpandProperty FullName

    foreach( $combinedConfigurationFile in $combinedConfigurationFiles )
    {
        try{

            # Execute each file into memory
            . $combinedConfigurationFile

            # Run each configuration with the corresponding data file
            Write-Host -ForegroundColor DarkCyan "          Generating MOF for " -NoNewLine
            Write-Host -ForegroundColor DarkYellow "$nodeName." -NoNewline
            $null = MainConfig -ConfigurationData $configurationDataPath -OutputPath $mofPath
            Write-Host -ForegroundColor Green "         ...Done"

            Write-Host -ForegroundColor DarkCyan "          Generating Meta MOF for " -NoNewline
            Write-Host -ForegroundColor DarkYellow "$nodeName." -NoNewline
            $null = LocalConfigurationManager -ConfigurationData $configurationDataPath -Outputpath $mofPath
            Write-Host -ForegroundColor Green "         ...Done"
        }
        catch
        {
            Throw "Error occured executing $combinedConfigurationFile to generate MOF.`n $($_)"
        }
    }
    #endregion

    #region Generate STIG Checklists
    Write-Host -ForegroundColor DarkCyan "BUILD: Beginning STIG Checklist Generation.`b"
    $params = @{
        rootPath            = $RootPath
        outputPath          = $stigChecklistPath
        checklistDataPath   = $ChecklistDataPath
        targetMachines      = $targetMachines
        manualCheckPath     = $stigManualCheckPath
    }
    Get-StigChecklist @params

    ######################################################################
    #                                                                    #
    #         Archive the new MOF files and Artifacts from build         #
    #                                                                    #
    ######################################################################
    #region Archive
    # Archive the current MOF and build files in MMddyyyy_HHmm_DSC folder format
    $datePath = (Get-Date -format "MMddyyyy_HHmm")
    #Compress-Archive -Path "$mofPath\*.mof" -DestinationPath ("$archivePath\{0}_DSC.zip" -f $datePath) -Update
    #Compress-Archive -Path "$artifactPath\*.ps*" -DestinationPath ("$archivePath\{0}_DSC.zip" -f $datePath) -Update
    #endregion
}

function Get-StigXccdfBenchmarkContent
{
    [cmdletbinding()]
    [OutputType([xml])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

    if (-not (Test-Path -Path $Path))
    {
        Throw "The file $Path was not found"
    }

    if ($Path -like "*.zip")
    {
        [xml] $xccdfXmlContent = Get-StigContentFromZip -Path $Path
    }
    else
    {
        [xml] $xccdfXmlContent = Get-Content -Path $Path -Encoding UTF8
    }

    $xccdfXmlContent.Benchmark
}

function Get-StigXccdfBenchmarkContent
{
    [cmdletbinding()]
    [OutputType([xml])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

    if (-not (Test-Path -Path $Path))
    {
        Throw "The file $Path was not found"
    }

    if ($Path -like "*.zip")
    {
        [xml] $xccdfXmlContent = Get-StigContentFromZip -Path $Path
    }
    else
    {
        [xml] $xccdfXmlContent = Get-Content -Path $Path -Encoding UTF8
    }

    $xccdfXmlContent.Benchmark
}
