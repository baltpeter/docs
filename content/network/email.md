---
title: Email
---

Email is hosted through Uberspace. For new accounts, use Uberspace 7.

## Setup

### Domains

Add all desired email domains by running: `uberspace mail domain add [domain.tld]` ([1](https://manual.uberspace.de/mail-domains.html))

The command will output the necessary DNS configuration.

### Email addresses

Go into the [Email section of the dashboard](https://dashboard.uberspace.de/dashboard/mail).

Start by adding the mailboxes under *Your virtual mailboxes*. Next, you can define aliases under *Your additional mail addresses*.  
The mailboxes can optionally also directly be configured through the terminal ([2](https://manual.uberspace.de/mail-mailboxes.html)) and the aliases are just `.qmail` files. 

### Spam filter

Disable the spam filter: `uberspace mail spamfilter disable` ([3](https://manual.uberspace.de/mail-filter.html))

### Migrate old emails

Emails from the old server can easily be migrated using `imapsync`. ([4](https://wiki.uberspace.de/start:umzug#migration_deiner_mails))

Create two files, `oldpass` and `newpass` containing the password of the old and new IMAP account, respectively. Then run:

```sh
imapsync --host1 [imap.oldhost.tld] --user1 [old_username] --passfile1 oldpass --ssl1 --host2 [host.uberspace.de] --user2 [new_username] --passfile2 newpass --ssl2
```

Afterwards, delete those files.

## Access

see [5](https://manual.uberspace.de/mail-access.html)
