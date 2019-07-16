# Useful things for Proxmox

* Check storage status: `pvesm status`
* Check quorum in cluster: `pvecm status`
* Test performance: `pveperf`
* Restart services: `systemctl restart corosync.service && systemctl restart pve-cluster.service && systemctl restart pvedaemon.service && systemctl restart pvestatd.service && systemctl restart pveproxy.service` ([1](https://gist.github.com/kevin39/ab9d68a50c9714f5acd9a69781e657fd), [2](https://forum.proxmox.com/threads/stopping-all-proxmox-services-on-a-node.34318/#post-168154), [3](https://pve.proxmox.com/wiki/Service_daemons))
* Forcefully kill LXC container: First try `lxc-stop [id] -k`. If that doesn't work, find the PID using `ps aux | grep lxc` and then `kill -9 [pid]`
* Start LXC container in foreground (useful for debugging start problems): `lxc-start [id] -F`
