FROM 1password/op

COPY --chmod=755 ./backup.sh /home/opuser/

ENTRYPOINT ~/backup.sh
