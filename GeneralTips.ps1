# List all properties on an object
X | Format-List -Property *

# Make anything an array by wrapping it in `@(X)`
@("Just one thing") # is an array of that one string

# Get the length of an array piped (vs. `(X | Y).Length`)
 | Measure-Object # Returns an object, though, with a Count property
 | Measure-Object | % { $_.Count } # Bit of a hack, but single item arrays will output the only item as a string

## Get list of numbers to pass/pipe to something else
[System.Linq.Enumerable]::Range(0,40)

## String of length `i`, composed of `a`s (mostly just calling `new string('a', i)`)
New-Object string -ArgumentList @('a', i)

## Create file with variable name of `x`
New-Item x -Type file
