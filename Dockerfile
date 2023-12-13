FROM alpine:latest

VOLUME vaults

ARG VERSION=2.23.0
RUN apk update && apk add curl unzip jq && \
    curl -o op.zip https://cache.agilebits.com/dist/1P/op2/pkg/v$VERSION/op_linux_amd64_v$VERSION.zip && \
    unzip op.zip -d /usr/local/bin && \
    rm op.zip

COPY --chmod=755 ./backup.sh /home/

ENTRYPOINT /home/backup.sh
