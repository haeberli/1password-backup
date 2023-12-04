# 1password-backup
[![Create Docker Image](https://github.com/haeberli/1password-backup/actions/workflows/docker-image.yml/badge.svg)](https://github.com/haeberli/1password-backup/actions/workflows/docker-image.yml)

Docker image to periodically clone all entries of all vaults from 1Password to a local server.

## Setup
* Configure docker container with volume `/vaults`.
* Add a *.conf file to the folder vaults for each account
* Add credentials for each account, e.g.

        EMAIL...
        SECRETKEY=A3-...
        PASSWORD=...
    > This is a regular BASH file - use character escapes or quotes if required, ususly for the password ;-).
  
## Run
The container will update the vaults every hour.
