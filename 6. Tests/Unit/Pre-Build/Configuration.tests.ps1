$ScriptPath             = $MyInvocation.MyCommand.path
$preBuildPath           = Split-Path $ScriptPath -parent
$unitPath               = Split-Path $preBuildPath -parent
$testsPath              = Split-Path $unitPath -parent
$RootPath               = Split-Path $testsPath -parent
$nodeDataPath           = Resolve-Path -Path "$RootPath\*NodeData"
$configPath             = Resolve-Path -Path "$RootPath\*Configurations"
$mofPath                = Resolve-Path -Path "$RootPath\*Mofs"
$artifactPath           = Resolve-Path -Path "$RootPath\*Artifacts"
$resourcePath           = Resolve-Path -Path "$RootPath\*Resources"
$testPath               = Resolve-Path -Path "$RootPath\*Tests"
$reportsPath            = Resolve-Path -Path "$RootPath\*Reports"
$archivePath            = Resolve-Path -Path "$RootPath\*Archive"

[array]$configDataFiles = Get-ChildItem -Path "$nodeDataPath\*.psd1" -Recurse | Where-Object { ( $_.Fullname -notlike "*Staging*" ) -and ( $_.Fullname -Notlike "*Readme*" ) }
[array]$dscScriptFiles  = Get-ChildItem -Path "$configPath\*.ps1" -Recurse | Where-Object { $_.Fullname -notmatch "Staging" }
$targetMachines         = (Get-Childitem $nodeDataPath "*.psd1").BaseName


Describe "Configuration file names that should match the name of the configuration command." {

    foreach ($configFile in $dscScriptFiles)
    {
        $configContent = Get-Content $configFile.FullName
        If ($Null -ne $configContent)
        {
            $configName = $configContent[0].replace("Configuration ","")
            $configFileName = $configfile.basename

            It "$ConfigFileName should match the name of the file: $configName" {
                $configfilename -eq $configname | Should be $true
            }
        }
    }
}

# Describe "Validating Configuration parameters being applied to Configuration Script." {

#     foreach( $configDataFile in $configDataFiles )
#     {
#         $data = Invoke-Expression (Get-Content $configDataFile.FullName | Out-String)
#         $appliedConfigs = $data.appliedconfigurations.Keys
#         $LCMConfig = $data.LocalConfigurationManager.Keys
#         $nodeName = $data.NodeName

#         It "The Nodename $nodeName should match the name of the Configuration Data File." {
#             $nodeName -eq $configDataFile.basename | Should be $true
#         }

        # Todo - Write test to validate parameters used within $appliedConfigs

#         Describe "Validating Configuration parameters being applied through $nodename's Config Data."  {

#         foreach ( $appliedConfig in $appliedConfigs ) {
#             It "Configurations being applied to $nodeName"

#         if(Test-Path "$configPath\$configDataFile.ps1")
#         {
#             # TODO: Add a test to validate that the configuration is named the same as the file
#             Write-Host -ForegroundColor DarkCyan "BUILD: Generating $configDataFile Data for $NodeName."
#             $fileContent = Get-Content "$configPath\$configDataFile.ps1" -Encoding UTF8 -ErrorAction Stop
#             $fileContent | Out-file $combinedPS1Path -Append -Encoding utf8 -ErrorAction Stop
#             . "$configPath\$configDataFile.ps1"
#             #Invoke-Expression ($fileContent | Out-String) #DevSkim: ignore DS104456
#         }
#         else
#         {
#             Throw "The configuration $appliedConfig was specified in the $($configDataFile.FullName) file but no configuration file with the name $appliedConfig was found in the \Configurations folder."
#         }
#         $mainConfig = "Configuration MainConfig`n{`n`tNode `$AllNodes.Where{`$_.NodeName -eq `"$nodeName`"}.NodeName`n`t{"
    # }
# }