# This was a system specific to creating Git branch names from natural Learn module names.
# Prefix is specific to Microsoft Learn, where we had a standard of "NEW-" for branches containing a new Learn module.
# Assumes your upstream remote is "upstream" and that development is done from a branch named "main".
@("This is some Title with capitalization", `
  "Here is Another Cool module title") `
| % { "NEW-" + ($_.Replace(" ", "-").Replace(",", "").ToLowerInvariant()) } `
| % { git fetch upstream; git checkout -b $_ upstream/main; git push --set-upstream upstream $_; git checkout main; git branch -D $_ }
