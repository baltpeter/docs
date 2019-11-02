---
title: Windows
---

## Run commands

* `appwiz.cpl`: Programs and features
* `lusrmgr.msc`: Local users and groups
* `netplwiz`: Local user accounts (not useful on Windows Server)
* `powercfg.cpl`: Power options
* `ncpa.cpl`: Network connections ('Change adapter settings')
* `desk.cpl`: Display setting (resolution, screens, etc.)
* `ms-settings:`: Windows 10 settings (see below for a list of sub URIs)
* `cleanmgr`: Disk cleanup
* `devmgmt.msc`: Device manager
* `gpedit.msc`: Group policy editor
* `sysdm.cpl`: System properties
* `firewall.cpl`: Windows Defender firewall settings
* `main.cpl`: Mouse settings

## Keyboard shortcuts

* [Restart graphics driver](https://www.reddit.com/r/AskReddit/comments/a22ivq/what_is_the_most_useful_windows_keyboard_shortcut/eav2qyb/): Win + Ctrl + Shift + B
* [Rotate screen](https://www.howtogeek.com/356816/how-to-rotate-your-pcs-screen-or-fix-a-sideways-screen/): Ctrl + Alt + [Up/Right/Down/Left]

## Audit mode

In the OOBE, press Ctrl + Shift + F3 to boot into audit mode ([1](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/boot-windows-to-audit-mode-or-oobe#boot-to-audit-mode-manually-on-a-new-or-existing-installation)). In this mode, the system can be prepared for deployment. Using the dialog that pops up on start, the system can be shutdown.

Upon the next start, the system will relaunch the OOBE.

## Links

* [List of `ms-settings` URIs](https://docs.microsoft.com/en-us/windows/uwp/launch-resume/launch-settings-app#ms-settings-uri-scheme-reference) ([alternative resource](https://winaero.com/blog/open-various-settings-pages-directly-in-windows-10-anniversary-update/))
