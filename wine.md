# Useful things for Wine

## Sensible template prefix

Applications should be installed into separate prefixes to avoid incompatibilites.

To setup a sensible template prefix (for x64, use `WINEARCH=win32` for x86):

```
export WINEPREFIX=/home/benni/wine-prefixes/_template64
export WINEARCH=win64
wineboot -u
winetricks fontsmooth=rgb gdiplus vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015 msxml3 msxml6 atmlib allfonts
winecfg # Set to Win 7
```
