---
title: Git
---

## Aliases

```
[alias]
    # See below, depends on the system.
    # fixup = …

    fdiff = !sh -c 'git diff --color "$@" | diff-so-fancy'
    co = checkout
    cob = checkout -b
    com = checkout master
    # Checkout a GitHub PR, taken from: https://github.com/lee-dohm/dotfiles/blob/8d3c59004154571578c2b32df2cdebb013517630/gitconfig#L8, see: https://github.community/t5/How-to-use-Git-and-GitHub/Checkout-a-branch-from-a-fork/td-p/77
    copr = !sh -c 'git fetch origin pull/$1/head:pr/$1 && git checkout pr/$1' -

    # Taken from: https://haacked.com/archive/2014/07/28/github-flow-aliases/
    wipe = !git add -A && git commit -qm 'WIPE SAVEPOINT' && git reset HEAD~1 --hard

    # Delete merged branches, taken from: https://haacked.com/archive/2014/07/28/github-flow-aliases/
    bclean = "!f() { git checkout ${1-master} && git branch --merged ${1-master} | grep -v " ${1-master}$" | xargs git branch -d; }; f"

    oops = !git commit --amend --no-edit
```

## `diff-so-fancy`

Install `diff-so-fancy` ([1](https://github.com/so-fancy/diff-so-fancy/blob/8728c8badd72995f515b247da938e163d959cdf6/README.md)) and configure the `fdiff` alias as described above. 

```sh
sudo npm install -g diff-so-fancy

git config --global color.ui true

git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"

git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"
```

## Merging multiple repositories into one

With these instructions, you can combine the histories of multiple Git repositories into a single one. Adapted after [this guide](https://saintgimp.org/2013/01/22/merging-two-git-repositories-into-one-repository-without-losing-file-history/) by SaintGimp.

```sh
# Go into the directory of the new repository and initialize it.
git init

# Make sure there is an initial commit.
echo "# Title" > README.md && git add . && git commit -m "Initial commit"

# Repeat the following steps for every repository that should be merged into the new one.

# If you want to move the contents of the old repository into a subfolder, do that first (including commiting and pushing that change to the remote).
# Now, add the old repository as a remote to the new one.
git remote add -f [remote_name] [remote_url]

# Do a rebase.
git rebase [remote_name]/master

# Remove the remote, we don't need it anymore.
git remote remove [remote_name]
```

## Editing older commits

### Using git-rebase

Older Git commits can easily be edited using `git rebase -i [ref]`. `[ref]` needs to be a commit older than the one you want to edit. For example, specify `HEAD~5` to be able to edit the last five commits.  
This will open an editor with a list of the commits you specified. Edit the word in front of every commit (`pick` by default) to choose what to do with that commit. At the bottom, there is also a list of possible commands. Useful ones include:

* `p`: Use commit as-is
* `r`: Change only the commit message
* `e`: Edit the commit (You can then make changes, commit them using `git commit --amend` and continue using `git rebase --continue`.)
* `s`: Squash commit into the previous one
* `d`: Remove commit
* Commits can also be re-ordered, they are in order from top (oldest) to bottom (newest).

### Using git-fixup (alias)

If you only want to edit one older commit, you can also use the [git-fixup alias](https://blog.filippo.io/git-fixup-amending-an-older-commit/) by Filippo Valsorda. It works similar to using `git commit --amend` for the oldest commit.

Simply make the desired changes, add them using `git add` and run `git fixup [ref]`, where `[ref]` is the commit you want to edit.

#### Installation

The alias needs to be added to `~/.gitconfig`:

```
[alias]
    # Taken from: https://blog.filippo.io/git-fixup-amending-an-older-commit/ (2019-06-22)
    fixup = "!f() { TARGET=$(git rev-parse "$1"); git commit --fixup=$TARGET ${@:2} && EDITOR=true git rebase -i --autostash --autosquash $TARGET^; }; f"
```

This version however unfortunately doesn't work on Ubuntu because they use the *dash* shell as `/bin/sh` (which doesn't support the `${@:2}` expansion). There, you can instead use this simplified version that doesn't support passing additional arguments:

```
[alias]
    # Adapted after: https://blog.filippo.io/git-fixup-amending-an-older-commit/ (2019-06-22)
    # I had to remove the `${@:2}` after `commit` which would have forwarded all remaining args to `commit`
    # but unfortunately, Ubuntu uses `/bin/dash` as `/bin/sh` and that doesn't support that expansion. :(
    fixup = "!f() { TARGET=$(git rev-parse "$1"); git commit --fixup=$TARGET && EDITOR=true git rebase -i --autostash --autosquash $TARGET^; }; f"
```

## Staging only parts of a file

Sometimes, you don't want to `git add` a whole file but only a part of it. This can be done using `git add -p` which will then interactively ask you which parts to stage.

Possible commands for each hunk are ([1](https://nuclearsquid.com/writings/git-add/#git-add-patch)):

* `y`: Add this hunk
* `n`: Don't this hunk
* `d`: Skip the rest of the file
* `s`: Split into smaller hunks (only works if there are unchanged lines in-between)
* `e`: Edit hunk in editor  
  When editing, make sure that each line starts with one of these characters: ` ` (unchanged line), `-` (remove line), `+` (add line).
