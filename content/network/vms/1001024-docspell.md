---
title: Docspell
---

Installed at `10.1.1.24`. Not actually in use.

The application runs in an Ubuntu 20.04 unprivileged LXC container. Under *Options*, enable the *Nesting* feature for Docker to work.

## Setup

The setup is based on the [official install documentation](https://web.archive.org/web/20210321202526/https://docspell.org/docs/install/installing/) and [eikek/docspell#718](https://web.archive.org/web/20210321202808/https://github.com/eikek/docspell/issues/718).

```sh
wget -qO- https://get.docker.com/ | sh
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

mkdir /root/docspell
cd /root/docspell
wget https://raw.githubusercontent.com/eikek/docspell/master/docker/docker-compose.yml
wget https://raw.githubusercontent.com/eikek/docspell/master/docker/docspell.conf
wget https://raw.githubusercontent.com/eikek/docspell/master/docker/.env
# Fill with the config file listed below, but for now set `docspell.server.backend.signup.mode` to `open`.
nano docspell.conf
# Fill with the env file listed below.
nano .env
# Will already restart after a reboot.
docker-compose --project-name docspell up
```

Setup the reverse proxy using the config below. Open `https://docspell.altpeter.me` in the browser and register a user.

Stop the server using Ctrl + C. Edit `docspell.conf` again and set `docspell.server.backend.signup.mode` to `closed`. Restart the server using `docker-compose --project-name docspell up -d`.

Go into *User Profile* and *UI Settings*. Under *Item Detail*, enable *Browser-native PDF preview*. Under *Fields*, disable *Concerned Equipment*, *Concerning Person* and *Correspondent Person*.

Under *Manage Data* and *Tags*, create the following tags:

* Category `doctype`
    * Administrative notice
    * Complaint
    * Receipt
    * Letter
    * GDPR request/response
    * Email
    * Form
    * Bank statement
    * Cancellation
    * Invoice
    * Tax declaration
    * Time sheet
    * Contract

Under *Folders*, create the following folders:

* Work
* GDPR
* Finance
* Tax
* University
* Non-profits

Under *Custom Fields*, create the following custom fields:

* Date (sent/received): date
* Reference: text
* Foreign reference: text

## Updates

Subscribe to the [releases on GitHub](https://github.com/eikek/docspell/releases).

This is based on [1](https://web.archive.org/web/20210321203558/https://docspell.org/docs/install/upgrading/)

TODO

```sh
docker-compose down
docker-compose pull
docker-compose up --force-recreate --build -d
```

## Configs

### Config file

Based on [1](https://web.archive.org/web/20210321203407/https://docspell.org/docs/configure/) and [2](https://web.archive.org/web/20210321204921/https://github.com/eikek/docspell/blob/bd5dba9f8e4fb874915847ba5b6269f42e54b2f2/docker/docspell.conf).

```hocon
docspell.server {
    app-name = "docspell.altpeter.me"
    bind {
        address = "0.0.0.0"
    }
    base-url = "https://docspell.altpeter.me"
    app-id = "altpeter-docspell-rest1"

    backend.signup {
        mode = "closed"
    }
    auth {
        server-secret = "${AUTH_SECRET_PASS}"
    }
    integration-endpoint {
        enabled = true
        http-header {
            enabled = true
            header-value = ${?DOCSPELL_HEADER_VALUE}
        }
    }
    full-text-search {
        enabled = true
        solr {
            url = "http://solr:8983/solr/docspell"
        }
    }
    backend {
        jdbc {
            url = "jdbc:"${DB_TYPE}"://"${DB_HOST}":"${DB_PORT}"/"${DB_NAME}
            user = ${DB_USER}
            password = ${DB_PASS}
        }
    }
}

docspell.joex {
    app-id = "altpeter-docspell-joex1"
    base-url = "http://"${HOSTNAME}":7878"
    bind {
        address = "0.0.0.0"
    }
    jdbc {
        url = "jdbc:"${DB_TYPE}"://"${DB_HOST}":"${DB_PORT}"/"${DB_NAME}
        user = ${DB_USER}
        password = ${DB_PASS}
    }
    full-text-search {
        enabled = true
        solr = {
            url = "http://solr:8983/solr/docspell"
        }
    }
    scheduler {
        pool-size = 8
    }
    extraction {
        preview {
            dpi = 64
        }
        ocr {
            page-range {
                begin = 32
            }
        }
    }
    text-analysis {
        max-length = 10000
    }
}
```

### Env file

```sh
TZ=Europe/Berlin
DOCSPELL_HEADER_VALUE=<pw>
DB_TYPE=postgresql
DB_HOST=db
DB_PORT=5432
DB_NAME=docspell
DB_USER=docspell
DB_PASS=<pw>
CONSUMEDIR_VERBOSE=y
CONSUMEDIR_INTEGRATION=y
CONSUMEDIR_POLLING=n
NEW_INVITE_PASS=<pw>
AUTH_SECRET_PASS=b64:<pw_as_base64>
```

### Reverse proxy config

```nginx
server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;
        server_name docspell.altpeter.me;

        include /etc/nginx/benni.conf;

        include /etc/nginx/ssl.conf;
        ssl_certificate /etc/letsencrypt/live/docspell.altpeter.me/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/docspell.altpeter.me/privkey.pem;
        ssl_trusted_certificate /etc/letsencrypt/live/docspell.altpeter.me/fullchain.pem;

        location / {
                proxy_set_header X-Forwarded-Proto https;
                proxy_pass http://10.1.1.24:7880;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $http_connection;
                include /etc/nginx/proxy.conf;
        }
}
```
