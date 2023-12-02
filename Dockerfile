FROM ubuntu:latest

ARG VERSION=2.23.0

RUN apt-get update && apt-get install -y curl unzip jq && \
    curl -o op.zip https://cache.agilebits.com/dist/1P/op2/pkg/v$VERSION/op_linux_amd64_v$VERSION.zip && \
    unzip op.zip -d /usr/local/bin && \
    rm op.zip

COPY --chmod=755 ./backup.sh /home/opuser/

ENTRYPOINT ~/backup.sh
