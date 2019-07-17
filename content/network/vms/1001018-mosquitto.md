---
title: Mosquitto
---

The Mosquitto service acts as an MQTT broker for smart home devices. It runs at `10.1.1.18`.

## Setup

1. Install: `apt-get install mosquitto mosquitto-clients`
2. Create password file with user `mosquitto`: `mosquitto_passwd -c /etc/mosquitto/passwd mosquitto` and enter desired password twice.
3. Write the following config into `/etc/mosquitto/conf.d/default.conf`:  
    ```
    allow_anonymous false
    password_file /etc/mosquitto/passwd
    ```
4. Restart Mosquitto: `systemctl restart mosquitto`

## Authentication

The username is set to `mosquitto` and the password is documented in 1Password.
