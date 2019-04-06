# Setting up Ubuntu (18.10) machines

## Update system

```sh
apt update && apt upgrade && apt dist-upgrade

apt install unattended-upgrades apt-transport-https && dpkg-reconfigure unattended-upgrades
```

## Firefox

Install the *1Password X* Firefox addon and login.

Next, signin to *Firefox Sync*.

## Setup environment

Get rid of the Amazon integration by running: `apt purge ubuntu-web-launchers`

### Shell

```sh
apt install zsh
```

Then run the following both as root and user:

```sh
wget -O ~/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc && wget -O ~/.zshrc.local https://git.grml.org/f/grml-etc-core/etc/skel/.zshrc && chsh -s /bin/zsh
```

In the Terminal, go to *Edit* and *Preferences*. Under the unnamed profile and the *Command* tab, check *Run a custom command instead of my shell* and enter `/bin/zsh`.

### Gnome

* [Switch the Alt-Tab view](https://blogs.gnome.org/fmuellner/2018/10/11/the-future-of-alternatetab-and-why-you-need-not-worry/): Go into the *Keyboard* preferences and change the *Switch windows* option to *Alt + Tab*. Further set *Switch applications* to *Super + Tab*.
* Install the *Gnome Tweak Tool*: `apt install gnome-tweak-tool`
* In the *Gnome Tweak Tool*, under *Top Bar*, select *Weekday*, *Seconds*, and *Week Numbers*. Under *Windows*, deselect *Attach Modal Dialogs*. Under *Workspaces*, select *Workspaces om primary display only*. :(
* [Disable the dock](https://www.linuxuprising.com/2018/08/how-to-remove-or-disable-ubuntu-dock.html): `gsettings set org.gnome.shell.extensions.dash-to-dock autohide false && gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false && gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false`
* In the settings dialog, under *Devices* and *Mouse & Touchpad*, select *Natural Scrolling* and bump the *Mouse Speed* to the maximum value. Under *Search*, disable *Passwords and Keys* and *Ubuntu Software*. Under *Devices* and *Displays*, enable *Night Light*.
* In the *gedit* preferences, under *View*, select *Display line numbers*, *Highlight current line* and *Highlight matching brackets*. Under *Editor*, set the *Tab width* to 4 and select *Insert spaces instead of tabs* and *Enable automatic indentation*. Under *Fonts & Colors*, select *Solarized Dark* as the *Color Scheme*. Under *Plugins*, enable *Quick Highlight*.

## SSH

Generate an SSH key using `ssh-keygen -o -a 100 -t ed25519` (see [here](https://blog.g3rt.nl/upgrade-your-ssh-keys.html)). Upload the corresponding public key to: GitLab, GitHub

Import the SSH key from Seafile.

Install the SSH server: `apt install openssh-server` and set the following directives in `/etc/ssh/sshd_config`:

```
PermitRootLogin no
PasswordAuthentication no
UseDNS no
```

Then, restart the SSH server: `service ssh restart`

## Gnome extensions

Install the [Firefox addon](https://extensions.gnome.org/) and make sure the shell integration is installed: `apt install chrome-gnome-shell`

Install the following extensions:

* https://extensions.gnome.org/extension/517/caffeine/
* https://extensions.gnome.org/extension/600/launch-new-instance/
* https://extensions.gnome.org/extension/18/native-window-placement/
* https://extensions.gnome.org/extension/750/openweather/
* https://extensions.gnome.org/extension/8/places-status-indicator/
* https://extensions.gnome.org/extension/7/removable-drive-menu/
* https://extensions.gnome.org/extension/906/sound-output-device-chooser/
* https://extensions.gnome.org/extension/602/window-list/
* https://extensions.gnome.org/extension/921/multi-monitors-add-on/
* https://extensions.gnome.org/extension/19/user-themes/
* https://extensions.gnome.org/extension/1236/noannoyance/
* https://extensions.gnome.org/extension/120/system-monitor/ (has dependencies: `apt install gir1.2-gtop-2.0 gir1.2-networkmanager-1.0 gir1.2-clutter-1.0`)
* https://extensions.gnome.org/extension/118/no-topleft-hot-corner/

## Gnome theme

In the *Gnome Tweak Tool*, under *Appearance*, select *Yaru* for all theme options.

In a terminal, go into *Edit* and *Preferences*. Under the unnamed profile and *Colors*, uncheck *Use colors from system theme* and select *Tango Dark* under *Built-in schemes*.

### Essentials

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
curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
echo "deb https://download.virtualbox.org/virtualbox/debian cosmic contrib" | tee /etc/apt/sources.list.d/virtualbox.list
curl -s https://syncthing.net/release-key.txt | apt-key add -
echo "deb https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list
apt update

apt install curl telegram-desktop vlc sublime-text audacity gimp inkscape flatpak xdg-desktop-portal xdg-desktop-portal-gtk ffmpeg handbrake-gtk gnome-boxes virtualbox-6.0 albert units gparted nodejs yarn imagemagick pandoc wireshark gnome-sushi nfs-common wngerman syncthing
apt install --install-recommends winehq-stable winetricks
snap install spotify whatsdesk
snap install hugo --channel=extended
snap install skype --classic
flatpak install flathub org.gnome.FeedReader
yarn global add tldr

curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
chmod a+rx /usr/local/bin/youtube-dl
```

### Additionals

```sh
add-apt-repository ppa:sebastian-stenzel/cryptomator
add-apt-repository ppa:x2go/stable
add-apt-repository ppa:unit193/encryption
apt update

apt install keepassxc cryptomator blender x2goclient chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg-extra mediathekview binwalk hashcat steam
snap install insomnia veracrypt
flatpak install --from https://tabos.gitlab.io/project/rogerrouter/roger.flatpakref

lpadmin -p Roger-Router-Fax -m drv:///sample.drv/generic.ppd -v socket://localhost:9100/ -E -o PageSize=A4  
```

## Syncthing

Set Syncthing to start automatically:

```sh
mkdir -p ~/.config/systemd/user
wget https://raw.githubusercontent.com/syncthing/syncthing/master/etc/linux-systemd/user/syncthing.service -O ~/.config/systemd/user/syncthing.service
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
```

Increate the inotify limit: `echo "fs.inotify.max_user_watches=204800" | tee -a /etc/sysctl.conf`

The web UI is then available at `http://127.0.0.1:8384/`.

## Firefox

Go into the Firefox preferences. Under *General* and *Browsing*, select *Use autoscrolling*.

Note for the future: If scrolling becomes laggy, try [this solution](https://bugzilla.mozilla.org/show_bug.cgi?id=594876#c104).
