# Setting up Windows (10) machines

## Install common software

First, install [Chocolatey](https://chocolatey.org/install). Then, install the default packages using `choco install packages.config` in an admin `cmd`.

## Uninstall bloatware

If not already using an appropriately preconfigured image, uninstall bloatware.

Start a PowerShell as administator and run `Set-ExecutionPolicy -ExecutionPolicy Unrestricted`. This will enable running scripts. After the setup is done, feel free to reset it using `Set-ExecutionPolicy Undefined`.

Run the PowerShell script `uninstall-bloatware.ps1` by right-clicking and selecting `Run with PowerShell`.

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
