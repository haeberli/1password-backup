FROM 1password/op

COPY ./backup.sh /home/opuser/
RUN chmod +x ~/backup.sh

ENTRYPOINT ~/backup.sh
