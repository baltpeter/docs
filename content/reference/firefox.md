---
title: Firefox
---

## Restoring lost session

If the open windows and tabs are lost after a restart of Firefox, it's still likely possible to recover them. Follow these steps in order ([1](https://support.mozilla.org/en-US/questions/1204253#answer-1075873)):

1. Make a backup of the `sessionstore-backups` folder in your Firefox profile (by default `~/.mozilla/firefox/<profile_name>/sessionstore-backups` on Linux), just in case. **Do this before anything else**, especially before restarting Firefox as it might otherwise get overridden.
2. In the *History* menu, try *Restore Previous Session*, *Recently Closed Windows*, and *Recently Closed Tabs*.
3. If that doesn't work, use the [Session History Scrounger](https://www.jeffersonscher.com/ffu/scrounger.html). Try importing all files from your `sessionstore-backups` backup and hope that one of them still contains the list of sites.  
   After loading the file, click *Scrounge URLs* (or, if that fails, *Unstructured URL list*) and use *Save List* to make a backup of the list.  
   If the site hangs, it's a good idea to reload it after about half a minute, this tends to help. An explanation of what the backup files mean is given in [1](https://support.mozilla.org/en-US/questions/1204253#answer-1075873).
