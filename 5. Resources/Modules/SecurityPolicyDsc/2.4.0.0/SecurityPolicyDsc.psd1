#
# Module manifest for module 'SecurityPolicyDsc'
#
# Generated by: Jason Walker
#
# Generated on: 12/29/2015
#

@{

# Version number of this module.
moduleVersion = '2.4.0.0'

# ID used to uniquely identify this module
GUID = 'e2b73194-69ef-4fa6-b949-9f62ebe04989'

# Author of this module
Author = 'Microsoft Corporation'

# Company or vendor of this module
CompanyName = 'Microsoft Corporation'

# Copyright statement for this module
Copyright = '(c) 2016 Microsoft. All rights reserved.'

# Description of the functionality provided by this module
Description = 'This module is a wrapper around secedit.exe which provides the ability to configure user rights assignments'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '4.0'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('DesiredStateConfiguration', 'DSC', 'DSCResourceKit', 'DSCResource', 'Secedit','SecurityPolicyDsc')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/PowerShell/SecurityPolicyDsc/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/PowerShell/SecurityPolicyDsc'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = '* Added additional error handling to ConvertTo-Sid helper function.

'

    } # End of PSData hashtable

} # End of PrivateData hashtable

}










