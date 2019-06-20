Function Invoke-DscConfiguration
{
    [cmdletbinding()]
    param(

        [Parameter()]
        [string]
        $RootPath = (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent)

    )

    $nodeDataPath               = Resolve-Path -Path "$RootPath\*NodeData"
    $configPath                 = Resolve-Path -Path "$RootPath\*Configurations"
    $mofPath                    = Resolve-Path -Path "$RootPath\*Mofs"
    $artifactPath               = Resolve-Path -Path "$RootPath\*Artifacts"
    $resourcePath               = Resolve-Path -Path "$RootPath\*Resources"
    $testPath                   = Resolve-Path -Path "$RootPath\*Tests"
    $reportsPath                = Resolve-Path -Path "$RootPath\*Reports"
    $archivePath                = Resolve-Path -Path "$RootPath\*Archive"

    #Child Folder Paths
    $configMofs                 = Join-Path -Path $testPath -ChildPath "\Unit"
    $UnitTests                  = Join-Path -Path $testPath -ChildPath "\Unit"
    $preBuildTestPath           = Join-Path -Path $UnitTests -ChildPath "\Pre-Build"
    $postBuildTestPath          = Join-Path -Path $UnitTests -ChildPath "\Post-Build"
    $configurationDataPath      = "$artifactPath\configurationData.psd1"

    #Environmental Variables
    [array]$configurationFiles  = Get-ChildItem -Path "$nodeDataPath\*.psd1" -Recurse | Where-Object { $_.Fullname -notmatch "Staging" }
    [int]$countOfConfigurations = ($configurationFiles | Measure-object | Select-Object -expandproperty count)
    [array]$targetMachines      = (Get-Childitem $nodeDataPath "*.psd1").Name.replace('.psd1','')
    [array]$Modules             = Get-Childitem $resourcePath\Modules -Directory -Depth 0
    [array]$buildFunctions      = Get-Childitem "$resourcePath\Functions"

    Write-Host $RootPath
}