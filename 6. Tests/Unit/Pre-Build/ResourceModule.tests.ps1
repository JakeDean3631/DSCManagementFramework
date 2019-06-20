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
$targetMachines         = (Get-Childitem $nodeDataPath "*.psd1").name.replace('.psd1','')

$modules        = Get-Childitem "$resourcePath\Modules" -Directory -Depth 0 | Where-Object { $_.Name -ne "DSCEA" }
    
foreach ($machine in $targetMachines)
{
    Describe "Required DSC Resource modules for $machine" {
    $modulePaths = @(
        "\\$Machine\C$\Program Files\WindowsPowershell\Modules"
        "\\$Machine\C$\Program Files(x86)\WindowsPowershell\Modules"
        "\\$Machine\C$\Windows\System32\WindowsPowershell\1.0\Modules"
    )
    foreach ($module in $modules)
    {
        $moduleTest = $null
        $moduleVersion = (Get-ChildItem -Path $Module.Fullname -Directory -Depth 0 ).name

        foreach ($modulePath in $modulePaths)
        {
            $moduleCheck = Test-Path "$ModulePath\$($Module.name)\$moduleVersion" -ErrorAction SilentlyContinue

            if ($moduleCheck)
            {
                $moduleTest = $true
            }
        }

        It "$($module.name) version $($moduleVersion) should be installed on $machine."{
            $moduleTest | Should Be $true

            }
        }
    }
}
