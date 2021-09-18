---
title: Restic backups
---

Important data is backed up to Backblaze B2 using restic. This file describes the general configuration, individual systems may introduce certain changes, though. Check the docs for those systems.

## Installation and repo setup

First, create a new [bucket](https://secure.backblaze.com/b2_buckets.htm) (private, disable object lock). Then on the [Application Keys page](https://secure.backblaze.com/app_keys.htm), create a new key (only allow access to the bucket in question, read/write).

Then, create a file `~/env-restic-b2.sh` like so:

```sh
export RESTIC_REPOSITORY=b2:<bucket name>:restic-repo
export RESTIC_PASSWORD=123
export B2_ACCOUNT_ID=abc # Choose a new password and save it in 1Password.
export B2_ACCOUNT_KEY=def
```

Run:

```sh
apt install restic

source ~/env-restic-b2.sh
restic init
```

## Scripts

Create a file `~/backup-restic-b2.sh` like so:

```sh
#!/bin/bash

set -e

source /root/env-restic-b2.sh

# Optional: Run a backup script or similar here.

BACKUPDIR="<full path to folder>"

restic backup "$BACKUPDIR"
rm -rf "$BACKUPDIR"
```

Create a file `~/housekeeping-restic-b2.sh` like so, optionally modifying the numbers:

```sh
#!/bin/bash

set -e

source /root/env-restic-b2.sh

restic forget --prune --keep-last 7 --keep-daily 7 --keep-weekly 8 --keep-monthly 3 --keep-yearly 2

restic check
```

Make the scripts executable (`chmod +x ~/backup-restic-b2.sh && chmod +x ~/housekeeping-restic-b2.sh`).

Do a test run of the backup script: `~/backup-restic-b2.sh`
And the cleanup script: `~/housekeeping-restic-b2.sh`

## Cronjob

Create two new checks on [healthchecks.io](https://healthchecks.io/). Then, add the following lines to the crontab using `crontab -e` but set different times:

```
30 5 * * * /root/backup-restic-b2.sh && curl -fsS --retry 3 <healthcheck URL 1>
00 8 * * 2 /root/housekeeping-restic-b2.sh && curl -fsS --retry 3 <healthcheck URL 2>
```

TODO: Reports via email
