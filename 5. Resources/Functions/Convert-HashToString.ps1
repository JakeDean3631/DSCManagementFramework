function Convert-HashToString
{
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Hash,

        [Parameter()]
        [bool]
        $Recurse
    )

    $sb = [System.Text.StringBuilder]::new("@{`n")

    $keys = $Hash.keys
    foreach ($key in $keys)
    {
        $recurse = $false
        
        $value = $Hash[$key]

        if($value.GetType().Name -eq 'Hashtable')
        {
            $recurse = $true
            $value = Convert-HashToString -Hash $value -Recurse $Recurse
        }

        if($recurse)
        {
            [void]$sb.AppendLine("`t'$key' = $value")
        }
        else
        {
            [void]$sb.AppendLine("`t`t'$key' = '$value'")
        }
    }

    # Close the Hashtable
    if($recurse)
    {
        [void]$sb.Append("}")
    }
    else
    {
        [void]$sb.Append("`t}")
    }

    return $sb.ToString()
}