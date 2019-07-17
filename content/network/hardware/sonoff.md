---
title: Sonoff modules
---

All Sonoff modules run [Sonoff-Tasmota](https://github.com/arendst/Sonoff-Tasmota).

## Attic switches

These switches are used to control other Sonoff modules.

Go to `/co` and set the *Friendly Name 1* to something descriptive (e.g. *Attic switch 1*), save (will restart and reset any other config).  
Go to `/md` and set *Module type* to *Generic (18)*, save (will restart). Go back to `/md` and set *D2 GPIO4* to *Button2 (18)* and *D1 GPIO5* to *Button3 (19)*, save again. Make sure **not** to use *Button1 (17)* as that button can accidentally be used to reset the config. (You can also use the following template: `{"NAME":"Benni Switch","GPIO":[255,255,255,255,18,19,255,255,255,255,255,255,255],"FLAG":1,"BASE":18}`.)

Go to `/cs` and [configure the following rule](https://github.com/arendst/Sonoff-Tasmota/wiki/Rules#2-execute-any-mqtt-message-when-a-button-is-pressed):

```
Rule1 on button3#state do publish cmnd/light-large-attic/power toggle endon on button2#state do publish cmnd/light-small-attic/power toggle endon
```
Enable it with `Rule1 on`.

<!-- `ButtonTopic light-large-attic` -->
