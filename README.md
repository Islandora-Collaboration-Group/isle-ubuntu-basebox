# ISLE Ubuntu Base Image

## Part of the ISLE Islandora 7.x Docker Images
Designed as a base image.

Based on:  
 - Ubuntu 18.04 "Bionic"

Contains and Includes:
  - [S6 Overlay](https://github.com/just-containers/s6-overlay)
  - [Oracle Java 8](https://www.oracle.com/technetwork/java/javase/index.html)
  - ca-certs, curl, dnsutils, git, rsync, unzip, wget

## Generic Usage

```
docker run -it --rm benjaminrosner/isle-ubuntubase:latest bash
```
