
$Version = "5.1"
Write-Host -foregroundcolor "Yellow" "Beginning Windows Management Framework Installation"
# on PS v1.0, upgrade to 2.0 and then run the script again
if ($PSVersionTable -eq $null) {
    Write-Host -ForegroundColor "Yellow" "upgrading powershell v1.0 to v2.0"
    $architecture = $env:PROCESSOR_ARCHITECTURE
    if ($architecture -eq "AMD64") {
        $url = "https://download.microsoft.com/download/2/8/6/28686477-3242-4E96-9009-30B16BED89AF/Windows6.0-KB968930-x64.msu"
    } else {
        $url = "https://download.microsoft.com/download/F/9/E/F9EF6ACB-2BA8-4845-9C10-85FC4A69B207/Windows6.0-KB968930-x86.msu"
    }
    $filename = $url.Split("/")[-1]
    $file = "$tmp_dir\$filename"
    Download-File -url $url -path $file
    $exit_code = Run-Process -executable $file -arguments "/quiet /norestart"
    if ($exit_code -ne 0 -and $exit_code -ne 3010) {
        $error_msg = "failed to update Powershell from 1.0 to 2.0: exit code $exit_code"
        Write-Host -ForegroundColor "Red"$error_msg -level "ERROR"
        throw $error_msg
    }
    Reboot-AndResume
}

# exit if the target version is the same as the actual version
$current_ps_version = [version]"$($PSVersionTable.PSVersion.Major).$($PSVersionTable.PSVersion.Minor)"
if ($current_ps_version -eq [version]$version) {
    Write-Host -ForegroundColor "Green" "Windows Management Framework $version is already installed, no action is required"
    exit 0
}

$os_version = [System.Environment]::OSVersion.Version
$architecture = $env:PROCESSOR_ARCHITECTURE
if ($architecture -eq "AMD64") {
    $architecture = "x64"
} else {
    $architecture = "x86"
}

$actions = @()
switch ($version) {
    "3.0" {
        $actions += "3.0"
        break
    }
    "4.0" {
        if ($os_version -lt [version]"6.1") {
            $error_msg = "cannot upgrade Server 2008 to Powershell v4, v3 is the latest supported"
            Write-Host -ForegroundColor "Red"$error_msg -level "ERROR"
            throw $error_msg
        }
        $actions += "4.0"
        break
    }
    "5.1" {
        if ($os_version -lt [version]"6.1") {
            $error_msg = "cannot upgrade Server 2008 to Powershell v5.1, v3 is the latest supported"
            Write-Host -ForegroundColor "Red"$error_msg -level "ERROR"
            throw $error_msg
        }
        # check if WMF 3 is installed, need to be uninstalled before 5.1
        if ($os_version.Minor -lt 2) {
            $wmf3_installed = Get-Hotfix -Id "KB2506143" -ErrorAction SilentlyContinue
            if ($wmf3_installed) {
                $actions += "remove-3.0"
            }
        }
        $actions += "5.1"
        break
    }
    default {
        $error_msg = "version '$version' is not supported in this upgrade script"
        Write-Host -ForegroundColor "Red"$error_msg -level "ERROR"
        throw $error_msg
    }
}

# detect if .NET 4.5.2 is not installed and add to the actions
$dotnet_path = "HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full"
if (-not (Test-Path -Path $dotnet_path)) {
    $dotnet_upgrade_needed = $true
} else {
    $dotnet_version = Get-ItemProperty -Path $dotnet_path -Name Release -ErrorAction SilentlyContinue
    if ($dotnet_version) {
        # 379893 == 4.5.2
        if ($dotnet_version.Release -lt 379893) {
            $dotnet_upgrade_needed = $true
        }        
    } else {
        $dotnet_upgrade_needed = $true
    }
}
if ($dotnet_upgrade_needed) {
    $actions = @("dotnet") + $actions
}

Write-Host -ForegroundColor "Yellow" "The following actions will be performed: $($actions -join ", ")"
foreach ($action in $actions) {
    $url = $null
    $file = $null
    $arguments = "/quiet /norestart"

    switch ($action) {
        "dotnet" {
            Write-Host -ForegroundColor "Yellow" "running .NET update to 4.5.2"
            $url = "https://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
            $error_msg = "failed to update .NET to 4.5.2"
            $arguments = "/q /norestart"
            break
        }
        "remove-3.0" {
            # this is only run before a 5.1 install on Windows 7/2008 R2, the
            # install zip needs to be downloaded and extracted before
            # removing 3.0 as then the FileSystem assembly cannot be loaded
            Write-Host -ForegroundColor "Yellow" "downloading WMF/PS v5.1 and removing WMF/PS v3 before version 5.1 install"
            Download-Wmf5Server2008 -architecture $architecture > $null

            $file = "wusa.exe"
            $arguments = "/uninstall /KB:2506143 /quiet /norestart"
            break
        }
        "3.0" {
            Write-Host -ForegroundColor "Yellow" "running powershell update to version 3"    
            if ($os_version.Minor -eq 1) {
                $url = "https://download.microsoft.com/download/E/7/6/E76850B8-DA6E-4FF5-8CCE-A24FC513FD16/Windows6.1-KB2506143-$($architecture).msu"
            } else {
                $url = "https://download.microsoft.com/download/E/7/6/E76850B8-DA6E-4FF5-8CCE-A24FC513FD16/Windows6.0-KB2506146-$($architecture).msu"
            }
            $error_msg = "failed to update Powershell to version 3"
            break
        }
        "4.0" {
            Write-Host -ForegroundColor "Yellow" "running powershell update to version 4"
            if ($os_version.Minor -eq 1) {
                $url = "https://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows6.1-KB2819745-$($architecture)-MultiPkg.msu"
            } else {
                $url = "https://download.microsoft.com/download/3/D/6/3D61D262-8549-4769-A660-230B67E15B25/Windows8-RT-KB2799888-x64.msu"
            }
            $error_msg = "failed to update Powershell to version 4"
            break
        }
        "5.1" {
            Write-Host -ForegroundColor "Yellow" "running powershell update to version 5.1"
            if ($os_version.Minor -eq 1) {
                # Server 2008 R2 and Windows 7, already downloaded in remove-3.0
                $file = Download-Wmf5Server2008 -architecture $architecture
            } elseif ($os_version.Minor -eq 2) {
                # Server 2012
                $url = "http://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/W2K12-KB3191565-x64.msu"
            } else {
                # Server 2012 R2 and Windows 8.1
                if ($architecture -eq "x64") {
                    $url = "http://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1AndW2K12R2-KB3191564-x64.msu"
                } else {
                    $url = "http://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1-KB3191564-x86.msu"
                }
            }
            break
        }
        default {
            $error_msg = "unknown action '$action'"
            Write-Host -ForegroundColor "Red"$error_msg -level "ERROR"
        }
    }

    if ($file -eq $null) {
        $filename = $url.Split("/")[-1]
        $file = "$tmp_dir\$filename"
    }
    if ($url -ne $null) {
        Download-File -url $url -path $file
    }
    
    $exit_code = Run-Process -executable $file -arguments $arguments
    if ($exit_code -ne 0 -and $exit_code -ne 3010) {
        $log_msg = "$($error_msg): exit code $exit_code"
        Write-Host -ForegroundColor "Red"$log_msg -level "ERROR"
        throw $log_msg
    }
    if ($exit_code -eq 3010) {
        Reboot-AndResume
        break
    }
}