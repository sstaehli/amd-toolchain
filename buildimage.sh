#!/bin/bash

# get host ip for tar download
host_ip=$(hostname -I | awk '{print $1;}')
tarfile=$(ls  Xilinx_Unified_2020.2*.tar.gz)
echo "$tarfile is served on http://$host_ip:8000"

# get the version from tar file name
ifsorig=$IFS
IFS='_'
read -ra filenameparts <<< "$tarfile"
IFS=$ifsorig
version=${filenameparts[2]}
echo "Version is $version"

# provide directory content as http instead of docker COPY, as this reduces disk space usage by intermediate containersteps
python3 -m http.server 2>&1 &
httppid=$!

# create image in subshell to make shure http server is killed after docker command
(
    docker build --build-arg VIVADO_VERSION=${version} --build-arg VIVADO_TAR_FILE=http://${host_ip}:8000/${tarfile} -t vivado:${version} --no-cache .
)

# stop http-server
kill $httppid
