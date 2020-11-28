---
title: Mayan EDMS
---

Installed at `10.1.1.8`. Not actually in use.

## Setup

The setup is based on the [official install documentation](https://web.archive.org/web/20201128160635/https://docs.mayan-edms.com/chapters/docker/install_docker_compose.html).

```sh
wget -qO- https://get.docker.com/ | sh
curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

mkdir /root/mayan
cd /root/mayan
curl https://gitlab.com/mayan-edms/mayan-edms/-/raw/master/docker/docker-compose.yml -O
# Fill with the env file listed below.
nano .env
docker-compose --project-name mayan config
# Will already restart after a reboot.
docker-compose --project-name mayan up --detach
```

Open `http://10.1.1.8` in the browser and login using the details shown. Then, go *User* and *Edit details* to change the email address, and *User* and *Change password* to change the password.

## Updates

TODO

## Configs

### Env file

```sh
MAYAN_REDIS_PASSWORD=<pw>
MAYAN_DATABASE_PASSWORD=<pw>
```
