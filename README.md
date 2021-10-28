# vivado-docker

Vivado installed into a docker image for CI purposes.

## Build instructions
1. Download the Xilinx Vivado SDK 2020.2 tar from [Vivado Download Archive](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html) and save it in the root directory of this repository.
2. Run `./buildimage.sh`(will take about an hour).

# Develop with docker_compose.yml

## Prerequisites

Docker and Docker-Compose must be installed on your workstation/vm.

## Create or modify your docker-compose.yml

It's recommended to create a subfolder called 'docker' in your project. A `docker-compose.yml` is the standard way of defining how a docker container runs as a service. In this file you can specify the mapping of the repository on your host and its mounting point inside the container. Create a file like this inside your 'docker' folder: 

**docker-compose.yml**
```
version: '3.2'
services:
  vivado_toolchain:

    image: vivado:2020.2

    volumes:
      - type: bind
        source: $HOME/Projects/repo
        target: /home/vivado/repo
     
    stdin_open: true # docker run -i
    tty: true        # docker run -t
```

## Run your toolchain locally

It's recommended to employ a script (rundocker.sh) that recreates an up-to-date container and brings it up. Once the container is successfully started, you can use its console to run build scripts for your projects.
Create a script like this inside your project's docker folder:

**rundocker.sh**
```
#!/bin/sh
docker-compose up -d --build --force-recreate
docker attach fpgatoolchain_vivado_toolchain_1
```

>**Note:** the 'attach' command attaches to the console of your docker container. It's name is docker_[name of the service in docker-compose.yml]_1.

# Deploy with .gitlab-ci.yml

The .gitlab-ci.yml files defines the whole process of building software (see GitLAb CI/CD documentation). It's important to specify the same docker images for server builds here as were used for local development in the docker-compose



