Function Get-StigChecklist
{
    [cmdletbinding()]
    param(

        [Parameter()]
        [string]
        $RootPath = (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent),

        [Parameter()]
        [string]
        $OutputPath,

        [Parameter()]
        [array]
        $TargetMachines,

        [Parameter()]
        [string]
        $manualCheckPath,

        [Parameter()]
        [string]
        $checklistDataPath,

        [Parameter()]
        [switch]
        $TestConfig = $false

    )

    $nodeDataPath       = Resolve-Path -Path "$RootPath\*NodeData"
    $configPath         = Resolve-Path -Path "$RootPath\*Configurations"
    $mofPath            = Resolve-Path -Path "$RootPath\*Mofs"
    $artifactPath       = Resolve-Path -Path "$RootPath\*Artifacts"
    $resourcePath       = Resolve-Path -Path "$RootPath\*Resources"
    $testPath           = Resolve-Path -Path "$RootPath\*Tests"
    $reportsPath        = Resolve-Path -Path "$RootPath\*Reports"
    $archivePath        = Resolve-Path -Path "$RootPath\*Archive"

    $dateStamp          = Get-Date -Format "MM-dd-yyyy HHmm"
    $newChecklistPath   = New-Item -Path $OutputPath -Name "STIG Checklists - $dateStamp" -Itemtype Directory

    foreach ( $machine in $targetMachines )
    {
        Write-Host -Foregroundcolor DarkCyan    "    Generating STIG Checklists for " -NoNewLine
        Write-Host -Foregroundcolor Darkyellow  "$machine."

        $machineFolder      = New-Item -Path $newChecklistPath.fullname -Name "$machine - $dateStamp" -ItemType Directory
        $configDataFile     = Resolve-Path -Path "$nodeDataPath\*$machine.psd1"
        $data               = Invoke-Expression (Get-Content $configDataFile | Out-String)
        $appliedStigs       = $data.appliedconfigurations.getenumerator() | Where-Object { $_.name -like "*POWERSTIG*" }

        foreach ( $stig in $appliedStigs ) {
            $stigVersion    = $stig.value.stigVersion.tostring().replace(".","R")
            $stigType       = $stig.name.tostring().replace("PowerSTIG_","")

            if ($stigtype -eq "WindowsServer" ) {
                $serverOS   = $stig.value.osVersion
                $serverRole = $stig.value.osRole
                $fileName   = "*$serverOS*$serverRole*$stigVersion*"
            }
            elseif ( $stigType -like "Office*" )
            {
                $officeApp          = $stig.value.officeapp.tostring()
                $stigType           = "Office"
                $fileName           = "*$officeapp*$stigVersion*"
            }
            elseif ( $stigType -eq "InternetExplorer")
            {
                $ieVersion = $stig.value.browserversion.tostring()
                $fileName = "*$ieversion*$stigVersion*"
            }
            elseif ( $stigtype -eq "SQlServer" ){
                $sqlRole = $stig.value.sqlrole.tostring()
                $sqlversion = $stig.value.sqlversion.tostring()
                $fileName = "*$sqlversion*$sqlrole*$stigVersion*"

            }
            elseif ( $stigType -eq "Web*" )
            {
                $iisVersion         = $stig.value.sqlrole.tostring().replace(".","-")
                $iisType            = $stigType.replace("web","")
                $fileName           = "*$iisversion*$iisType*$stigVersion*"
            }
            else
            {
                $fileName           = "*$stigVersion*"
            }

            $xccdfPath              = Resolve-Path -Path "$checklistDataPath\*$stigType*\$fileName.xml"
            $manualCheckFile        = Resolve-Path -Path "$manualCheckPath\*$stigType*\$fileName.psd1"
            $OutputPath             = "$($machineFolder.fullname)\$machine-$stigType.ckl"



            Write-Host -Foregroundcolor DarkCyan "        Generating "  -NoNewLine
            Write-Host -Foregroundcolor DarkYellow "$StigType "          -NoNewLine
            Write-Host -Foregroundcolor DarkCyan "STIG Checklist."       -NoNewLine

            $params = @{
                xccdfPath               = $xccdfPath
                referenceConfiguration  = "$mofPath\$machine.mof"
                outputPath              = $outputPath
            }

            if ( $manualCheckFile )
            {
                $params += @{ manualCheckFile = $manualCheckFile }
            }

            if ( $stigType -like "office*" )
            {
                $xccdfPath          = Resolve-Path -Path "$checklistDataPath\*$stigType_*\$fileName.xml"
            }

            try
            {
                New-StigChecklist @params
            }
            catch
            {
                Write-Host "`r`n"
                Write-Warning "There may have been issues processing the $Stigtype Checklist."
                Write-Host "`r`n"
            }
            finally
            {
                Write-Host -Foregroundcolor Green "`t...Done."
            }
        }
    Write-Host -Foregroundcolor DarkYellow "    STIG CHECKLIST: STIG Checklist Generation for $machine is Complete."
    }
}