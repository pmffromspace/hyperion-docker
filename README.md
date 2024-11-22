# hyperion-docker arm64
A dockerfile for hyperion-ng arm64 so you can use your Rapsberry Pi and docker for ambilight

This repo is heavily inspired by https://github.com/psychowood/hyperion.ng-docker

Similar goal but for raspberry pi as well. (This image is only tested on Raspberry Pi running arm64)

The Dockerfile downloads a release (in this case version 2.0.16, this can easily be adjusted) and installs it in a environment with all required packages installed.

This makes migrating hyperion in dockerized envs much easier and restarting as well.

I would recommend to use docker compose, but I will provide the docker run command as well for quick testing.

# Getting started

create/edit file docker-compose.yml or compose.yml

```
services:

  hyperion:
    image: ghcr.io/pmffromspace/hyperion:latest-arm64
    container_name: hyperion
    volumes:
      - ./volumes/hyperion-docker:/config
    privileged: true  # Grants the container elevated privileges, use at own risk
    environment:
      - UID=1000
      - GID=1000
    devices:
      - "/dev/video0:/dev/video0"  # Mount video capture device
#      - "/dev/video1:/dev/video1"  # Mount another video capture device, if applicable
#      - "/dev/snd:/dev/snd"        # Mount audio capture devices
    ports:
      - "19400:19400"
      - "19444:19444"
      - "19445:19445"
      - "8090:8090"
      - "8092:8092"
    restart: unless-stopped
```

## docker run command

```
docker run --name hyperion -v ./volumes/hyperion-docker:/config --privileged -e UID=1000 -e GID=1000 --device /dev/video0:/dev/video0 -p 19400:19400 -p 19444:19444 -p 19445:19445 -p 8090:8090 -p 8092:8092 --restart unless-stopped ghcr.io/pmffromspace/hyperion:latest-arm64
```


# Build localy

```
git clone https://github.com/pmffromspace/hyperion-docker

cd hyperion-docker

docker build -t hyperion:local .

```

to run the locally build image, just edit the docker image similar to:
```
docker run --name hyperion -v ./volumes/hyperion-docker:/config --privileged -e UID=1000 -e GID=1000 --device /dev/video0:/dev$
``
