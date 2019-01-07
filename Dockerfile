FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LXD_PASSWD=unsecret

RUN set -xe \
    \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    lxd \
    lxc \
    && apt-get clean

COPY lxd-preseed.yaml lxd-preseed.yaml
COPY entrypoint.sh entrypoint.sh

CMD "./entrypoint.sh"

EXPOSE 8443
