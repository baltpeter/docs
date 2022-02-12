---
title: Proxmox Backup Server with TrueNAS target
---

I am using Proxmox Backup Server to backup my PVE VMs and containers to my TrueNAS server via NFS. PBS is installed directly on the PVE machine (this is not officially recommended but fine for my setup; if the PVE machine breaks, I'm fine with spinning up a new PBS server and just importing the existing dataset). PBS doesn't currently support remote storages. As a workaround, I am mounting the NFS share through PVE and setting its local path as the backup destination in PBS.

## Setting up NFS share in TrueNAS

* In the TrueNAS web interface, under *Storage* and *Pools*, create a dataset named `proxmox-backup-server` using the default settings.
* Click on the three dots for the dataset and choose *Edit Permissions* -> *Use ACL manager*. Choose the *OPEN* preset and click *Save*.
* Under *Sharing* and *Unix Shares (NFS)*, create a new NFS share. Choose the newly created dataset as the path. Click *Advanced Options*. Add Proxmox as an authorized host. Set *Maproot user* to `root` and *Maproot group* to `wheel`. ([1](https://web.archive.org/web/20220212221120/https://forum.proxmox.com/threads/nfs-datastore-einval-invalid-argument.73151/post-328293)) Click *Submit*. If prompted, enable NFS.

## Adding the NFS share in PVE

* In the PVE web interface, under the datacenter and *Storage*, click *Add* and *NFS*. Set an *ID* and enter the TrueNAS IP under *Server*. Under *Export*, choose the share created before. For *Content*, choose *VZDump backup file* (we don't actually want to have PVE store anything here, so choose whatever is least annoying).
* In the table, note the added storage's *Path/Target* (`/mnt/pve/<ID>`).

## Installing PBS on the PVE server

Based on [1](https://web.archive.org/web/20210720181251/https://pbs.proxmox.com/docs/installation.html).

* SSH into the PVE machine (or use the console in the web interface).
* Edit `/etc/pve/storage.cfg` and add `options vers=3,soft` to the storage added in the previous step, so it looks like this:
  
  ```
  nfs: truenas-backup2
          export /mnt/storage2/proxmox-backup-server
          path /mnt/pve/truenas-backup2
          server 10.10.10.20
          content backup
          prune-backups keep-all=1
          options vers=3,soft
  ```
* Edit `/etc/apt/sources.list` and add the following:

  ```
  # PBS pbs-no-subscription repository provided by proxmox.com,
  # NOT recommended for production use
  deb http://download.proxmox.com/debian/pbs bullseye pbs-no-subscription
  ```
* Delete `/etc/apt/sources.list.d/pbs-enterprise.list`.
* Run `apt update`.
* Run `apt install proxmox-backup-server`.
* The web interface will be on port `8007` (through HTTPS).

## Configure PBS

* In the PBS web interface, under *Datastore*, click *Add Datastore*. Choose a name and use the noted path from the PVE storage as *Backing Path*. Under *Prune options*, set the options below. Then, click *Add*.
    * *Prune Options*
        * *Keep Last*: `7` 
        * *Keep Hourly*: `3` 
        * *Keep Daily*: `14` 
        * *Keep Weekly*: `8` 
        * *Keep Monthly*: `12` 
        * *Keep Yearly*: `2` 
* Under *Datastore*, click on the new datastore. Under *Verify Jobs*, click *Add*. Leave the default options and click *Add*.

## Configure backups in PVE

* Back in the PVE web interface, under the datacenter and *Storage*, click *Add* and *Proxmox Backup Server*. Choose an *ID*, enter the server IP, login credentials (if you're using 2FA, create an API token in PBS first, give it `DatastoreAdmin` permissions for `/datastore`, and use that instead), and datastore name. Copy the fingerprint from the PBS web UI. Click *Add*.
* Under *Backup*, create a backup job as desired.
