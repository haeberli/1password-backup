FROM 1password/op

COPY ./backup.sh /home/opuser/

ENTRYPOINT ~/backup.sh
