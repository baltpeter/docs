---
title: Android
---

This page describes how I configured my Pixel 4a. This is still a work-in-progress.

## Install LineageOS for microG

Follow the instructions in [1](https://web.archive.org/web/20210410212013/https://wiki.lineageos.org/devices/sunfish/install) but download the files from [here](https://download.lineage.microg.org/sunfish/) instead. Before using the downloaded files, verify the signatures ([2](https://web.archive.org/web/20210630004502/https://lineage.microg.org/)):

```sh
git clone git@github.com:lineageos4microg/update_verifier.git
cd update_verifier
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt
python3 update_verifier.py lineageos4microg_pubkey ../<path_to_zip>
```

## Basic device setup

Open the *microG Settings* app and under *Location modules*, enable *Mozilla Location Service* and *Nominatim*.

Open *F-Droid* and under *Settings*, enable *Automatically install updates* and set the *Automatic update interval* to *every 12 hours*.

## Settings

Under *Apps & notifications*, *Notifications* and *Advanced*, enable *Hide silent notifications in status bar*.

Under *Display*, enable *Dark theme*. Schedule *Night light* between 4:30 PM and 6:00 AM. Set *Screen timeout* to *10 minutes*. Under *Lock Screen*, set *Notifications on lock screen* to *Show sensitive content only when unlocked*, and disable *Wake screen for notifications*. Enter a notice under *Add text on lock screen*. Enable *Display media cover art*. Disable *Lift to check phone*.

Under *Sound*, set *Vibrate for calls* to *Always vibrate*.

Under *Storage*, disable *Storage manager*.

Under *Privacy* and *Trust*, enable *Restrict USB*.

Under *System* and *Buttons*, enable *Show arrow keys while typing*. Set *Back long press action* to *Kill foreground app*. Set *Home long press action* to *No action*. 

Under *System* and *Status bar*, enable *Network traffic monitor* for *Upload and download*. Set *Clock position* to *Right*. Set *Battery status style* to *Text*.

Under *System*, *Gestures* and *Power menu*, enable *Advanced restart*.

Enable the developer settings by pressing the build string a couple of times.

## Install Magisk

[Download](https://github.com/topjohnwu/Magisk/releases), install and open the *Magisk* app ([1](https://web.archive.org/web/20210707160248/https://topjohnwu.github.io/Magisk/install.html)). Ensure that the device has *Ramdisk: Yes*.

Extract `boot.img` from the LineageOS ZIP as explained [here](https://web.archive.org/web/20210307000652/https://wiki.lineageos.org/extracting_blobs_from_zips.html#extracting-proprietary-blobs-from-payload-based-otas). Push that to the device using:

```sh
adb push boot.img /sdcard/Download/
```

In the *Magisk* app, click *Install*, choose the file and click *Let's go*. Then, copy the patched image to the computer using adb, reboot into fastboot and flash the image:

```sh
adb pull /sdcard/Download/<magisk_patched-*.img>
adb reboot bootloader
fastboot flash boot <magisk_patched-*.img>
```

Afterwards, reboot into the system. Open the *Magisk* app to check that the install was successful.

In the settings, enable *MagiskHide* and *Enable Biometric Authentication*.

## Apps

### F-Droid

Add the following repositories:

* https://apt.izzysoft.de/fdroid/repo

Install the following apps through F-Droid:

* [x] AFWall+
* [x] Aurora Store
* [x] Corona Contact Tracing Germany
* [x] DAVx⁵
* [x] DuckDuckGo Privacy Browser
* [x] EDS Lite
* [x] Element
* [x] Fennec F-Droid
* [x] NewPipe
* [x] Nextcloud
* [x] OsmAnd~
* [x] [QR & Barcode Scanner](https://www.f-droid.org/en/packages/com.example.barcodescanner/)
* [x] RadioDroid
* [x] SQLiteViewer
* [x] StreetComplete
* [ ] Syncthing
* [x] Tasks
    - Use Nextcloud calendar *Tasks* for tasks.
* [x] Telegram FOSS
* [x] Vespucci
* [x] VLC
* [x] WiFiAnalyzer

### Aurora Store

In the Aurora Store, under *Settings* and *Filters*, enable *Filter Google apps* and *Filter F-Droid apps*. Then, under *Blacklist manager*, select all remaining Google and microG apps.

Install the following apps through Aurora:

* [x] 1Password
* [x] AliExpress
* [x] BSVG Netz
* [ ] ~~eBay~~ (doesn't work without Safety Net)
* [x] eBay Kleinanzeigen
* [x] IServ
* [x] Mapillary
* [x] N26
* [x] photoTAN
* [x] Spotify
* [x] Windscribe
* [x] WhatsApp
