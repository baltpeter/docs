---
title: Windows 10
---

## Install common software

First, install [Chocolatey](https://chocolatey.org/install). Then run `choco feature enable -n allowGlobalConfirmation` to disable prompting for every package. Finally, install the default packages using `choco install packages.config` (optionally also install the additional packages from `packages-additional.config`) in an admin `cmd`.

## Uninstall bloatware

In an elevated command prompt, run `@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/baltpeter/system-docs/master/windows/uninstall-bloatware.ps1'))"`.

## Privacy settings

Apply the recommended settings from [O&O ShutUp 10](https://www.oo-software.com/en/shutup10) for better privacy settings. The program is already installed through Chocolatey and you can simply run `oosu10`.

## Settings

<!-- Obsolete because these are all included in the .reg file.
* Go into Windows Explorer and *View* -> *Options*. In the first tab, under *Privacy*, uncheck all settings.  
In the *View* tab, enable 'Show hidden files, folders and drives' and disable 'Hide extensions for known types', 'Show sync provider notifications' and 'Hide protected operating system files (recommended)'.
-->
* Run the `tweaks.reg` file to import the settings into the registry.
* Go to the *Personalisation* -> *Start* settings page (`ms-settings:personalization-start`) and disable all options apart from 'Show app list in start menu'.
* Go to the *Devices* -> *Pen & Windows Ink* settings page (`ms-settings:pen`) and disable 'Show recommend app suggestions'.

## Misc.

* Create a 'god mode' shortcut: On the desktop, create a new folder and name it `God Mode.{ED7BA470-8E54-465E-825C-99712043E01C}`.

## References:

* https://www.tweakhound.com/2015/12/09/tweaking-windows-10
