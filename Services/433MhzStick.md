# Setting up an 433Mhz Stick
## Introduction
This guide will help you to set up an 433Mhz Stick to read (your) 433Mhz devices.

But **WHY** should you do this?

It is especially useful if you want many cheap and energy efficient sensors for your home automation.
I was able to get the antenna/stick for about 20€ on AliExpress and a cheap window sensor for about 3€.
And there are also a lot of other sensors available for 433Mhz.
A nice side effect is that many cheaper weather stations also use 433Mhz, so you can also get the readings from your neighbors and not have to buy your own.😉

## Hardware
I used the following hardware:

- [433Mhz Stick (Aliexpress)](https://aliexpress.com/item/1005005042997320.html)
![443MhzStick.webp](..%2Fmedia%2F443MhzStick.webp)
- Neighbors weather station😄

## Installation
### Container
First I created a new container for the 433Mhz Stick.
??? info "Container Resources"
    In my deployment this setup actively uses following resources:

    - < 1 CPU Core (~ 0.5% of a core)
    - 20 MB RAM
    - 1 GB Disk Space
    
    FYI: On this container only runs the 433Mhz Stick software. The interpretation of the data is done on another container.

Than I [passed through the USB device](../Proxmox/passthroughUsbLCX.md) to the container.

### Software
I used the rtl_433 software to read the data from the 433Mhz Stick.
```bash
apt-get install rtl-433
```

## Usage
### Start
To start the software use:
```bash
/usr/local/bin/rtl_433
```
If its running correctly and you got some output you can stop it again with `CTRL+C`.

### Run in Background
To run the software in the background and automatically publish everything to a [MQTT broker](./mqttServer.md) I use the following script:
```bash
/usr/local/bin/rtl_433 -F json | mosquitto_pub -u [MQTT User] -P [MQTT Password] -t [MQTT Topic] -h [MQTT Adress] -l
```
Maybe you have to install mosquitto-clients with `apt-get install mosquitto-clients`.

I saved it under `/root/startup.sh` and made it executable with `chmod +x /root/startup.sh`.

Than I added it to the crontab with `crontab -e` and added the following lines:
```bash
@reboot /root/startup.sh
0 * * * * kill $(pidof rtl_433) ; sleep 3 && /root/startup.sh
```
This makes sure that the software is running after a reboot and also restarts it every hour so if it crashes it will restart.

## Data Interpretation
I use Node-Red to interpret the data. I just use the MQTT node to subscribe to the topic and then use the JSON node to parse the data.
The data is then saved to an InfluxDB and displayed in Grafana. It is also used to be displayed on my HomeAssistant.

## Source
[ei23](https://www.youtube.com/watch?v=ddzt-xWSwro)