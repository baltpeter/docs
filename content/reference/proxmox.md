---
title: Proxmox
---

## Useful commands and tasks

* Check storage status: `pvesm status`
* Check quorum in cluster: `pvecm status`
* Test performance: `pveperf`
* Restart services: `systemctl restart corosync.service && systemctl restart pve-cluster.service && systemctl restart pvedaemon.service && systemctl restart pvestatd.service && systemctl restart pveproxy.service` ([1](https://gist.github.com/kevin39/ab9d68a50c9714f5acd9a69781e657fd), [2](https://forum.proxmox.com/threads/stopping-all-proxmox-services-on-a-node.34318/#post-168154), [3](https://pve.proxmox.com/wiki/Service_daemons))
* Forcefully kill LXC container: First try `lxc-stop [id] -k`. If that doesn't work, find the PID using `ps aux | grep lxc` and then `kill -9 [pid]`
* Start LXC container in foreground (useful for debugging start problems): `lxc-start [id] -F`
* Stop an unresponsive backup: `vzdump -stop` ([1](https://forum.proxmox.com/threads/proxmox-backup-wont-stop.23219/#post-116382)) or `ps aux | grep vzdump`, `kill -9 [pid]` and then `pct unlock [vmid]` ([2](https://forum.proxmox.com/threads/proxmox-backup-wont-stop.23219/#post-116383))

## NFS mounts

See [reference/linux](/reference/linux#nfs-mounts) for how to deal with unresponsive NFS mounts.

To set the `soft` mount option in Proxmox, edit `/etc/pve/storage.cfg` and set `options vers=3,soft` for the applicable mounts. ([1](https://forum.proxmox.com/threads/nfs-share-dead-backups-frozen.11033/#post-60777))

