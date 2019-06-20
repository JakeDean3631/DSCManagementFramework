<#
.SYNOPSIS
    Checks for and installs Visual Studio Code, the PowerShell and VSTS extensions, 
    GIT, Powershell 5.1, and WMF 5.1. 
.DESCRIPTION
    This script can be used to easily configure a machine for code development with
    Visual Studio code. 
.NOTES
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>
[CmdletBinding()]
param(
    [parameter()]
    [ValidateSet(,"64-bit","32-bit")]
    [string]$Architecture = "64-bit",

    [parameter()]
    [ValidateSet("stable","insider")]
    [string]$BuildEdition = "stable",

    [Parameter()]
    [ValidateNotNull()]
    [string[]]$AdditionalExtensions = @(),

    [switch]$LaunchWhenDone
)

#Region Install VS Code

if (($PSVersionTable.PSVersion.Major -le 5) -or $IsWindows) {
    switch ($Architecture) {
        "64-bit" {
            if ((Get-CimInstance -ClassName Win32_OperatingSystem).OSArchitecture -eq "64-bit") {
                $codePath = $env:ProgramFiles
                $bitVersion = "win32-x64"
            }
            else {
                $codePath = $env:ProgramFiles
                $bitVersion = "win32"
                $Architecture = "32-bit"
            }
            break;
        }
        "32-bit" {
            if ((Get-CimInstance -ClassName Win32_OperatingSystem).OSArchitecture -eq "32-bit"){
                $codePath = $env:ProgramFiles
                $bitVersion = "win32"
            }
            else {
                $codePath = ${env:ProgramFiles(x86)}
                $bitVersion = "win32"
            }
            break;
        }
    }
    switch ($BuildEdition) {
        "Stable" {
            $codeCmdPath = "$codePath\Microsoft VS Code\bin\code.cmd"
            $appName = "Visual Studio Code ($($Architecture))"
            break;
        }
        "Insider" {
            $codeCmdPath = "$codePath\Microsoft VS Code Insiders\bin\code-insiders.cmd"
            $appName = "Visual Studio Code - Insiders Edition ($($Architecture))"
            break;
        }
    }
    try {
        $ProgressPreference = 'SilentlyContinue'

        if (!(Test-Path $codeCmdPath)) {
            Write-Host "Downloading latest $appName..." -ForegroundColor Yellow
            Remove-Item -Force "$env:TEMP\vscode-$($BuildEdition).exe" -ErrorAction SilentlyContinue
            Invoke-WebRequest -Uri "https://vscode-update.azurewebsites.net/latest/$($bitVersion)/$($BuildEdition)" -OutFile "$env:TEMP\vscode-$($BuildEdition).exe"

            Write-Host "Installing $appName..." -ForegroundColor Yellow
            Start-Process -Wait "$env:TEMP\vscode-$($BuildEdition).exe" -ArgumentList /silent, /mergetasks=!runcode
        }
        else {
            Write-Host "$appName is already installed." -ForegroundColor Yellow
        }

        $extensions = @("ms-vscode.PowerShell") + ("ms-vsts.team") + $AdditionalExtensions
        foreach ($extension in $extensions) {
            Write-Host "Installing extension $extension..." -ForegroundColor Yellow
            & $codeCmdPath --install-extension $extension
        }

        if ($LaunchWhenDone) {
            Write-Host "$Extension Installation complete, starting $appName..." -ForegroundColor Green
            & $codeCmdPath
        }
        else {
            Write-Host "VSTS Installation complete!" -ForegroundColor Green
        }
    }
    finally {
        $ProgressPreference = 'Continue'
    }
}
else {
    Write-Error "This script is currently only supported on the Windows operating system."
}

#Install Git

