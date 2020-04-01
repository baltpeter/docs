---
title: Linux
---

## Gnome

* For restarting the shell, try in this order ([1](https://wiki.archlinux.org/index.php/GNOME/Troubleshooting#Shell_freezes)):
    - Alt + F2 -> r
    - `pkill -HUP gnome-shell` in another TTY (should not logout the user on X11)
    - `systemctl restart gdm` (will logout the user)

## NFS mounts

NFS mounts can be tricky. After an NFS request times out, NFS request are retried indefinitely by default. This can lead to unexpected hangs on the client. ([1](https://pve.proxmox.com/wiki/Storage:_NFS))  
Use the mount option `soft` to limit the number of retries to 3.

If an NFS share hangs, it can be unmounted as follows: Find the mount point using `mount` and then `umount -f -l [mount point]` (`-f` for force and `-l` for lazy unmount, i.e. detach now and cleanup references later) ([2](https://askubuntu.com/a/292365))

## Ubuntu

* Night light not working correctly: Try `killall gsd-color` ([1](https://askubuntu.com/a/1075340))
* Analog sound output not appearing: Try `pactl load-module module-detect` ([2](https://askubuntu.com/a/1184065))

## Grep

* Find files *not* containing a string: `grep -L [string] [files]` (e.g. `grep -L foo *`)

## Disks

* Remove filesystems on a disk: `wipefs -a /dev/sd[x]` ([1](https://askubuntu.com/a/825032))
