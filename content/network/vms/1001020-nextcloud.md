---
title: Nextcloud
---

available at nextcloud.altpeter.me.

## Setup

TBD, through the snap package

## Updates

Nextcloud should be updated automatically through the snap?

## Backups

The instance is backed up to S3.

Install the AWS CLI: `apt install awscli`

Create the backup directory: `mkdir -p /backups`

Import GPG key: `gpg --recv-keys 0903DEF9C6838D774EC73A8E580B1C7800EB2372`

Trust the key: `gpg --edit-key 0903DEF9C6838D774EC73A8E580B1C7800EB2372` and enter `trust`, followed by `5`, `y` and `quit`

Create the file `~/.aws/credentials` and save the AWS credentials with access to the bucket (create [here](https://console.aws.amazon.com/iam/home?region=eu-central-1#/users) using the policy below) in there:

```ini
[default]
aws_access_key_id = abc
aws_secret_access_key = def
```

Create the file `~/backup-gpg-s3.sh` with the contents listed below and make it executable (`chmod +x ~/backup-gpg-s3.sh`).

Add the following line to the crontab using `crontab -e`:

```
30 5 * * * /root/backup-gpg-s3.sh && curl -fsS --retry 3 https://hc-ping.com/e5e43109-etc > /dev/null
```

### Backup script

```sh
#!/bin/bash

# Creates a backup folder in `/var/snap/nextcloud/common/backups`
/snap/bin/nextcloud.export

# Get the newest backup folder, see https://stackoverflow.com/a/9275978
BACKUPDIR="/var/snap/nextcloud/common/backups/$(ls -t /var/snap/nextcloud/common/backups | head -1)"
out_file=nextcloud-$(date --iso-8601=seconds).tar.gz

/bin/tar czf /backups/"$out_file" "$BACKUPDIR"
/usr/bin/gpg --output /backups/"$out_file".gpg --encrypt --recipient 0903DEF9C6838D774EC73A8E580B1C7800EB2372 /backups/"$out_file"
rm -f /backups/"$out_file"
rm -rf "$BACKUPDIR"
/usr/bin/aws s3 cp /backups/"$out_file".gpg s3://nextcloud-altpeter-backups/"$out_file".gpg --storage-class STANDARD_IA

# Delete local backups older than 7 days, see https://stackoverflow.com/a/13869000
/usr/bin/find /backups/* -ctime +7 -print0 | /usr/bin/xargs rm -rf
```

### AWS policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1528475293000",
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::nextcloud-altpeter-backups/*"
      ]
    },
    {
      "Sid": "Stmt1528475385000",
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketLocation",
        "s3:ListAllMyBuckets"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Sid": "Stmt1528475432000",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::nextcloud-altpeter-backups"
      ]
    }
  ]
}
```

## References

* https://github.com/nextcloud/nextcloud-snap/wiki/How-to-backup-your-instance
