# 1password-backup
[![Create Docker Image](https://github.com/haeberli/1password-backup/actions/workflows/docker-image.yml/badge.svg)](https://github.com/haeberli/1password-backup/actions/workflows/docker-image.yml)

Docker image to periodically clone entries from 1Password to a local server.

## Setup
* Get latest container image from [Docker Hub](https://hub.docker.com/repository/docker/haeberli/1password-backup/general)
* Configure docker container with volume `/vaults`.
* Add a *.conf file to the folder vaults for each account containing the credentials:

        EMAIL=...
        SECRETKEY=A3-...
        PASSWORD=...
        VAULT=Private
    > This is a regular BASH file - use character escapes or quotes if required, usualy for the password ;-).
    > 
    > Remove VAULT to access all vaults or specify vault.
  
## Run
The container will update the vaults every hour.
