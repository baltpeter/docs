---
title: macOS
---

**Note:** This documentation is nowhere near complete.

## Install brew

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

## Install software

```sh
brew install zsh
brew cask install firefox sublime-text 
```

## Configure Terminal

In the Terminal preferences, under *General*, set *On startup, open new window with profile* to *Pro*.

```sh
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## Configure system

### Finder

In the *Finder* preferences, under *General*, set *New Finder windows show* to the home folder; delete everything under *Tags*; under *Sidebar*, deselect *Recents*, *iCloud Drive*, *Back to my Mac*, *Documents* and *Recent Tags*; under *Advanced*, select *Show all filename extensions*, deselect *Show warning before changing an extension* and set *When performing a search* to *Search the Current folder*.

In the *Finder* menubar, under *View*, select *Show Tab Bar*, *Show Path Bar*, *Show Status Bar* and *Show Preview*.

[Show hidden files](https://ianlunn.co.uk/articles/quickly-showhide-hidden-files-mac-os-x-mavericks/): `defaults write com.apple.finder AppleShowAllFiles YES`

### Font smoothing

```sh
defaults write -g CGFontRenderingFontSmoothingDisabled -bool NO
defaults write NSGlobalDomain AppleFontSmoothing -int 2
```
