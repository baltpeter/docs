---
title: Nextcloud
---

available at nextcloud.altpeter.me.

## Setup

TBD, through the snap package

## Updates

Nextcloud is updated automatically through the snap.

## Restic backups

The instance is backed up to Backblaze B2 using restic. Follow the steps in [Net/Restic]({{< ref "network/restic" >}}) but use the backup script listed below.

Setup the following cron jobs:

```sh
30 5 * * * m=$(/root/backup-restic-b2.sh 2>&1) ; curl -fsS -m 30 --retry 5 --data-raw "$m" https://hc-ping.com/89a1c513-eca0-4820-8e97-5932324c1ad6/$?
00 8 * * 2 m=$(/root/housekeeping-restic-b2.sh 2>&1) ; curl -fsS -m 30 --retry 5 --data-raw "$m" https://hc-ping.com/cc1a265b-8ffa-4d8a-a769-931a950dd312/$?
```

### Backup script (`backup-restic-b2.sh`)

```sh
#!/bin/bash

set -e

source /root/env-restic-b2.sh

# Creates a backup folder in `/var/snap/nextcloud/common/backups`
/snap/bin/nextcloud.export

# Get the newest backup folder, see https://stackoverflow.com/a/9275978
BACKUPDIR="/var/snap/nextcloud/common/backups/$(ls -t /var/snap/nextcloud/common/backups | head -1)"

restic backup "$BACKUPDIR"
rm -rf "$BACKUPDIR"
```

## References

* https://github.com/nextcloud/nextcloud-snap/wiki/How-to-backup-your-instance
