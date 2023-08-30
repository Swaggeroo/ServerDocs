# Passthough USB to LXC Container
!!!info

    All this commands need to be run on the Proxmox host.

## Stop Container
First we need to stop the container we want to add the USB device to.
```bash
pct stop [CTID]
```

## Get Info
First we need to get the Bus and Device ID of the USB device we want to passthrough.
To do this we use the lsusb command.
```bash
lsusb
```

Example output:
```bash
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 002: ID 0bda:2838 Realtek Semiconductor Corp. RTL2838 DVB-T
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

In this case we are looking for the RTL2838 DVB-T device.
What's important is the Bus and Device ID. In this case Bus {==001==} Device {==002==}.

```bash
ls -l /dev/bus/usb/[BUS]/[DEVICE]
```
Example Output:
```bash
crw-rw---- 1 root plugdev 189, 1 Aug 29 22:07 /dev/bus/usb/001/002
```

Important in this output is the number {==189==} (1) .
{ .annotate }

1.  Save this number for later.


## Add USB to LXC Container
Go to the configs of your containers
```bash
cd /etc/pve/nodes/pve/lxc
```

Open the config of the container you want to add the USB device to.
```bash
nano [CTID].conf
```

Add the following line to the config.
???warning 

    Replace **[NUMBER]** with the number you saved earlier. 
    
    And replace **[BUS]** and **[Device]** with the Bus and Device ID of the USB device you want to passthrough.
```bash
lxc.cgroup.devices.allow: c [NUMBER]:* rwm
lxc.mount.entry: /dev/bus/usb/[BUS]/[Device] dev/bus/usb/[BUS]/[Device] none bind,optional,create=file
```

### Rights for the Container
```bash
chmod o+rw /dev/bus/usb/[BUS]/[Device]
```

## Start Container
```bash
pct start [CTID]
```

## Source
[10. google result🙃](https://coldcorner.de/2018/07/12/proxmox-usb-passthrough-fuer-lxc-container-z-wave-uzb1/)
