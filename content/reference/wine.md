---
title: Wine
---

## Sensible template prefix

Applications should be installed into separate prefixes to avoid incompatibilites.

To setup a sensible template prefix (for x64, use `WINEARCH=win32` for x86):

```sh
export WINEPREFIX=/home/benni/wine-prefixes/_template64
export WINEARCH=win64
wineboot -u
winetricks fontsmooth=rgb gdiplus vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015 msxml3 msxml6 atmlib allfonts
winecfg # Set to Win 7
```

## Useful commands

* `wineboot -r`: 'Reboot' the prefix
* `wineserver -k`: Kill all programs running in the prefix
* `winefile`: Wine file manager
* `wine start [explorer|taskmgr|…]`: Start the corresponding program

## Desktop files

Automatically generated `.desktop` files are saved in `~/.local/share/applications/wine`. ([1](https://www.reddit.com/r/winehq/comments/hlivbd/where_does_wine_put_my_desktop_files/fwzssc0/))
