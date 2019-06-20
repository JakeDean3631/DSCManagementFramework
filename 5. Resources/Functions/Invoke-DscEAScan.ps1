Function Invoke-DscEAScan {
    [cmdletbinding()]
    param(

        [Parameter()]
        [string]
        $RootPath = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery",

        [Parameter()]
        [int]
        $ReportThreshhold = 30

    )

    $DateStamp          = (Get-Date -format "MM-dd-yyyy hhmmss")
    $reportsPath        = Resolve-Path -Path "$RootPath\*Reports"
    $nodeDataPath       = Resolve-Path -Path "$RootPath\*NodeData"
    $archivePath        = Resolve-Path -Path "$RootPath\*Archive"
    $mofPath            = Resolve-Path -Path "$RootPath\*Mofs"

    #Report Filenames
    $xmlFileName        = "DSCEA Results - $DateStamp.xml"
    $htmlFileName       = "DSCEA Results - $DateStamp.html"
    $csvFileName        = "DSCEA Results - $DateStamp.csv"

    #Report SubFolders
    $xmlPath            = "$reportsPath\XML Reports"
    $csvPath            = "$reportsPath\CSV Reports"
    $detailedReportPath = "$reportsPath\Detailed Reports"

    #Execute Scan
    $params = @{
    Path                = $mofPath
    ResultsFile         = $xmlFileName
    OutputPath          = $XmlPath
    }
    Start-DSCEAScan @params

    #Generate Xml
    $params = @{
        InputXml    = "$xmlPath\$xmlFileName"
        OutFile     = "$csvPath\$csvFileName"
    }
    Convert-DsceaResultsToCsv @params

    #Generate HTML Report
    $params = @{
        OutPath     = $DetailedReportPath
        InFile      = "$xmlPath\$xmlFileName"
        Detailed    = $true
    }
    Get-DSCEAreport @params

    #Delete old reports
    $xmlReports = Get-ChildItem $xmlPath
    $CSVReports = Get-ChildItem $csvPath
    $DSCEAReports = Get-ChildItem $detaledReportPath

    if ($xmlreports.count -gt $reportThreshhold)
    {
        $XMLReports | Sort-Object LastWriteTime -Descending | Select-Object -Last ($xmlreports.count - $reportThreshhold) | Remove-Item
    }


    if ($DSCEAReports.count -gt $reportThreshhold)
    {
        $DSCEAReports | Sort-Object LastWriteTime -Descending | Select-Object -Last ($DSCEAReports.count - $reportThreshhold) | Remove-Item
    }


    if ($CSVReports.count -gt $reportThreshhold)
    {
        $CSVReports | Sort-Object LastWriteTime -Descending | Select-Object -Last ($CSVReports.count - $reportThreshhold) | Remove-Item
    }
}
