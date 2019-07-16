# Configuring the Logitech MX Vertical under Ubuntu

Install *xbindkeys* and *playerctl*: `apt install xbindkeys playerctl`

Run `xev | grep button` to find out the key codes. Press the buttons to reconfigure and note the values in the console.  
The *forward* and *backward* buttons have the following values:

```
state 0x10, button 9, same_screen YES
state 0x10, button 9, same_screen YES

state 0x10, button 8, same_screen YES
state 0x10, button 8, same_screen YES
```

Start with the default config file: `xbindkeys --defaults > ~/.xbindkeysrc`

Add the following lines to that file:

```
# Toggle media playback with the Logi mouse *backward* button
"playerctl play-pause"
    b:8

# Skip a track with the Logi mouse *forward* button
"playerctl next"
    b:9
```


Use `xbindkeys --poll-rc` to reload the config.
