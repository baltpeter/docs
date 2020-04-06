---
title: ZSH
---

## Recovering arguments from the previous command

Given a previous command of `echo a b c d`, here's how to recover the arguments in a new command: ([1](https://stackoverflow.com/a/49025392))

* `!$` will expand to the last argument: `d`
* `!*` will expand to all arguments: `a b c d` (it is shorthand for `!:*`)
* `!:1` will expand to the first argument: `a` (can also be written as `!^`)
* `!:1-3` will expand to the first to third argument: `a b c` (you can also use `$` and `^` here)
* `$:0` will expand to the command: `echo`

Note: This also works in bash.

## Auto-completions

ZSH looks for completion files in the `$fpath` which can be set like this: `fpath=(~/.zsh/completions $fpath)`

After adding new completions, you may have to force-rebuild `zcompdump`: `rm -f ~/.zcompdump; compinit` ([1](https://github.com/zsh-users/zsh-completions/blob/f68950a304977c0acd95d36d52ae0f1b1f2d8285/README.md#manual-installation))

### Resources

* [Useful guide on how to write completions](https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org)
