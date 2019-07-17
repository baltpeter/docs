---
title: X2Go remote desktop
---

This VM is used by board members of the Datenanfragen.de e. V. to remotely access accounting and general management tools. It uses X2Go for remote connections over SSH (port `2222`). Board members have been given access to the credentials for the user `vorstand` that can be used to connect.

## Setup

Start with a Debian minimal installation.

Install XFCE: `apt-get install task-xfce-desktop`

Add the X2Go repo:

```sh
apt-key adv --recv-keys --keyserver keys.gnupg.net 0xE1F958385BFE2B6E
echo 'deb http://packages.x2go.org/debian stretch extras main' | tee /etc/apt/sources.list.d/x2go.list
apt-get update
apt-get install x2go-keyring && apt-get update
```

Install X2Go server: `apt-get install x2goserver x2goserver-xsession`

Change the SSH port to `2222` in `/etc/ssh/sshd_config`: `Port 2222` and restart the service: `service ssh restart`

Add a user `vorstand`:

```sh
useradd vorstand -s /bin/zsh
mkdir /home/vorstand
mkdir /home/vorstand/.ssh
chmod 700 /home/vorstand
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDsC5iR0V2Jq4rWShs56uF+4TWGYon9Mfo1ggJztlZVGZMOA30AtXfbXiBksLrKE2zp0TN9/JXKOzwFjsicXpRWvr5YzZWESe1G76ACaKsgVwyl/sHQ+5lZQASI0xkLd+9w/zOrr6KToVfD2xrhgUWjF1a61g3lUEmTYVtCiK/phFQz67F2lo4AjqqfVwcmkvTRuG9t3XaQDCXfFMxj8xCzM8OSTMZqPre8zvLwU808G8uWSiLFGey34Ggdlluh8CRshb6O3bbAl4d5vep9Azi0FTxtCpRi1n1R4Q/ek9ZuyJL0AQ7qbrkV8djZ3n1b2rYDNy6Fx2KvZhzPMLGA9+rzrYlw4zdPZ6bYd4oUhhNCasMtLyPoWf6cr44hyg0BWr6uFFREqc2aWLHSnduoLw7klgicu+CZEAUVPRYA5KFklBvGKTFPmkIKg9ebNusv2nNptQXhCujW0BBq1M92F75N/LBm6MR0Yqk179HsiYBtRpfUh0CbiKTZv3FBqOlJ9Jong/KlaXOdPdDBTLK3QXJHTp90bniB3NxLLUiqx5YjbxPpPyoSsivvsZ9ASi2ZRgSR98BvEkJtuuwqNBQRycFdH2MAbRNfRtX5bXrqh3K/tUvliyd7a/964Km8wOUWFm7ZbAMa9oSiDUZk8i96XK+hmxOg7A07XK35h834mxVqFw== vorstand@datenanfragen.de" > /home/vorstand/.ssh/authorized_keys
chmod 400 /home/altpeter/.ssh/authorized_keys
chown -R vorstand:vorstand /home/vorstand
echo 'vorstand ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
```
