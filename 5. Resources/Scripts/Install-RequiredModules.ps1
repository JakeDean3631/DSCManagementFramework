$RequiredModules = @(
    @{ModuleName = 'PowerSTIG';                     ModuleVersion = '2.3.2.0'}
    @{ModuleName = 'AuditPolicyDsc';                ModuleVersion = '1.2.0.0'},
    @{ModuleName = 'AccessControlDsc';              ModuleVersion = '1.1.0.0'},
    @{ModuleName = 'FileContentDsc';                ModuleVersion = '1.1.0.108'},
    @{ModuleName = 'PolicyFileEditor';              ModuleVersion = '3.0.1'},
    @{ModuleName = 'SecurityPolicyDsc';             ModuleVersion = '2.4.0.0'},
    @{ModuleName = 'SqlServerDsc';                  ModuleVersion = '11.4.0.0'},
    @{ModuleName = 'WindowsDefenderDsc';            ModuleVersion = '1.0.0.0'},
    @{ModuleName = 'xDnsServer';                    ModuleVersion = '1.11.0.0'},
    @{ModuleName = 'xPSDesiredStateConfiguration';  ModuleVersion = '8.3.0.0'},
    @{ModuleName = 'xWebAdministration';            ModuleVersion = '2.3.0.0'},
    @{ModuleName = 'xWinEventLog';                  ModuleVersion = '1.2.0.0'}
)
$RequiredModules = @(
    @{ModuleName = 'PowerSTIG';                     ModuleVersion = '2.3.2.0'}
    @{ModuleName = 'AuditPolicyDsc';                ModuleVersion = '1.2.0.0'},
    @{ModuleName = 'AccessControlDsc';              ModuleVersion = '1.1.0.0'},
    @{ModuleName = 'FileContentDsc';                ModuleVersion = '1.1.0.108'},
    @{ModuleName = 'PolicyFileEditor';              ModuleVersion = '3.0.1'},
    @{ModuleName = 'SecurityPolicyDsc';             ModuleVersion = '2.4.0.0'},
    @{ModuleName = 'SqlServerDsc';                  ModuleVersion = '11.4.0.0'},
    @{ModuleName = 'WindowsDefenderDsc';            ModuleVersion = '1.0.0.0'},
    @{ModuleName = 'xDnsServer';                    ModuleVersion = '1.11.0.0'},
    @{ModuleName = 'xPSDesiredStateConfiguration';  ModuleVersion = '8.3.0.0'},
    @{ModuleName = 'xWebAdministration';            ModuleVersion = '2.3.0.0'},
    @{ModuleName = 'xWinEventLog';                  ModuleVersion = '1.2.0.0'}
)
$InstalledModules = @( Get-Module -Listavailable )

Foreach ($Module in $RequiredModules ) {
        
    $ModuleMatch = $InstalledModules | Where-Object { $_.name -like "$($module.modulename)" }
        
    If ( ($ModuleMatch.name -like "$($module.modulename)" ) -and ( $ModuleMatch.version -like "$($Module.Moduleversion)") ) {
        Write-Host -ForegroundColor Green "$($Module.Modulename) Version $($Module.ModuleVersion) is already installed."
    }
    Elseif ( ($ModuleMatch.name -like "$($module.moduleName)" ) -and ( $Modulematch.version -ne "$($Module.Moduleversion)" ) ) {
        Write-Host "$Module is installed, but is not the correct version. Installing version $($Module.Moduleversion)"
        Uninstall-Module $ModuleMatch.name -Verbose
        Install-Module -name $Module.name -RequiredVersion $Module.ModuleVersion -Verbose
    }    
    Elseif ($Null -eq $ModuleMatch) {
        Write-Host "$($Module.Modulename) is not installed. Attempting to install..."
        Install-Module -Name $Module.Modulename -RequiredVersion $Module.Moduleversion -verbose  
    }
}
