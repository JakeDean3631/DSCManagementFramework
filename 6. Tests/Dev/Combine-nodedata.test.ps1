$ConfigurationFilesPath = "C:\DSC\DSC-Gallery\1. NodeData"

[array]$configurationFiles = Get-ChildItem -Path $ConfigurationFilesPath -Recurse | Where-Object { $_.Fullname -notmatch "Staging" }
$configurationDataPath = "$executionPath\4. Artifacts\configurationData.psd1"


Describe "Combined PS1 File" {

    Context {
        Mock New-Item -ItemType File -Path $configurationDataPath -Force | Out-Null 

        It "Should generate a combined ps1 file" {
            ( Test-path $configurationDataPath ) | Should Be $True
        }
    }
}