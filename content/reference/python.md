---
title: Python
---

## Pipx

Upgrading the system Python breaks Pipx. These steps should work to restore it ([1](https://github.com/pypa/pipx/issues/278)):

```sh
rm -rf ~/.local/pipx
python3 -m pip install --user pipx
pipx reinstall-all
```
