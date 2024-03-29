---
title: Ubuntu 19.04
---

## Update system

```sh
apt update && apt upgrade && apt dist-upgrade

apt install unattended-upgrades apt-transport-https && dpkg-reconfigure unattended-upgrades
```

## Firefox

Install Firefox Nightly:

```sh
add-apt-repository ppa:ubuntu-mozilla-daily/ppa
apt install firefox-trunk
```

Install the *1Password X* Firefox addon and login.

Next, signin to *Firefox Sync*.

Go into the Firefox preferences. Under *General* and *Browsing*, select *Use autoscrolling* (or set `general.autoScroll` to `true` in `about:config`).

Note for the future: If scrolling becomes laggy, try [this solution](https://bugzilla.mozilla.org/show_bug.cgi?id=594876#c104).

Configure the following settings in `about:config`:

* [Disable middle-click pasting](https://wiki.archlinux.org/index.php/Firefox#Middle-click_behavior):  
    Set `middlemouse.paste` to `false`.
* Enable WebRender ([1](https://wiki.archlinux.org/index.php/Firefox/Tweaks#Enable_OpenGL_Off-Main-Thread_Compositing_.28OMTC.29), [2](https://www.reddit.com/r/firefox/comments/glh5l4/to_use_gpu_in_linux_should_i_enable/fqxb2jg/)):  
    Set `gfx.webrender.all` to `true`.
* [Enable hardware video decoding](https://www.omgubuntu.co.uk/2020/08/firefox-80-release-linux-gpu-acceleration):  
    Set `media.ffmpeg.vaapi.enabled` to `true`.
* [Disable beacon](https://www.privacytools.io/browsers/#about_config):  
    Set `beacon.enabled` to `false`.
* [Disable safe browsing](https://www.privacytools.io/browsers/#about_config) (the bad parts, anyway):  
    Set `browser.safebrowsing.downloads.remote.enabled` to `false` (also do that for Thunderbird).

## Setup environment

Get rid of the Amazon integration by running: `apt purge ubuntu-web-launchers`

### Shell

```sh
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P ~/.fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P ~/.fonts
fc-cache -f -v

apt install zsh
chsh -s /bin/zsh
```

### Printers

* Disable automatic adding of network printers: `systemctl stop cups-browsed && systemctl disable cups-browsed` ([1](https://askubuntu.com/a/369122))

### Gnome

* [Switch the Alt-Tab view](https://blogs.gnome.org/fmuellner/2018/10/11/the-future-of-alternatetab-and-why-you-need-not-worry/): Go into the *Keyboard* preferences and change the *Switch windows* option to *Alt + Tab*. Further set *Switch applications* to *Super + Tab*.
* Install the *Gnome Tweak Tool*: `apt install gnome-tweak-tool`
* In the *Gnome Tweak Tool*, under *Top Bar*, select *Weekday*, *Seconds*, and *Week Numbers*. Under *Windows*, deselect *Attach Modal Dialogs*. Under *Workspaces*, select *Workspaces om primary display only*. :(
* [Disable the dock](https://www.linuxuprising.com/2018/08/how-to-remove-or-disable-ubuntu-dock.html): `gsettings set org.gnome.shell.extensions.dash-to-dock autohide false && gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false && gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false`
* In the settings dialog, under *Devices* and *Mouse & Touchpad*, bump the *Mouse Speed* to the maximum value. Under *Search*, disable *Passwords and Keys* and *Ubuntu Software*. Under *Devices* and *Displays*, enable *Night Light*. Under *Privacy* and *Usage & History*, disable *Recently Used*.
* In the *gedit* preferences, under *View*, select *Display line numbers*, *Highlight current line* and *Highlight matching brackets*. Under *Editor*, set the *Tab width* to 4 and select *Insert spaces instead of tabs* and *Enable automatic indentation*. Under *Fonts & Colors*, select *Solarized Dark* as the *Color Scheme*. Under *Plugins*, enable *Quick Highlight*.

### GPG

[Mitigate SKS key server problems](https://gist.github.com/rjhansen/67ab921ffb4084c865b3618d6955275f#mitigations):

1. In `~/.gnupg/gpg.conf`, ensure there is no line starting with `keyserver`. If there is, remove it.
2. Add the line `keyserver hkps://keys.openpgp.org` to the end of `~/.gnupg/dirmngr.conf`.

**TODO:** Investigate [parcimonie.sh](https://github.com/EtiennePerot/parcimonie.sh).

### NTP

For fun, set the NTP servers used to the ones offered by the [PTB](https://www.ptb.de/cms/en/ptb/fachabteilungen/abtq/gruppe-q4/ref-q42/time-synchronization-of-computers-using-the-network-time-protocol-ntp.html) ([1](https://askubuntu.com/a/844996)):

In `/etc/systemd/timesyncd.conf`, uncomment the `#NTP=` line and change it to: `NTP=ptbtime1.ptb.de ptbtime2.ptb.de ptbtime3.ptb.de`

Force a re-sync using `systemctl restart systemd-timesyncd` and finally check that the servers have been set correctly using `systemctl status systemd-timesyncd.service`.

## SSH

Generate an SSH key using `ssh-keygen -o -a 100 -t ed25519` (see [here](https://blog.g3rt.nl/upgrade-your-ssh-keys.html)). Upload the corresponding public key to: GitLab, GitHub

Import the SSH key from Seafile.

Install the SSH server: `apt install openssh-server` and set the following directives in `/etc/ssh/sshd_config`:

```
PermitRootLogin no
PasswordAuthentication no
UseDNS no
```

In `/etc/ssh/ssh_config`, comment out the following directive to [disable forwarding the locale to remote servers](https://askubuntu.com/a/530829):

```
#   SendEnv LANG LC_*
```

and disable `known_hosts` hashing:

```
HashKnownHosts no
```

Then, restart the SSH server: `service ssh restart`

## Gnome extensions

Install the [Firefox addon](https://extensions.gnome.org/) and make sure the shell integration is installed: `apt install chrome-gnome-shell`

Install the following extensions:

* https://extensions.gnome.org/extension/1160/dash-to-panel/
* https://extensions.gnome.org/extension/517/caffeine/
* https://extensions.gnome.org/extension/750/openweather/
* https://extensions.gnome.org/extension/906/sound-output-device-chooser/
* https://extensions.gnome.org/extension/19/user-themes/
* https://extensions.gnome.org/extension/1236/noannoyance/
* https://extensions.gnome.org/extension/120/system-monitor/ (has dependencies: `apt install gir1.2-gtop-2.0 gir1.2-networkmanager-1.0 gir1.2-clutter-1.0`)
* https://extensions.gnome.org/extension/1228/arc-menu/
* https://extensions.gnome.org/extension/779/clipboard-indicator/ (Disable *Show notification on copy* and *Keyboard shortcuts* in the settings.)
* https://extensions.gnome.org/extension/21/workspace-indicator/

Configure *Dash to Panel* as follows: Under *Position* and *Multi-monitor options*, enable *Isolate monitors* and disable *Display favorite applications on all monitors*. Under *Style*, set the *Panel Size* to 40. Under *Behavior*, disable *Show favorite applications*, disable *Show Applications button*, enable *Isolate Workspaces* and enable *Ungroup applications*. Under the *Window preview options*, set *Time (ms) before showing* to 1000. Under *Fine-Tune*, disable *Animate switching applications* and *Animate launching new windows* and enable *Activate panel menu buttons (e.g. date menu) on click only*.
These settings can also be imported from the file `configs/dash-to-panel`.

## Gnome theme

In the *Gnome Tweak Tool*, under *Appearance*, select *Adwaita-dark* for *Applications* and *Yaru* for all other theme options.

In a terminal, go into *Edit* and *Preferences*. Under the unnamed profile and *Colors*, uncheck *Use colors from system theme* and select *Tango Dark* under *Built-in schemes*.

Maybe consider also [styling QT](https://wiki.archlinux.org/index.php/Uniform_look_for_Qt_and_GTK_applications) in the future.

## Install software

### Essential

```sh
dpkg --add-architecture i386

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
add-apt-repository ppa:stebbins/handbrake-releases
curl https://build.opensuse.org/projects/home:manuelschneid3r/public_key | apt-key add -
echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_18.10/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list
wget -qO- https://dl.winehq.org/wine-builds/winehq.key | apt-key add -
apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ cosmic main'
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
echo "deb https://download.virtualbox.org/virtualbox/debian disco contrib" | tee /etc/apt/sources.list.d/virtualbox.list
curl -s https://syncthing.net/release-key.txt | apt-key add -
echo "deb https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list
add-apt-repository ppa:bit-team/stable
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
apt update

apt install curl telegram-desktop vlc sublime-text audacity gimp inkscape flatpak xdg-desktop-portal xdg-desktop-portal-gtk ffmpeg handbrake-gtk gnome-boxes virtualbox-6.0 albert units gparted nodejs yarn imagemagick pandoc wireshark gnome-sushi nfs-common wngerman syncthing build-essential backintime-qt4 whois gnome-contacts evolution exa spotify-client spotify-client-gnome-support subversion golang-go
apt install --install-recommends winehq-stable winetricks
snap install hugo --channel=extended
snap install skype --classic
flatpak install flathub org.gnome.FeedReader
yarn global add tldr

curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl

wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash

curl https://raw.githubusercontent.com/srevinsaju/zap/main/install.sh | sudo bash -s
# As local user.
zap daemon --install
```

### Optional

```sh
add-apt-repository ppa:sebastian-stenzel/cryptomator
add-apt-repository ppa:x2go/stable
add-apt-repository ppa:unit193/encryption
add-apt-repository ppa:peek-developers/stable
apt update

apt install keepassxc cryptomator blender x2goclient chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg-extra mediathekview binwalk hashcat steam peek qtcreator qt5-default
apt install texlive texlive-lang-german texlive-latex-extra texlive-generic-extra latexmk texlive-xetex
snap install insomnia veracrypt
flatpak install --from https://tabos.gitlab.io/project/rogerrouter/roger.flatpakref

lpadmin -p Roger-Router-Fax -m drv:///sample.drv/generic.ppd -v socket://localhost:9100/ -E -o PageSize=A4

zap install cura
zap install --github --from logseq/logseq
```

## Calendar and contact sync with Nextcloud

In the settings dialog under *Online Accounts*, add a Nextcloud account. If 2FA is enabled for Nextcloud, create a new app password before.

### Legacy

**Note:** These instructions are not necessary anymore. Instead, follow the steps above.

Gnome Calendar and Contacts can sync with CalDAV and CardDAV servers, they just don't expose that functionality through their UI. Instead, the servers need to be added to Evolution. ([1](https://www.ctrl.blog/entry/gnome-caldav.html))

To add the CalDAV server (for use in Gnome Calendar), open Evolution and in the *File* menu under *New*, click *Calendar*. Select the type *CalDAV*. Enter the calendar's *Name* and select a *Color*. Then enter the calendar's link for the *URL* and specify the *User*. Click *Apply*. ([2](https://help.gnome.org/users/evolution/stable/calendar-caldav.html.en))  
If 2FA is enabled for Nextcloud, create a new app password to use.

To add the CardDAV server (for use in Gnome Contacts), open Evolution and in the *File* menu under *new*, click *Address Book*. Select the type *CardDAV*. Specify a *Name* and the *URL*.

## Backups

### Back In Time

**TODO:** Currently not in use.

Run Back In Time as root. Under *General*, set *Where to save snapshots* to `/mnt/backintime` and set the schedule to *Repeatedly (anachron)* and every hour. Under *Include*, add `/`. Under *Auto-remove*, enable *Smart remove* with the default settings.

### Vorta

**TODO:** Backup to `backup1` using [Vorta](https://github.com/borgbase/vorta).

### Syncthing

**TODO:** Syncthing is currently not in use.

Set Syncthing to start automatically:

```sh
mkdir -p ~/.config/systemd/user
wget https://raw.githubusercontent.com/syncthing/syncthing/master/etc/linux-systemd/user/syncthing.service -O ~/.config/systemd/user/syncthing.service
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
```

Increase the inotify limit: `echo "fs.inotify.max_user_watches=204800" | tee -a /etc/sysctl.conf`

The web UI is then available at `http://127.0.0.1:8384/`.
