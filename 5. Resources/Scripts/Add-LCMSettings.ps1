$LCMContent = @'
    
    LocalConfigurationManager = @{
        ActionAfterReboot           = 'ContinueConfiguration'
        ConfigurationMode           = 'ApplyAndAutoCorrect'
        RebootNodeIfNeeded          = $False
        RefreshMode                 = 'Push'
        StatusRetentionTimeInDays   = '3'
    }

'@
$Configdata = Get-Childitem .\ServerConfigurationData\*.psd1 -Recurse

Foreach ( $Server in $Configdata ) {
    $ConfigContent = Get-Content $Server
    $ConfigContent[2] += $LCMContent
    $ConfigContent | Set-Content $Server
}