if (!($IsLinux -or $IsOSX))
{

    $gitExePath = "C:\Program Files\Git\bin\git.exe"

    #Added TLS negotiation Fork jmangan68
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

    foreach ($asset in (Invoke-RestMethod https://api.github.com/repos/git-for-windows/git/releases/latest).assets)
    {
        if ($asset.name -match 'Git-\d*\.\d*\.\d*.\d*-64-bit\.exe')
        {
            $dlurl = $asset.browser_download_url
            $newver = $asset.name
        }
    }

    try
    {
        $ProgressPreference = 'SilentlyContinue'

        if (!(Test-Path $gitExePath))
        {
            Write-Host "Downloading latest stable git..." -ForegroundColor Yellow
            Remove-Item -Force $env:TEMP\git-stable.exe -ErrorAction SilentlyContinue
            Invoke-WebRequest -Uri $dlurl -OutFile $env:TEMP\git-stable.exe

            Write-Host "Installing git..." -ForegroundColor Yellow
            Start-Process -Wait $env:TEMP\git-stable.exe -ArgumentList /silent
        }
        else
        {
            $updateneeded = $false
            Write-Host "git is already installed. Check if possible update..." -ForegroundColor Yellow
            (git version) -match "(\d*\.\d*\.\d*)" | Out-Null
            $installedversion = $matches[0].split('.')
            $newver -match "(\d*\.\d*\.\d*)" | Out-Null
            $newversion = $matches[0].split('.')

            if (($newversion[0] -gt $installedversion[0]) -or ($newversion[0] -eq $installedversion[0] -and $newversion[1] -gt $installedversion[1]) -or ($newversion[0] -eq $installedversion[0] -and $newversion[1] -eq $installedversion[1] -and $newversion[2] -gt $installedversion[2]))
            {
                $updateneeded = $true
            }

            if ($updateneeded)
            {

                Write-Host "Update available. Downloading latest stable git..." -ForegroundColor Yellow
                Remove-Item -Force $env:TEMP\git-stable.exe -ErrorAction SilentlyContinue
                Invoke-WebRequest -Uri $dlurl -OutFile $env:TEMP\git-stable.exe

                Write-Host "Installing update..." -ForegroundColor Yellow
                $sshagentrunning = get-process ssh-agent -ErrorAction SilentlyContinue
                if ($sshagentrunning)
                {
                    Write-Host "Killing ssh-agent..." -ForegroundColor Yellow
                    Stop-Process $sshagentrunning.Id
                }

                Start-Process -Wait $env:TEMP\git-stable.exe -ArgumentList /silent
            }
            else
            {
                Write-Host "No update available. Already running latest version..." -ForegroundColor Yellow
            }

        }
        Write-Host "GIT Installation complete!" -ForegroundColor Green
    }
    finally
    {
        $ProgressPreference = 'Continue'
    }
}
else
{
    Write-Error "This script is currently only supported on the Windows operating system."
}

$tmp_dir = $env:temp
if (-not (Test-Path -Path $tmp_dir)) {
    New-Item -Path $tmp_dir -ItemType Directory > $null
}
Function Reboot-AndResume {
    Write-Host -ForegroundColor "Yellow" "adding script to run on next logon"
    $script_path = $script:MyInvocation.MyCommand.Path
    $ps_path = "$env:SystemDrive\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    $arguments = "-version $version"
    $command = "$ps_path -ExecutionPolicy ByPass -File $script_path $arguments"
    $reg_key = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
    $reg_property_name = "ps-upgrade"
    Set-ItemProperty -Path $reg_key -Name $reg_property_name -Value $command

    Write-Host -ForegroundColor "Yellow" "Workstaion/Server requires a reboot to continue powershell upgrade."
    $reboot_confirmation = Read-Host -Prompt "Workstaion/Server requires a reboot to continue powershell upgrade. Reboot now? (y/n)"
    if ($reboot_confirmation -ne "y") {
        $error_msg = "Please reboot Workstation/Server manually and login to continue upgrade process, the script will restart on the next login automatically"
        Write-Host -ForegroundColor "red"$error_msg -level "ERROR"
        throw $error_msg
    }Else {
        if (Get-Command -Name Restart-Computer -ErrorAction SilentlyContinue) {
            Restart-Computer -Force
        } else {
        # PS v1 (Server 2008) doesn't have the cmdlet Restart-Computer, use el-traditional
        shutdown /r /t 0
        }
    }
}
Function Run-Process($executable, $arguments) {
    $process = New-Object -TypeName System.Diagnostics.Process
    $psi = $process.StartInfo
    $psi.FileName = $executable
    $psi.Arguments = $arguments
    Write-Host -ForegroundColor "Yellow" "starting new process '$executable $arguments'"
    $process.Start() | Out-Null
    
    $process.WaitForExit() | Out-Null
    $exit_code = $process.ExitCode
    Write-Host -ForegroundColor "Yellow" "process completed with exit code '$exit_code'"

    return $exit_code
}

Function Download-File($url, $path) {
    Write-Host -ForegroundColor "Yellow" "downloading url '$url' to '$path'"
    $client = New-Object -TypeName System.Net.WebClient
    $client.DownloadFile($url, $path)
}

Function Download-Wmf5Server2008($architecture) {
    if ($architecture -eq "x64") {
        $zip_url = "http://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip"
        $file = "$tmp_dir\Win7AndW2K8R2-KB3191566-x64.msu"
    } else {
        $zip_url = "http://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7-KB3191566-x86.zip"
        $file = "$tmp_dir\Win7-KB3191566-x86.msu"
    }
    if (Test-Path -Path $file) {
        return $file
    }

    $filename = $zip_url.Split("/")[-1]
    $zip_file = "$tmp_dir\$filename"
    Download-File -url $zip_url -path $zip_file

    Write-Host -ForegroundColor "Yellow" "extracting '$zip_file' to '$tmp_dir'"
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem > $null
        $legacy = $false
    } catch {
        $legacy = $true
    }

    if ($legacy) {
        $shell = New-Object -ComObject Shell.Application
        $zip_src = $shell.NameSpace($zip_file)
        $zip_dest = $shell.NameSpace($tmp_dir)
        $zip_dest.CopyHere($zip_src.Items(), 1044)
    } else {
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zip_file, $tmp_dir)
    }

    return $file
}

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

# Install Powershell modules
