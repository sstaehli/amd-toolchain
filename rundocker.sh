#!/bin/sh
docker-compose up -d --build --force-recreate
docker attach vivado20202_toolchain
