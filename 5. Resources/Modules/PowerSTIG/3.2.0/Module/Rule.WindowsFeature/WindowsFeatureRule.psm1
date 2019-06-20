# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
using module .\..\Common\Common.psm1
using module .\..\Rule\Rule.psm1
#header

<#
    .SYNOPSIS
        An Account Policy Rule object
    .DESCRIPTION
        The WindowsFeatureRule class is used to maange the Account Policy Settings.
    .PARAMETER FeatureName
        The windows feature name
    .PARAMETER InstallState
        The state the windows feature should be in
#>
Class WindowsFeatureRule : Rule
{
    [string] $FeatureName
    [string] $InstallState <#(ExceptionValue)#>

    <#
        .SYNOPSIS
            Default constructor to support the AsRule cast method
    #>
    WindowsFeatureRule ()
    {
    }

    <#
        .SYNOPSIS
            Used to load PowerSTIG data from the processed data directory
        .PARAMETER Rule
            The STIG rule to load
    #>
    WindowsFeatureRule ([xml.xmlelement] $Rule) : Base ($Rule)
    {
    }

    <#
        .SYNOPSIS
            The Convert child class constructor
        .PARAMETER Rule
            The STIG rule to convert
        .PARAMETER Convert
            A simple bool flag to create a unique constructor signature
    #>
    WindowsFeatureRule ([xml.xmlelement] $Rule, [switch] $Convert) : Base ($Rule, $Convert)
    {
    }

    <#
        .SYNOPSIS
            Creates class specifc help content
    #>
    [PSObject] GetExceptionHelp()
    {
        if ($this.InstallState -eq 'Present')
        {
            $thisInstallState = 'Absent'
        }
        else
        {
            $thisInstallState = 'Present'
        }

        return @{
            Value = $thisInstallState
            Notes = "'Present' and 'Absent' are the only valid values."
        }
    }
}
