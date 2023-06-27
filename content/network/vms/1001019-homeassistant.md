---
title: Home Assistant
---

Home Assistant server to use for smart home devices. The integrated MQTT server is not used, instead we use a separate Mosquitto server at `10.1.1.18`.

## Setup

1. Install according to: https://www.home-assistant.io/docs/installation/raspberry-pi/
2. Setup autostart according to: https://www.home-assistant.io/docs/autostart/systemd/
3. Set the MQTT broker settings in `/home/homeassistant/.homeassistant/configuration.yaml` as follows:
    ```
    mqtt:
      broker: 10.1.1.18
      username: mosquitto
      password: pw
    ```
4. Restart hass: `systemctl restart homeassistent.service`.

## Access

The web interface can be accessed at: http://10.1.1.19:8123

## Add Sonoff device

Configure the Sonoff device as follows:

```
MQTT Host:    10.1.1.18
MQTT Port:    1883
MQTT User:    mosquitto
MQTT Pass:    [pw]
MQTT Topic:   [unique identifier]
```

Add the following entry to `/home/homeassistant/.homeassistant/configuration.yaml` (`light` can be replaced with `switch`):

```
light:
  - platform: mqtt
    name: "[insert description]"
    state_topic: "stat/[insert MQTT topic]/RESULT"
    value_template: '{{ value_json["POWER"] }}'
    command_topic: "cmnd/[insert MQTT topic]/POWER"
    availability_topic: "tele/[insert MQTT topic]/LWT"
    qos: 1
    payload_on: "ON"
    payload_off: "OFF"
    payload_available: "Online"
    payload_not_available: "Offline"
```

Note: I previously had `retain: true`. That turned out to be a mistake that caused ghost switching. For more details and how to clear the retained messages, see [1](https://www.youtube.com/watch?v=dbSw6VkI-x4).

Restart hass: `systemctl restart homeassistent.service`.

## Updates

see https://www.home-assistant.io/docs/installation/raspberry-pi/#updating
