# Creating a Hashtable manually
# NOTE: remember to use semicolon between key-value pairs rather than C#-style comma
$x = @{ a = "asdf"; b = 3 }

# If you want to verify this is a HashTable, you can use some .NET on it
$x.GetType().FullName
# Output: `System.Collections.Hashtable`

# If you are in a PowerShell command prompt, you can just run `$x` to get a pretty chart output of your hash keys and values (as `Name` and `Value` columns).
# If you want to output a hashtable as a nice display somewhere else, such as in some server environments where it normally tries to dump the type name, you can pass the hashtable to `Out-String`. That output is passed to whatever output is being used via `Write-Host`.
$x | Out-String | Write-Host

# You can get hashtable values through several syntaxes
$x["b"]
$x.b
$x.Item("b")
$keyName = "b"; $x[$keyName]
$keyName = "b"; $x.($keyName)
$keyName = "b"; $x.Item($keyName)

# NOTE: Haven't been able to find a way to access unusually-named hashtable keys via curly-brace syntax
# > $x = @{ a = "asdf"; b = 3; {funky-key} = "hello" }
# > $x.{funky-key}
# > $x[{funky-key}]
# > $x.({funky-key})
# > $x.("funky-key")
# > $x.Item("funky-key")
# None of these attempts resulted in the text set for the variable.
# But you can see the value set by dumping all of $x
# > $x
# Name                           Value
# ----                           -----
# b                              3
# funky-key                      hello
# a                              asdf

# Create a new arbitrary PSCustomObject from a hashtable
# Just convert it
$some_psobj = [pscustomobject]@{ a = "asdfasdf"; b = 4 }
# Use the PSObject constructor
$some_psobj = New-Object PSObject -Property @{ a = "asdfasdf"; b = 4 }

# Convert PSCustomObject/PSObject to a hashtable. Requires iterating over it and stuffing values into hashtable individually.
# Haven't found a proper one-liner for this (like the `@{ ... }` syntax for hashtable or a constructor that takes keys/values)
# Create an empty hashtable, stuff values into it
$some_hashtable = @{}; $some_psobj | Get-Member -MemberType *Property | % { $some_hashtable.($_.Name) = $some_psobj.($_.Name); }
