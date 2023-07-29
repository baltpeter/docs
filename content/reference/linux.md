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

* Night light not working correctly: Try `killall gsd-color` ([1](https://askubuntu.com/a/1075340)) and, if that doesn't work, follow it by `/usr/libexec/gsd-color`
* Analog sound output not appearing: Try `pactl load-module module-detect` ([2](https://askubuntu.com/a/1184065))
* Wired network connection not working anymore after sleep (shows up as "Cable unplugged" in Settings): I've had this happen every once in a while. The typical commands to restart various networking services (e.g. `systemctl restart NetworkManager`, `ip link set enp7s0 down; ip link set enp7s0 up`) don't work for me in this case. So far, I've always solved this by restarting the computer, but it can actually also be fixed by just reloading the driver ([2](https://askubuntu.com/a/1030154), [3](https://askubuntu.com/a/1029269)):

  First find out the driver in use by running `sudo lshw -C network`. There will be a line that contains `driver=<driver>` (in my case `igb`).

  Then, unload and reload the driver:

  ```sh
  sudo modprobe -r <driver>
  sudo modprobe -i <driver>
  ```

  So, in my case:

  ```sh
  sudo modprobe -r igb
  sudo modprobe -i igb
  ```

## Grep

* Find files *not* containing a string: `grep -L [string] [files]` (e.g. `grep -L foo *`)

## Disks

* Remove filesystems on a disk: `wipefs -a /dev/sd[x]` ([1](https://askubuntu.com/a/825032))

## Shells

* Running a command `[cmd]` that is shadowed by an alias ([1](https://unix.stackexchange.com/a/39296)), try:
    - `\[cmd]`
    - `command [cmd]`
    - `'[cmd]'` or `"[cmd]"` 

## freedesktop.org

* Update cache database of MIME types handled by desktop files: `sudo update-desktop-database` ([1](https://manpages.ubuntu.com/manpages/cosmic/man1/update-desktop-database.1.html))

## rsync

* Typical `rsync` parameters: `rsync -ah --info=progress2 [source] [dest]`, where:
    - `-a`: 'archive' (equal to `-rlptgoD`), where in turn:
        * `-r`: 'recursive'
        * `-l`: copy symlinks as symlinks
        * `-p`: preserve permissions
        * `-t`: preserve modification times
        * `-g`: preserve group
        * `-o`: preserve owner (requires root)
        * `-D`: preserve device (requires root) and special files
    - `-h`: 'human readable'
    - `--info=progress2`: display progress info for whole transfer instead of individual files (`--progress`)
* Additional sometimes useful parameters:
    - `-v`: print transferred files
    - `--delete`: delete extraneous files from destination
    - `-u`: skip files that are newer at destination
    - `--dry-run`: output changes without actually making them
    - `--partial`: keep partially transferred files in destination if transfer is aborted
    - `-z`: compress

## LVM

* To expand a logical volume (for example after cloning to a larger disk):
    - Resize the partition using gparted (if necessary).
    - Run `lvresize -l +100%FREE /dev/mapper/[lv]`, e.g. `lvresize -l +100%FREE /dev/mapper/ubuntu--vg-root`.
    - Run `resize2fs -p /dev/mapper/[lv]`.

## Misc

* For documenting command line arguments, refer to [docopt](http://docopt.org/).
* Encrypt files with 7zip (will prompt for password): `7z a -p -mhe -t7z [archive_name].7z [filenames...]` ([1](https://www.techrepublic.com/article/how-to-use-7zip-to-encrypt-files/))

