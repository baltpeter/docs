---
title: Home Assistant
---

Home Assistant server to use for smart home devices. The integrated MQTT server is not used, instead we use a separate Mosquitto server at `10.1.1.18`.

## Setup

According to: https://community.home-assistant.io/t/installing-home-assistant-os-using-proxmox-8/201835

On the PVE host, run: `bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/vm/haos-vm.sh)"`

Settings:

* Version: 12.1
* VM ID: 1001031
* Machine type: i440fx
* Disk cache: write through
* Hostname: home-assistant
* CPU model: host
* CPU cores: 4
* RAM: 8192
* Bridge: vmbr0

Change IP according to: https://community.home-assistant.io/t/how-to-change-ip-adresse-in-cli/332205/22

Under *Settings* and *Add-ons*, install *ESPHome* and *File editor*. Enable *Show in sidebar* for both.

In the *File editor*, create the file `/homeassistant/customize.yaml`. Then, open `/homeassistant/configuration.yaml` and append the following:

```yaml
homeassistant:
    customize: !include customize.yaml
```
