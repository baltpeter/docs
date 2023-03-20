---
title: Backghup
---

Runs in an unprivileged Ubuntu 22.04 LXC container.

## Setup

Based on [1](https://web.archive.org/web/20230319172300/https://github.com/baltpeter/backghup/blob/202db9b607408da3bb92a3dc05f6f02b59560707/README.md).

```sh
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt install nodejs

npm i -g backghup

mkdir ~/gh-backups
# Populate with:
# export GITHUB_TOKEN=<token>
nano ~/env-backghup.sh

# Try it manually once:
source ~/env-backghup.sh
backghup --extract --out-dir ~/gh-backups
```

The data is backed up to Backblaze B2 using restic. Follow the steps in [Net/Restic]({{< ref "network/restic" >}}). Use the backup script below.

### Backup script (`backup-restic-b2.sh`)

```sh
#!/bin/bash

set -e

source /root/env-backghup.sh
source /root/env-restic-b2.sh

/usr/bin/backghup --extract --out-dir /root/gh-backups --exclude Raabeschule --exclude getbookshelf --exclude Keeping-Privacy-Labels-Honest

BACKUPDIR="/root/gh-backups"

restic backup "$BACKUPDIR"
```
