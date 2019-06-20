# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

$rules = $stig.RuleList | Select-Rule -Type WmiRule

foreach ( $rule in $rules )
{
    Script (Get-ResourceTitle -Rule $rule)
    {
        # Must return a hashtable with at least one key named 'Result' of type String
        GetScript = {
            Return @{
                'Result' = [string] $( ( Get-CimInstance -Query $using:rule.Query ).$( $using:rule.Property ) )
            }
        }

        # Must return a boolean: $true or $false
        TestScript = {
            $valueToTest = ( ( Get-CimInstance -Query $using:rule.Query ).$( $using:rule.Property ) )

            foreach ( $value in $valueToTest )
            {
                $wmiTest = [scriptBlock]::create("""$value"" $($using:rule.Operator) ""$($using:rule.Value)""")

                if ( -not ( & $wmiTest ) )
                {
                    Write-Verbose "$($using:rule.Property) -not $($using:rule.Operator) $($using:rule.Value)"
                    return $false
                }
            }

            Write-Verbose "$($using:rule.Property) $($using:rule.Operator) $($using:rule.Value)"
            return $true
        }

        <#
            This is left blank because we are only using the script resource as an audit tool for
            STIG items that should be part of an orchestration function and not configuration.
        #>
        SetScript = { }
    }
}
