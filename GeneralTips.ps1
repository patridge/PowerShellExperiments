# List all properties on an object
X | Format-List -Property *

# Make anything an array by wrapping it in `@(X)`
@("Just one thing") # is an array of that one string

# Get the length of an array piped (vs. `(X | Y).Length`)
 | Measure-Object # Returns an object, though, with a Count property
 | Measure-Object | % { $_.Count } # Bit of a hack, but single item arrays will output the only item as a string

# Get list of numbers to pass/pipe to something else
[System.Linq.Enumerable]::Range(0,40)

# String of length `i`, composed of `a`s (mostly just calling `new string('a', i)`)
New-Object string -ArgumentList @('a', i)

# Limit to first/last/whatever X items from a previous command's enumerable
{some list} | Select-Object -First 1
{some list} | Select-Object -Last 1
{some list} | Select-Object -Skip 5 | Select-Object -First 1

# Access a field/property with an unusual name (e.g., contains a period or special characters in the field name itself)
# Wrap name in curly braces. (NOTE: This is not a placeholder like the `{some list}` usage above.)
$X.{Some.Property.With.Period}

# Line breaks in strings (\n or \r\n in C# and friends)
"First line`nSecond line"
"First line`r`nSecond line"