---
title: Nextcloud
---

available at nextcloud.altpeter.me.

## Setup

TBD, through the snap package

## Updates

Nextcloud is updated automatically through the snap.

## Restic backups

The instance is backed up to Backblaze B2 using restic.

Install restic and initialize the repo:

```sh
apt install restic

export B2_ACCOUNT_ID=abc
export B2_ACCOUNT_KEY=def

restic -r b2:altpeter-restic-nextcloud:restic-repo init
```

Write the required env vars (see below) to the file `env-restic-b2.sh`. Create the files `~/backup-restic-b2.sh` and `~/housekeeping-restic-b2.sh` with the contents listed below and make them executable (`chmod +x ~/backup-restic-b2.sh && chmod +x ~/housekeeping-restic-b2.sh`).

Do a test run of the backup script: `/root/backup-restic-b2.sh`

Add the following lines to the crontab using `crontab -e`:

```
30 5 * * * /root/backup-restic-b2.sh && curl -fsS --retry 3 https://hc-ping.com/89a1c513-eca0-4820-8e97-5932324c1ad6
00 8 * * * /root/housekeeping-restic-b2.sh && curl -fsS --retry 3 https://hc-ping.com/cc1a265b-8ffa-4d8a-a769-931a950dd312
```

### Env file (`env-restic-b2.sh`)

```sh
export RESTIC_REPOSITORY=b2:altpeter-restic-nextcloud:restic-repo
export RESTIC_PASSWORD=123
export B2_ACCOUNT_ID=abc
export B2_ACCOUNT_KEY=def
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

### Housekeeping script (`housekeeping-restic-b2.sh`)

```sh
#!/bin/bash

set -e

source /root/env-restic-b2.sh

restic forget --prune --keep-last 7 --keep-daily 7 --keep-weekly 8 --keep-monthly 3 --keep-yearly 2

restic check
```

## References

* https://github.com/nextcloud/nextcloud-snap/wiki/How-to-backup-your-instance
