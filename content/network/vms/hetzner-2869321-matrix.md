---
title: Matrix (Synapse)
---

available at matrix.altpeter.me, hosted at Hetzner (IP `116.203.84.17`), media stored on Hetzner volume `synapse-data`

## Setup

The setup is based on [this tutorial](https://www.natrius.eu/dokuwiki/doku.php?id=digital:server:matrixsynapse) ([archived](https://web.archive.org/web/20190630102721/https://www.natrius.eu/dokuwiki/doku.php?id=digital:server:matrixsynapse)).

```sh
sudo apt install -y lsb-release wget apt-transport-https
sudo wget -O /usr/share/keyrings/matrix-org-archive-keyring.gpg https://packages.matrix.org/debian/matrix-org-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/matrix-org-archive-keyring.gpg] https://packages.matrix.org/debian/ $(lsb_release -cs) main" |
    sudo tee /etc/apt/sources.list.d/matrix-org.list

sudo sh -c 'apt update && apt upgrade'
sudo apt install matrix-synapse-py3 # Name of the server: `matrix.altpeter.me`, Report anonymous statistics: Yes

sudo systemctl start matrix-synapse.service
sudo systemctl enable matrix-synapse.service

# Skip "Set up well.known", this will be done directly in Nginx.

# Create the following DNS record: `_matrix._tcp.altpeter.me. 3600 IN SRV 10 5 443 matrix.altpeter.me.`

# Then, in:
sudo nano /etc/matrix-synapse/homeserver.yaml
# Set `enable_registration: false`.

sudo systemctl restart matrix-synapse.service

sudo add-apt-repository ppa:certbot/certbot
sudo apt install nginx letsencrypt certbot python-certbot-nginx
sudo certbot --nginx # Make sure to include both `altpeter.me` and `matrix.altpeter.me`. Cronjob is automatically installed in `/etc/cron.d/certbot`

sudo systemctl start nginx.service
sudo systemctl enable nginx.service

sudo nano /etc/nginx/sites-available/matrix # Copy the Nginx config from below
sudo ln -s /etc/nginx/sites-available/matrix /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx.service

sudo apt install postgresql
sudo -i -u postgres
psql
> CREATE USER "matrix" WITH PASSWORD 'pw';
> CREATE DATABASE synapse ENCODING 'UTF8' LC_COLLATE='C' LC_CTYPE='C' template=template0 OWNER "matrix";
> \q
exit

sudo apt install python3-psycopg2

sudo nano /etc/matrix-synapse/homeserver.yaml
# Set: `max_upload_size: 100M`
# Set the `database` section as follows:
# database:
#     name: psycopg2
#     args:
#         user: matrix
#         password: pw
#         database: synapse
#         host: 127.0.0.1
#         cp_min: 5
#         cp_max: 10

sudo systemctl restart matrix-synapse.service

sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 8448

sudo ufw enable
sudo ufw status

register_new_matrix_user -c /etc/matrix-synapse/homeserver.yaml http://localhost:8008
```

### Nginx config

```nginx
server {
       listen 80;
       listen [::]:80;  
       server_name altpeter.me;
       return 301 https://$server_name$request_uri;
}

server {
        listen 443 ssl http2;
        listen [::]:443 ssl http2;
        server_name matrix.altpeter.me;

        ssl_certificate /etc/letsencrypt/live/altpeter.me/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/altpeter.me/privkey.pem;
        ssl_trusted_certificate /etc/letsencrypt/live/altpeter.me/fullchain.pem;

  client_max_body_size 2G;

        location /_matrix {
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header Host $host;
                proxy_pass http://localhost:8008;
        }

        location /.well-known/matrix/server {
                return 200 '{"m.server": "matrix.altpeter.me:443"}';
                add_header Content-Type application/json;
        }
        location /.well-known/matrix/client {
                return 200 '{"m.homeserver": {"base_url": "https://matrix.altpeter.me"},"m.identity_server": {"base_url": "https://vector.im"}}';
                add_header Content-Type application/json;
                add_header "Access-Control-Allow-Origin" *;
        }
}

server {
        listen 8448 ssl default_server;
        listen [::]:8448 ssl default_server;
        server_name altpeter.me;

        ssl_certificate /etc/letsencrypt/live/altpeter.me/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/altpeter.me/privkey.pem;
        ssl_trusted_certificate /etc/letsencrypt/live/altpeter.me/fullchain.pem;

        location / {
                proxy_pass http://localhost:8008;
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header X-Forwarded-Proto $scheme;
                proxy_set_header Host $host;
        }

}
```

## Move media to a Hetzner volume

Create the volume `synapse-data` in the Hetzner web interface. Then, mount it like this (see web interface for volume ID):

```sh
mkfs.ext4 -F /dev/disk/by-id/scsi-0HC_Volume_25004672
mkdir /mnt/synapse-data
echo "/dev/disk/by-id/scsi-0HC_Volume_25004672 /mnt/synapse-data ext4 discard,nofail,defaults 0 0" >> /etc/fstab
mount -a
```

Copy the existing media over:

```sh
systemctl stop matrix-synapse.service
cp -R /var/lib/matrix-synapse/media /mnt/synapse-data
chown -R matrix-synapse:nogroup /mnt/synapse-data/media
mv /var/lib/matrix-synapse/media /var/lib/matrix-synapse/media.old
```

In `/etc/matrix-synapse/homeserver.yaml`, set `media_store_path` to `/mnt/synapse-data/media`.

Start Synapse (`systemctl start matrix-synapse.service`) and check whether media still load.

If everything still works, you can delete the old media folder:

```sh
rm -R /var/lib/matrix-synapse/media.old
``` 

## Upgrading

Check if there are [update notes](https://github.com/matrix-org/synapse/blob/master/UPGRADE.rst) for the new version.  
Updates are done using APT: `apt update && apt upgrade`

### Upgrading Postgres

Synapse will refuse to start if the Postgres version is too low. Upgrade as follows ([1](https://web.archive.org/web/20221126103804/https://www.paulox.net/2022/04/28/upgrading-postgresql-from-version-13-to-14-on-ubuntu-22-04-jammy-jellyfish/)):

Create a Hetzner snapshot just in case. Then, first stop Synapse:

```sh
systemctl stop matrix-synapse.service
```

A newer Postgres version may have already been installed in an Ubuntu upgrade. If the newer version has not been installed yet, do that:

```sh
apt install postgresql-<new version>
```

Installing the new version will automatically create an empty cluster. Check using:

```sh
pg_lsclusters
```

If you don't know which version holds the current database, you can check their disk size:

```sh
du -sh /var/lib/postgresql/*
```

Remove the emtpy cluster and upgrade the existing one for the older version:

```sh
pg_dropcluster <new version> main --stop
pg_upgradecluster <old version> main
```

Observe that the new cluster is now online on port 5432, start Synapse and verify that everything works:

```sh
pg_lsclusters
systemctl start matrix-synapse.service
```

Then, you can remove the old cluster and the corresponding packages:

```sh
pg_dropcluster <old version> main --stop
apt purge postgresql-<old version> postgresql-client-<old version>
```

### Config merge

When the config changes, APT will usually ask you what to do. First, choose `D` to see if the changes are signficant. If so, make note of the config options we need to keep. These are usually:

```yaml
domain: matrix.altpeter.me

database:
    name: psycopg2
    args:
        user: matrix
        password: pw
        database: synapse
        host: 127.0.0.1
        cp_min: 5
        cp_max: 10

enable_registration: false

suppress_key_server_warning: true

media_store_path: "/mnt/synapse-data/media"
max_upload_size: 100M

# The email settings don't currently work and cause the service to crash on startup for some reason. :(
# email:
#     enable_notifs: true 
#     smtp_host: "smtp.eu.mailgun.org"
#     smtp_port: 587 # SSL: 465, STARTTLS: 587
#     smtp_user: "synapse@mail.altpeter.me"
#     smtp_pass: "pass"
#     require_transport_security: true 
#     notif_from: "Synapse on matrix.altpeter.me <noreply@mail.altpeter.me>"
#     app_name: Matrix
```

Then, choose `Z` to start a shell, run `nano /etc/matrix-synapse/homeserver.yaml.dpkg-new` to edit the (new) config and reenter the old values.

Once you are done, run `exit` and finally choose `Y` to accept the changes.

To check the server version: `curl http://localhost:8008/_synapse/admin/v1/server_version`

## References

* https://www.natrius.eu/dokuwiki/doku.php?id=digital:server:matrixsynapse
* https://github.com/matrix-org/synapse/blob/master/docs/federate.md
* https://github.com/matrix-org/synapse/blob/master/docs/reverse_proxy.rst
* https://github.com/matrix-org/synapse/blob/master/UPGRADE.rst
