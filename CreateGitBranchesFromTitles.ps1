# Assumes your upstream remote is "upstream"
# Prefix is specific to Microsoft Learn, where we had a standard of "NEW-" for branches containing a new Learn module.
@("This is some Title with capitalization", `
  "Here is Another Cool module title") `
| % { "NEW-" + ($_.Replace(" ", "-").Replace(",", "").ToLowerInvariant()) } `
| % { git fetch upstream; git checkout -b $_ upstream/master; git push --set-upstream upstream $_; git checkout master; git branch -D $_ }
