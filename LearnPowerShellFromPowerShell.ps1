# Like a `man` (manual) page in *nix for commands
Get-Help {command}
# Example:
Get-Help Get-ChildItem -Detailed

# Find commands by some partial name matching
Get-Command -Name *{keyword}*
# Tell me what a resulting object looks like and what I can call on it
{command} | Get-Member
# Find methods/etc. on command that contain "something" in the name
{command} | Get-Member | ? { $_ -like "*last*" }
# Get any aliases/shortcuts for another command (e.g., "Where-Object" to find "?")
Get-Alias -Definition {command}
# In the opposite direction, if you want the original command for what you think is an alias, Get-Help will tell you.
Get-Help % # Shorthand for the `ForEach-Object` command
