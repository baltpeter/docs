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

## Adding a new disk

In the interface, go to the node and the *Disks* tab. Select the disk and click *Initialize disk with GPT*. Next, go to the *LVM-Thin* tab and click *Create: Thinpool*. Select the disk, give it a name, make sure *Add Storage* is checked and click *Create*.

## NFS mounts

See [reference/linux](/reference/linux#nfs-mounts) for how to deal with unresponsive NFS mounts.

To set the `soft` mount option in Proxmox, edit `/etc/pve/storage.cfg` and set `options vers=3,soft` for the applicable mounts. ([1](https://forum.proxmox.com/threads/nfs-share-dead-backups-frozen.11033/#post-60777))

## LXC container not starting

### Failed to create veth pair

Error message when starting in foreground:

```
lxc-start: 1001015: network.c: instantiate_veth: 106 Operation not permitted - Failed to create veth pair "veth1001015i0" and "veth6AIO43"
lxc-start: 1001015: network.c: lxc_create_network_priv: 2462 Failed to create network device
lxc-start: 1001015: start.c: lxc_spawn: 1646 Failed to create the network
lxc-start: 1001015: start.c: __lxc_start: 1989 Failed to spawn container "1001015"
lxc-start: 1001015: tools/lxc_start.c: main: 330 The container failed to start
lxc-start: 1001015: tools/lxc_start.c: main: 336 Additional information can be obtained by setting the --logfile and --logpriority options
```

Try ([1](https://carolinafernandez.github.io/deployment/2018/03/11/Find-remove-veth-for-LXC)):

```sh
# Lookup the name of the veth associated with the affected VM.
cat /var/lib/lxc/[id]/config
# There will be a line like this: `lxc.net.0.veth.pair = veth1001015i0`

# Delete that veth.
ip link delete [veth1001015i0]
```

If that doesn't work, restart the node.

### Failed to create cgroup

Error message when starting in foreground:

```
lxc-start: 1001015: cgroups/cgfsng.c: mkdir_eexist_on_last: 1301 File exists - Failed to create directory "/sys/fs/cgroup/systemd//lxc/1001015"
lxc-start: 1001015: cgroups/cgfsng.c: container_create_path_for_hierarchy: 1353 Failed to create cgroup "/sys/fs/cgroup/systemd//lxc/1001015"
lxc-start: 1001015: cgroups/cgfsng.c: cgfsng_payload_create: 1526 Failed to create cgroup "/sys/fs/cgroup/systemd//lxc/1001015"
```

Try: `rm -rf /sys/fs/cgroup/systemd/lxc/[id]`  
Note that there may also be additional directories (`[id]-1` etc.)

If that doesn't work, restart the node.

## Removing a node from the cluster

This will also work for removing the second node from a two-node cluster and thus effectively reverting to an un-clustered setup ([1](https://forum.proxmox.com/threads/proxmox-cluster-2-nodes-how-to-remove-one-node-and-use-only-one.22983/#post-115588)).

1. List the nodes using `pvecm nodes` to find out the name of the node to remove.
2. Shutdown the node to remove. Make sure it never gets reconnected.
3. On the remaining node: Regain quorum via `pvecm expected 1`.
4. Remove the node from the cluster using `pvecm delnode [nodename]`.
5. If the node still shows up in the UI, run `rm -rf /etc/pve/nodes/[nodename]` ([2](https://forum.proxmox.com/threads/cluster-node-stuck-in-ui.42330/#post-203778)), then reload the webpage.
