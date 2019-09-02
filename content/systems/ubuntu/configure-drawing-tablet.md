---
title: Configure drawing tablet
---

I own a Medion MD 86336 drawing tablet (which is a rebranded *Waltop International Corp. Slim Tablet 12.1"*, `172f:0034`). It is natively supported under Linux.

## Multi-monitor setup

On a system with multiple monitors, it is usually preferable to constraint the tablet to one monitor. This can be easily done using `xsetwacom` ([1](https://wiki.archlinux.org/index.php/Wacom_tablet#xrandr_setup), [2](https://ubuntuforums.org/showthread.php?t=1656089&p=10297093#post10297093)).

First, run `xrand` to find out what the screen is called. This will produce an output like this:

```
Screen 0: minimum 8 x 8, current 7680 x 2160, maximum 32767 x 32767
DVI-D-0 connected primary 1920x1080+3840+454 (normal left inverted right x axis y axis) 533mm x 312mm
   1920x1080     60.00*+
   1680x1050     59.95  
   ...
HDMI-0 connected 3840x2160+0+0 (normal left inverted right x axis y axis) 621mm x 341mm
   3840x2160     60.00*+  59.94    50.00    30.00    29.97    25.00    23.98  
   1920x1080     60.00    59.94    50.00    60.00    50.04  
   ...
DP-0 disconnected (normal left inverted right x axis y axis)
DP-1 connected 1920x1080+5760+454 (normal left inverted right x axis y axis) 521mm x 293mm
   1920x1080     60.00*+  59.94    50.00    60.00    50.04    50.04  
   1680x1050     59.95  
   ...
```

Next, run `xsetwacom list devices` to find the ID of the tablet:

```
WALTOP International Corp. Slim Tablet stylus   id: 16  type: STYLUS
```

Now, you can map the tablet to the desired screen: `xsetwacom set [id] MapToOutput [screen]` (e.g. `xsetwacom set 16 MapToOutput DVI-D-0`)

This should work immediately and is not persisted across reboots.

### Proprietary Nvidia driver

…except when using a proprietary Nvidia driver. -.- In that case, use `HEAD-[n]` instead for the display identifier (e.g. `xsetwacom set 16 MapToOutput HEAD-1`).

### Reset

To reset, use `xsetwacom set [id] MapToOutput desktop`
