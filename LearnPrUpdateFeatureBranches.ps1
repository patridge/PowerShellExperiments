## Given a bunch of branch names in the current repo, and a remote of `upstream`, pull the latest changes to upstream/master and merge them into each branch.
@("branch-name-1", `
  "branch-name-2", `
  "branch-name-3", `
  "branch-name-4", `
  "branch-name-5", `
  "branch-name-6", `
  "branch-name-7",) `
| Select -First 1 ` # This line limits to first branch for testing. Remove this line to operate across all branch names.
| % { git fetch upstream; git checkout -b $_ upstream\$_; git merge upstream/main; }

# Update a remote feature branch by PR with the latest from remote `master`.
# Given a remote of `upstream`...fill out `{some-org}`, `{some-repo}`, `{some-fork}`, `{some-body}`...
# Given a string representing a Git branch name, merge latest master from upstream, open a Chrome window for the pending PR, and copy the command to push to fork branch to the clipboard. If the merge failed, it wouldn't be used and I would `git merge --abort` instead. Otherwise, I would push and start a PR at the opened Chrome window.
@("branch-name-1") | % { git fetch upstream; git checkout -b $_ upstream/$_; git merge upstream/main; Start-Process "chrome.exe" "https://github.com/{some-org}/{some-repo}/compare/$_...{some-fork}:$_?expand=1&title=Update%20with%20the%20latest%20master&body={some-body}" }; "git push --set-upstream {some-fork} $_" | clip;
