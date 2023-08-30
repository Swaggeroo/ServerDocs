# Activate SSH in LXC Container

!!!info

    All this commands need to be run in the container.

## Edit Config
```bash
nano /etc/ssh/sshd_config
```
change the following line:
```bash
#PermitRootLogin prohibit-password
```
to:
```bash
PermitRootLogin yes
```

## Restart SSH
```bash
service ssh restart
```