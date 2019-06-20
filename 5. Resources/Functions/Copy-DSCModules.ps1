Function Copy-DSCModules
{
    [cmdletbinding()]
    param(

        [Parameter()]
        [array]
        $TargetMachines,

        [Parameter()]
        [string]
        $ModulePath

    )

    $totalMachineCount = $TargetMachines.Count
    $currentMachineCount = 0

    Foreach ($machine in $TargetMachines )
    {

        $currentMachineCount += 1
        $destinationPath = "\\$Machine\C$\Program Files\WindowsPowershell\Modules"
        $destinationModulePaths = @(
            "\\$Machine\C$\Program Files\WindowsPowershell\Modules"
            "\\$Machine\C$\Program Files(x86)\WindowsPowershell\Modules"
            "\\$Machine\C$\Windows\System32\WindowsPowershell\1.0\Modules"
        )
        Write-Progress -ID 0 -Activity "Performing Module Validation on all targetted servers." -Status "Validating Modules on machine $currentMachineCount of $totalMachineCount" -PercentComplete (($currentMachineCount / $totalMachineCount ) * 100 ) -CurrentOperation $machineStatus

        $modulePathTest = Test-Path $ModulePath -ErrorAction SilentlyContinue
        $destinationPathTest = Test-Path $destinationPath -ErrorAction SilentlyContinue

        If ($destinationPathTest -and $modulePathTest )
        {
            $modules = Get-Childitem -Path $modulePath -Directory -Depth 0 | Where-Object { $_.Name -ne "DSCEA" -and $_.name -ne "Pester" }
            [int]$totalModuleCount = $modules.Count
            [int]$currentModuleCount = 0

            foreach ($module in $modules)
            {
                [int]$completedChecks = 0
                [int]$currentModuleCount += 1
                $moduleStatus = "Validating $($Module.name) on $machine.`t`t"
                $moduleVersion = (Get-ChildItem -Path $Module.Fullname -Directory -Depth 0 ).name

                Write-Host -ForegroundColor DarkCyan    "    Searching for " -nonewline
                Write-Host -ForegroundColor DarkYellow  "$($Module.Name) "   -nonewline
                Write-Host -ForegroundColor DarkYellow  "on $machine."       -nonewline
                Write-Progress -ID 1 -Activity "Validating modules on $Machine" -Status "Validating Module $currentModuleCount of $totalModuleCount" -PercentComplete (($curentModuleCount / $totalModuleCount ) * 100 ) -CurrentOperation $moduleStatus

                foreach ($destinationModulePath in $destinationModulePaths)
                {
                    $modulecheck = Test-Path "$destinationPath\$($Module.name)" -ErrorAction SilentlyContinue

                    if ($moduleCheck)
                    {
                        $versionCheck = Test-Path "$destinationPath\$($Module.name)\$moduleVersion" -ErrorAction SilentlyContinue
                    }
                    else
                    {
                        $completedChecks += 1
                    }

                    if ($modulecheck -and $versioncheck)
                    {
                        $copyModule = $false
                    }
                    elseif ($moduleCheck -and ($false -eq $versionCheck))
                    {
                        $destinationVersion = Get-Childitem "$destinationPath\$($Module.name)" -Depth 0
                        Write-Host -ForegroundColor DarkYellow "    $($Module.name) found with version mismatch."
                        Write-Host -ForegroundColor DarkYellow "    Required verion - $moduleVersion."
                        Write-Host -ForegroundColor DarkYellow "    Installed version - $destinationVersion."
                        Write-Host -ForegroundColor DarkYellow "    Removing $($Module.name) from $Machine.`t`t" -NoNewLine
                        Remove-Item $destinationModulePath\$module.name -Confirm:$false -Recurse -Force
                        Write-Host -ForegroundColor DarkYellow "    ...Done."
                        $copyModule = $true
                    }
                }

                if ($completedChecks -eq 3)
                {
                    $copyModule = $true
                }

                if ($copyModule)
                {
                    Write-Host -ForegroundColor DarkYellow -nonewline "    Transfering $($Module.name) to $Machine."
                    Copy-Item -Path $Module.Fullname -Destination $destinationPath -Container -Recurse
                    Write-Host -ForegroundColor Green "      ...Done."
                }
                else {
                    Write-Host -ForegroundColor Green "     ...Done."
                }
            }
        }
        Else
        {
            Write-Host -ForegroundColor Red "MODULE VALIDATION: There was an issue connecting to $machine to transfer the required modules."
            Write-Host -ForegroundColor Red "MODULE VALIDATION: Source Module Repository - $ModulePath"
            Write-Host -ForegroundColor Red "MODULE VALIDATION: Destination module repository - $destinationPath"
        }
    }
}