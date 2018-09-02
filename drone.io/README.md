# Drone.io
This section details how to get a drone agent and service running in an ubuntu instance.

## Minimum Requirements:

Ubuntu server 16.04 instance with:

- docker
- docker-compose

## Get started
You should have a [github oAuth app](https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/) and its credentials. Then just run:

```
sh scripts/init.sh \
    $DRONE_HOST \
    $DRONE_GITHUB_CLIENT \
    $DRONE_GITHUB_SECRET
```

```
# if in Linux it will create a systemd service
sudo systemctl start drone
# else
/usr/local/bin/docker-compose -f /etc/drone/docker-compose.yml up
```
