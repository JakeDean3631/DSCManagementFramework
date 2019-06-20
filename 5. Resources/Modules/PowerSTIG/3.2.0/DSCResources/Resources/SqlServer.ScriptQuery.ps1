# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

$rules = $stig.RuleList | Select-Rule -Type SqlScriptQueryRule

foreach ($instance in $ServerInstance)
{
    if ($null -ne $Database)
    {
        foreach ($db in $Database)
        {
            foreach ( $rule in $rules )
            {
                SqlScriptQuery "$(Get-ResourceTitle -Rule $rule)$instance"
                {
                    ServerInstance = $Instance
                    GetQuery       = $rule.GetScript
                    TestQuery      = $rule.TestScript
                    SetQuery       = $rule.SetScript
                    Variable       = "Database=$db"
                }
            }
        }
    }
    else
    {
        foreach ($rule in $rules)
        {
            SqlScriptQuery "$(Get-ResourceTitle -Rule $rule)$instance"
            {
                ServerInstance = $instance
                GetQuery       = $rule.GetScript
                TestQuery      = $rule.TestScript
                SetQuery       = $rule.SetScript
            }
        }
    }
}
