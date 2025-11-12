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
00 1 * * * m=$(/root/backup-restic-b2.sh 2>&1) ; curl -fsS -m 30 --retry 5 --data-raw "$m" https://hc-ping.com/89a1c513-eca0-4820-8e97-5932324c1ad6/$?
00 8 10 * * m=$(/root/housekeeping-restic-b2.sh 2>&1) ; curl -fsS -m 30 --retry 5 --data-raw "$m" https://hc-ping.com/cc1a265b-8ffa-4d8a-a769-931a950dd312/$?
```

### Backup script (`backup-restic-b2.sh`)

```sh
#!/bin/bash

set -e

source /root/env-restic-b2.sh

BACKUPDIR="/var/snap/nextcloud/common/nextcloud"
BACKUPDIR_EXT="$BACKUPDIR/benni-ext"

# Taken from: https://github.com/nextcloud-snap/nextcloud-snap/blob/fc77efa2a3436202fc83769557f7b8f7b5dbedf5/src/common/utilities/common-utilities#L9-L38
stdout_is_a_terminal()
{
    [ -t 1 ]
}
run_command()
{
    if stdout_is_a_terminal; then
        printf "%s... " "$1"
    else
        echo "$1..."
    fi

    shift
    if output="$("$@" 2>&1)"; then
        echo "done"
        return 0
    else
        echo "error"
        echo "$output"
        return 1
    fi
}

# Taken from: https://github.com/nextcloud-snap/nextcloud-snap/blob/fc77efa2a3436202fc83769557f7b8f7b5dbedf5/src/common/utilities/common-utilities#L99-L117
enable_maintenance_mode()
{
    if run_command "Enabling maintenance mode" nextcloud.occ -n maintenance:mode --on; then
        sleep 3
        return 0
    fi
    return 1
}
disable_maintenance_mode()
{
    if run_command "Disabling maintenance mode" nextcloud.occ -n maintenance:mode --off; then
        sleep 3
        return 0
    fi
    return 1
}

if ! enable_maintenance_mode; then
    echo "Unable to enter maintenance mode"
    exit 1
fi
trap 'disable_maintenance_mode' EXIT

echo "Clearing old backup..."
rm -rf "${BACKUPDIR_EXT}"
mkdir -p "${BACKUPDIR_EXT}"

echo "Exporting apps..."
if ! rsync -ah --info=progress2 "/var/snap/nextcloud/current/nextcloud/extra-apps/" "${BACKUPDIR_EXT}/apps"; then
    echo "Unable to export apps"
    exit 1
fi

echo "Exporting database..."
# Silly workaround for "mysqldump: Got errno 11 on write" error I don't understand.
if ! nextcloud.mysqldump | tee "${BACKUPDIR_EXT}/database.sql" >/dev/null; then
    echo "Unable to export database"
    exit 1
fi

echo "Exporting config..."
# Mask out the config password. We don't need it when restoring.
if ! sed "s/\(dbpassword.*=>\s*\).*,/\1'DBPASSWORD',/" "/var/snap/nextcloud/current/nextcloud/config/config.php" > "${BACKUPDIR_EXT}/config.php"; then
    echo "Unable to export config"
    exit 1
fi

echo "Running restic..."
restic backup "$BACKUPDIR"

echo "Done."
```

## References

* https://github.com/nextcloud/nextcloud-snap/wiki/How-to-backup-your-instance
