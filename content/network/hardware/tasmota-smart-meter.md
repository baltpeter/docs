---
title: Tasmota smart meter interface
---

We're using Tasmota's [smart meter interface](https://tasmota.github.io/docs/Smart-Meter-Interface) on an ESP8266 (D1 Mini) to read out values from our electricity meters ([Iskra MT 174](https://www.camax.co.uk/downloads/MT174-Techical-Description.pdf) and [DZG DWS7420.1.G2](https://iot-shop.de/web/content/32881?download=true)) through the optical ports using a [read head](https://www.ebay.de/itm/353940190755).

## Setup

Based on [1](https://tasmota.github.io/docs/Smart-Meter-Interface/) and [2](https://tasmota.github.io/docs/Compile-your-build/).

1. Clone `git@github.com:arendst/Tasmota.git`.
1. Open with VSCode, PlatformIO needs to be installed.
1. In the bottom bar, click on the button for *Switch PlatformIO Platform Environment* and select `env:tasmota`.
1. Under `/tasmota`, create a file `user_config_override.h` if that doesn't exist already.
1. Paste the following into that file, right before the final `#endif`:

   ```c
   #ifndef USE_SCRIPT
   #define USE_SCRIPT
   #endif
   #ifndef USE_SML_M
   #define USE_SML_M
   #endif
   #ifdef USE_RULES
   #undef USE_RULES
   #endif
   ```
1. Connect the ESP via USB and click *PlatformIO: Build, Upload and Monitor* in the bottom bar. Once the upload is finished, close the terminal.
1. Connect the device to WiFi, either by connecting to the temporary AP or using the [Tasmota web installer](https://tasmota.github.io/install/).
1. Make note of the IP address (10.0.0.240) and visit the web interface.
1. Under *Configuration* and *Configure Module*, set *Module type* to *Generic (0)* and make sure that all GPIOs are set to *None* (you may need to first save and reboot).
1. Under *Configuration* and *MQTT*, connect to the MQTT server (cf. [VMs/Home Assistant]({{< ref "network/vms/1001019-homeassistant" >}})). Use `tasmota_smart_meter` as the topic.
1. Under *Configuration* and *Other*, set *Device Name* to `tasmota-smart-meter` and *Friendly Name 1* to `Tasmota Smart Meter`.
1. Under *Tools* and *Console*, run `SetOption19 0` to enable native discovery for Home Assistant. Further, run `TelePeriod 30` to transmit values over MQTT every 30 seconds.
1. Connect the two read heads to the ESP:

    | Meter | Pin read head | Pin ESP |
    | - | - | - |
    | both | VBUS | 3V3 |
    | both | GND | GND |
    | Iskra | RX | D1 (GPIO5) |
    | Iskra | TX | D2 (GPIO4) |
    | DZG | RX | D5 (GPIO14) |
    | DZG | TX | D6 (GPIO12) |
1. In the web interface, under *Tools* and *Edit script*, select *Script enable*, then paste the following script:

```
>D
res=0
scnt=0

>B
->sensor53 r
->sensor53 d0

;For this Example in the >F section  
>F
;count 100ms   
scnt+=1  
switch scnt  
case 6  
;set sml driver to 300 baud and send /?! as HEX to trigger the Meter   
res=sml(1 0 300)  
res=sml(1 1 "2F3F210D0A")  
;1800ms later \> Send ACK and ask for switching to 9600 baud  
case 18  
res=sml(1 1 "063035300D0A")  
;2000ms later \> Switching sml driver to 9600 baud    
case 20  
res=sml(1 0 9600)   
;Restart sequence after 50x100ms    
case 500  
; 5000ms later \> restart sequence    
scnt=0  
ends

>M 2

; original: +1,5,o,0,9600,Iskra,4
+1,5,o,16,9600,Iskra,4
1,1-0:1.8.0*255(@1,Bezug gesamt,kWh,bezug_gesamt,3
1,1-0:2.8.0*255(@1,Einspeisung gesamt,kWh,einspeisung_gesamt,3
1,1-0:1.7.0*255(@1,Bezug aktuell,kW,bezug_aktuell,3
1,1-0:2.7.0*255(@1,Einspeisung aktuell,kW,einspeisung_aktuell,3

+2,14,s,16,9600,DZG
2,77070100010800ff@1000,Erzeugung gesamt,kWh,erzeugung_gesamt,4
2,77070100100700ff@1000,Erzeugung aktuell,kW,momentane_wirkleistung,4
#
```

## Home Assistant integration

problem: https://github.com/home-assistant/core/issues/104305

in `customize.yaml`:

```yaml
# Benni (2024-04-13): Changes necessary for tasmota-smart-meter sensor to have correct attributes (see Hardware/Tasmota smart meter).
# Note: We are not touching the *_gesamt sensors here. For those, we have template sensors in configuration.yaml that filter out 0 values.
sensor.tasmota_smart_meter_iskra_bezug_aktuell:
    device_class: power
    state_class: measurement
    unit_of_measurement: kW
sensor.tasmota_smart_meter_iskra_einspeisung_aktuell:
    device_class: power
    state_class: measurement
    unit_of_measurement: kW
sensor.tasmota_smart_meter_dzg_erzeugung_aktuell:
    device_class: power
    state_class: measurement
    unit_of_measurement: kW
```

in `/homeassistant/configuration.yaml`:

```yaml
# Benni (2024-04-14): tasmota-smart-meter will sometimes (at boot?) send out 0 values, which cause the energy dashboard
# to hallucinate a doubling in the energy usage. Workaround taken from: https://community.home-assistant.io/t/filter-0-values-from-total-enery/503848/2
template:
  - sensor:
      - name: "Bezug gesamt"
        unit_of_measurement: kWh
        state: >
          {% set state1 = states('sensor.tasmota_smart_meter_iskra_bezug_gesamt')|float(none) %}
          {% if state1 > 0 %}
            {{ state1 }}
          {% endif %}
        device_class: energy
        state_class: total_increasing
        unique_id: iskra_bezug_gesamt
        availability: >
          {{ state1 != none }}
      - name: "Einspeisung gesamt"
        unit_of_measurement: kWh
        state: >
          {% set state2 = states('sensor.tasmota_smart_meter_iskra_einspeisung_gesamt')|float(none) %}
          {% if state2 > 0 %}
            {{ state2 }}
          {% endif %}
        device_class: energy
        state_class: total_increasing
        unique_id: iskra_einspeisung_gesamt
        availability: >
          {{ state2 != none }}
      - name: "Erzeugung gesamt"
        unit_of_measurement: kWh
        state: >
          {% set state3 = states('sensor.tasmota_smart_meter_dzg_erzeugung_gesamt')|float(none) %}
          {% if state3 > 0 %}
            {{ state3 }}
          {% endif %}
        device_class: energy
        state_class: total_increasing
        unique_id: dzg_erzeugung_gesamt
        availability: >
          {{ state3 != none }}
```
