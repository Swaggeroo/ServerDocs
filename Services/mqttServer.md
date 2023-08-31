# Setup MQTT Server
??? info "Docker Environment"
    In preparation for the MQTT instance, you must have Docker running on your server. I also recommend using [Portainer](https://www.portainer.io/).


## Installation
I ran the `eclipse-mosquitto:latest` image from the Docker Hub with the following settings:
- Name: `mosquitto`
- Restart Policy: `unless-stopped`
- Network: `bridge`
- Ports: `1883:1883`
- Volumes: `/opt/mosquitto/config:/mosquitto/config` and `/opt/mosquitto/data:/mosquitto/data` and `/opt/mosquitto/log:/mosquitto/log`
- Environment Variables: `TZ=Europe/Berlin` *You can change this to your timezone*

## Configuration
### Config File
In the container under `/mosquitto/config` you will find the `mosquitto.conf` file.
I changed the following settings to activate the password file and to disable anonymous access (1) :
{ .annotate }

1.  This must be executed in the container!

```bash
# Require authentication
allow_anonymous false
password_file /mosquitto/config/mqttuser
```

### Add User
To add a user to the MQTT server, you can use the following commands:

#### First User
```bash
mosquitto_passwd -c /mosquitto/config/mqttuser [username]
```

#### Additional Users
```bash
mosquitto_passwd /mosquitto/config/mqttuser [username]
```