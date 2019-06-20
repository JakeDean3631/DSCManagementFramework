Function Generate-ManualCheckData {
    [cmdletbinding()]
    param(

        [Parameter()]
        [string]
        $RootPath = (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent)
    )

    $xccdfPath = "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\ChecklistData"
    $stigTypePaths = Get-ChildItem -Path $xccdfPath -Depth 0 -Directory
    
    Foreach ( $TypePath in $stigTypePaths )
    {
        $xccdfFiles = Get-Childitem -Path "$TypePath\*xccdf.xml"
        
        foreach ( $file in $xccdfFiles )
        {
            $stigType = $file.basename.split("_")[2]
        }
    }
    Get-ChildItem -Path "$xccdfPath\*xccdf.xml"
    $xccdfBenchmarkContent = Get-StigXccdfBenchmarkContent -Path $xccdfPath
    $manualCheckPath = "$rootPath\5. Resources\STIG Data\Manual Checks"

    foreach ( $vulnerability in (Get-VulnerabilityList -XccdfBenchmark $xccdfBenchmarkContent) )
    {
        foreach ($attribute in $vulnerability.GetEnumerator())
        {
            if ($attribute.Name -eq 'Vuln_Num')
            {
                $VulID = $attribute.Value
            }
            elseif ($attribute.name -eq 'Rule_ID')
            {
                $ruleID = $attribute.value
            }
            elseif ($attribute.name -eq 'Rule_Title')
            {
                $ruleTitle = $attribute.value
            }
            elseif ($attribute.name -eq 'Fix_Text')
            {
                $Fixtext = $attribute.value
            }

            Foreach ( $file in $VulFiles ) {
                $Vulnerabilities = @(Get-Content $file.FullName)

                [array]$Psd1FileContent = ""
                Foreach ( $VulID in $Vulnerabilities)
                {
                    $Psd1FileContent += "@{"
                    $Psd1FileContent += "`tVulID        = `'$vulID`'"
                    $Psd1FileContent += "`tStatus       = `'Not A Finding`'"
                    $Psd1FileContent += "`tComments     = `'This is a Test`'"
                    $Psd1FileContent += "`tRule_Title   = `'$ruleTitle`'"
                    $Psd1FileContent += "`tRule_ID      = `'$ruleID`'"
                    $Psd1FileContent += "`tFix_Text     = `'$fixText`'"
                    $Psd1FileContent += "}`n"
                }
                $psd1FileContent | Out-File "$manualCheckPath\$($file.basename).psd1" -Force
            }
        }
    }
}

# $stigFiles = Get-Childitem -path "C:\Users\SVCDE05CM01\Desktop\DSC-Gallery\5. Resources\STIG Data\ChecklistData" -name "*.xml" -Recurse
# Foreach ( $file in $stigfiles ) 
# {
#     $newname = $file.basename.replace("U_","")
#     $newname = $newname.replace("MS_","")
    
# }

# Vuln_Num                   V-1070
# Severity                   medium
# Group_Title                Physical security
# Rule_ID                    SV-52838r1_rule
# Rule_Ver                   WN12-00-000001
# Rule_Title                 Server systems must be located in a controlled access area, accessible only to authorized personnel.
# Vuln_Discuss               Inadequate physical protection can undermine all other security precautions utilized to protect the system.  This can jeopardize the confidentiality, availability, and integrity of the system.  Physical security is the first line of protection...
# IA_Controls
# Check_Content              Verify servers are located in controlled access areas that are accessible only to authorized personnel.  If systems are not adequately protected, this is a finding.
# Fix_Text                   Ensure servers are located in secure, access-controlled areas.
# False_Positives
# False_Negatives
# Documentable               false
# Mitigations
# Potential_Impact
# Third_Party_Tools
# Mitigation_Control
# Responsibility
# Security_Override_Guidance
# Check_Content_Ref          DPMS_XCCDF_Benchmark_Windows_2012_MS_STIG.xml
# Weight                     10.0
# Class                      Unclass
# STIGRef                    Windows Server 2012/2012 R2 Member Server Security Technical Implementation Guide :: Release: 15 Benchmark Date: 26 Apr 2019
# TargetKey                  2350
# CCI_REF                    CCI-000366