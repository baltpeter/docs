---
title: ZSH
---

## Auto-completions

ZSH looks for completion files in the `$fpath` which can be set like this: `fpath=(~/.zsh/completions $fpath)`

After adding new completions, you may have to force-rebuild `zcompdump`: `rm -f ~/.zcompdump; compinit` ([1](https://github.com/zsh-users/zsh-completions/blob/f68950a304977c0acd95d36d52ae0f1b1f2d8285/README.md#manual-installation))

### Resources

* [Useful guide on how to write completions](https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org)
