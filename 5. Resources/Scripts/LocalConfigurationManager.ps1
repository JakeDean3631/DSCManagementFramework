[DscLocalConfigurationManager()]
Configuration LocalConfigurationManager {
    
    param(
        [Parameter()]     
        [String]$ActionAfterReboot,
        [Parameter()]     
        [String]$AllowModuleOverWrite,
        [Parameter()]
        [String]$CertificateID,
        [Parameter()]     
        [String]$ConfigurationDownloadManagers,
        [Parameter()]     
        [String]$ConfigurationID,
        [Parameter()]     
        [String]$ConfigurationMode,
        [Parameter()]     
        [String]$ConfigurationModeFrequencyMins,
        [Parameter()]     
        [String]$DebugMode,
        [Parameter()]     
        [String]$StatusRetentionTimeInDays,
        [Parameter()]     
        [String]$SignatureValidationPolicy,
        [Parameter()]     
        [String]$SignatureValidations,
        [Parameter()]     
        [String]$MaximumDownloadSizeMB,
        [Parameter()]     
        [String]$PartialConfigurations,
        [Parameter()]     
        [String]$RebootNodeIfNeeded,
        [Parameter()]     
        [String]$RefreshFrequencyMins,
        [Parameter()]     
        [String]$RefreshMode,
        [Parameter()]     
        [String]$ReportManagers,
        [Parameter()]     
        [String]$ResourceModuleManagers,
        [Parameter()]     
        [String]$PSComputerName
    )

    Settings {
        ActionAfterReboot               = $ActionAfterReboot
        AllowModuleOverWrite            = $AllowModuleOverWrite
        CertificateID                   = $CertificateID
        ConfigurationDownloadManagers   = $ConfigurationDownloadManagers
        ConfigurationID                 = $ConfigurationID
        ConfigurationMode               = $ConfigurationMode 
        ConfigurationModeFrequencyMins  = $ConfigurationModeFrequencyMins 
        DebugMode                       = $DebugMode 
        StatusRetentionTimeInDays       = $StatusRetentionTimeInDays 
        SignatureValidationPolicy       = $SignatureValidationPolicy 
        SignatureValidations            = $SignatureValidations 
        MaximumDownloadSizeMB           = $MaximumDownloadSizeMB 
        PartialConfigurations           = $PartialConfigurations 
        RebootNodeIfNeeded              = $RebootNodeIfNeeded 
        RefreshFrequencyMins            = $RefreshFrequencyMins 
        RefreshMode                     = $RefreshMode 
        ReportManagers                  = $ReportManagers 
        ResourceModuleManagers          = $ResourceModuleManagers 
    }
}
