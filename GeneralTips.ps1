# List all properties on an object
X | Format-List -Property *

# Make anything an array by wrapping it in `@(X)`
@("Just one thing") # is an array of that one string

# Creating a Hashtable manually/declaritively (see also ConvertingToAndFromPSObjectAndHashtable.ps1)
# NOTE: remember to use semicolon between key-value pairs rather than C#-style comma
$x = @{ a = "asdf"; b = 3 }

# Get the length of an array piped (vs. `(X | Y).Length`)
 | Measure-Object # Returns an object, though, with a Count property
 | Measure-Object | % { $_.Count } # Bit of a hack, but single item arrays will output the only item as a string

# Get list of numbers to pass/pipe to something else
[System.Linq.Enumerable]::Range(0,40)

# String of length `i`, composed of `a`s (mostly just calling `new string('a', i)`)
New-Object string -ArgumentList @('a', i)

# Limit to first[/top]/last/whatever X items from a previous command's enumerable
{some list} | Select-Object -First 1
{some list} | Select-Object -Last 1
{some list} | Select-Object -Skip 5 | Select-Object -First 1

# Find object in list by regex-like search (e.g., name contains "something" to find files like "somethingcool.txt")?
# `-like` is a not-quite-regex wildcard syntax
{command} | ? { $_.Name -like "*{keyword}*" }
# `-match` uses a regex syntax
{command} | ? { $_.Name -match "{keyword}" }
{command} | ? { $_.Name -match "{keyword1}.*{keyword2}.*" }

# Access a field/property with an unusual name (e.g., contains a period or special characters in the field name itself)
# Wrap name in curly braces. (NOTE: This is not a placeholder like the `{some list}` usage above.)
$X.{Some.Property.With.Period}
# This can also apply to complex environment variable names.
${env:ProgramFiles(x86)}

# Build strings from variables.
# Basic
Write-Host "$someVar1: $someVar2"
# Complex variable names need curly braces (`${}`)
Write-Host "$someVar1: ${env:ProgramFiles(x86)}"
# Operations require parentheses (`$()`)
Write-Host "Current file path: $((Get-ChildItem GeneralTips.ps1).FullName)"

# Line breaks in strings (\n or \r\n in C# and friends)
"First line`nSecond line"
"First line`r`nSecond line"

# Edit your PowerShell profile
notepad.exe $profile # Windows Notepad
code $profile # Visual Studio Code (Windows/macOS/Linux)
nano $profile # Linux Nano

# Get user input for an environment variable
${Env:AzDOPersonalToken} = (Read-Host -Prompt "What Azure DevOps access token do you want to use?")
# Get user input as a secure string, which has special rules for how it is handled.
${Env:AzDOPersonalToken} = (Read-Host -Prompt "What Azure DevOps access token do you want to use?" -AsSecureString)
# Get user input without displaying it (e.g., password input showing **** as the user types).
${Env:AzDOPersonalToken} = (Read-Host -Prompt "What Azure DevOps access token do you want to use?" -MaskInput)
# NOTE: Environment variable names can contain characters not normally allowed in normal PowerShell variables. The curly brace syntax allows for those characters, if needed (e.g., `${Env:azdo-personal-token}`).

# Add path to user environment Path variable
$oldPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)
$newPathAddition = "C:\Users\someuser\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.8_qbz5n2kfra8p0\LocalCache\local-packages\Python38\Scripts\"
# Concatenate old with addition via semicolon
$newPath = "$oldPath;$newPath"
# Save new combined path to user Path
[System.Environment]::SetEnvironmentVariable("Path", "$newPath", [System.EnvironmentVariableTarget]::User)
# Update the current path in this PowerShell session (vs. logging out and back in)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

# List all the current local variables, useful for debugging variable values at a current point in execution
Get-Variable -Scope Local
# NOTE: This appears to provide a way to get a variables name at runtime, as you would do with C#'s `nameof` operator, but that's not how this works. The value passed in to `Get-Variable` is a string, so calling with variable syntax will get the variable with the name of the underlying variable value. (If `$test="asdf"`, then `Get-Variable $test` will look for a variable named `$asdf`.):
#       `(Get-Variable test).Name` # Name not validated in any way.

## References
# Red Gate's PowerShell punctuation guide: https://www.red-gate.com/simple-talk/wp-content/uploads/2015/09/PSPunctuationWallChart_1_0_4.pdf
