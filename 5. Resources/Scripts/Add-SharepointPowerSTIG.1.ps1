$LCMContent = @'
    

        PowerSTIG_Sharepoint = @{
            SqlVersion     = "2012"
            SqlRole        = "Instance"
            StigVersion    = "1.7"
            ServerInstance = ""
        }

'@
$Configdata = Get-Childitem .\ServerConfigurationData\*.psd1 -Recurse

Foreach ( $Server in $Configdata ) {
    $ConfigContent = Get-Content $Server
    $ConfigContent[2] += $LCMContent
    $ConfigContent | Set-Content $Server
}