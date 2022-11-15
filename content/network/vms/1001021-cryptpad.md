---
title: Cryptpad
---

Runs at `10.1.1.21`, is publicly accessible but password-protected.

## Setup

Mostly follows the [install guide](https://github.com/xwiki-labs/cryptpad/wiki/Installation-guide) ([archived](https://web.archive.org/web/20190717134049/https://github.com/xwiki-labs/cryptpad/wiki/Installation-guide)):

```sh
apt install git build-essential
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
apt install nodejs
npm install -g bower
git clone https://github.com/xwiki-labs/cryptpad.git /root/cryptpad

# In /root/cryptpad:
npm install --unsafe-perm
bower install --allow-root
# Set the config values shown below in `config.js`.
cp config/config.example.js config/config.js
mkdir customize
cp customize.dist/application_config.js customize

# Create the init script shown below.
systemctl enable cryptpad.service
```

### Init script

Save in `/etc/systemd/system/cryptpad.service`:

```
[Unit]
Description=CryptPad service

[Service]
ExecStart=/usr/bin/node /root/cryptpad/server.js
WorkingDirectory=/root/cryptpad
Restart=always

[Install]
WantedBy=multi-user.target
```

### Config values

In `/root/cryptpad/config/config.js`:

```js
var _domain = 'https://cryptpad.my-server.in';

module.exports = {
    adminKeys: [
        "https://cryptpad.my-server.in/user/#/1/baltpeter/id"
    ],
    httpSafeOrigin: 'https://cryptpad-sandbox.my-server.in',
    allowSubscriptions: false,
    adminEmail: 'name@mail.tld',
    defaultStorageLimit: 50 * 1024 * 1024 * 1024,
}
```

## Updates

Follow the [new releases](https://github.com/xwiki-labs/cryptpad/releases) via RSS to be informed of new versions.

The releases usually contain *Update notes* with special steps that need to be followed. Otherwise the general upgrade procedure is as documented in the [install guide](https://github.com/xwiki-labs/cryptpad/wiki/Installation-guide#upgrading-cryptpad):

```sh
cd /root/cryptpad
systemctl stop cryptpad.service
git pull
npm update
bower update --allow-root
systemctl start cryptpad.service
```

To easily check if there are new/changed config values: `diff /root/cryptpad/config/config.example.js /root/cryptpad/config/config.js -y --color=always`

## References

* https://github.com/xwiki-labs/cryptpad/wiki/Installation-guide
