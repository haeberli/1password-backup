FROM ubuntu:latest

ARG VERSION

RUN apt-get update && apt-get install -y curl unzip jq && \
    curl -o 1password.zip https://cache.agilebits.com/dist/1P/op/pkg/v$VERSION/op_linux_amd64_v$VERSION.zip && \
    unzip 1password.zip -d /usr/local/bin && \
    rm 1password.zip

COPY --chmod=755 ./backup.sh /home/opuser/

ENTRYPOINT ~/backup.sh
