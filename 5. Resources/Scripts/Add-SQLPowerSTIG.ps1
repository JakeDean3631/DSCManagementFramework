$Content = @'


        PowerSTIG_SQL = @{
            SqlVersion     = "2012"
            SqlRole        = "Instance"
            StigVersion    = "1.7"
            ServerInstance = ""
        }

'@
$Configdata = Get-Childitem ".\Staging\Sql Servers\*.psd1" -Recurse

Foreach ( $Server in $Configdata ) {
    $ConfigContent = Get-Content $Server
    $ConfigContent[29] += $LCMContent
    $ConfigContent | Set-Content $Server
}