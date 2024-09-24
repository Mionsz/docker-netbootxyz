FROM alpine:3.20

# set version label
ARG VERSION="1.1.0"

LABEL org.opencontainers.image.maintainer="milosz.linkiewicz@intel.com"
LABEL org.opencontainers.image.url="https://github.com/Mionsz/docker-netbootxyz"
LABEL org.opencontainers.image.title="netboot.xyz version: ${VERSION} Build-date: 24/09/2024"
LABEL org.opencontainers.image.description="netboot.xyz official docker container - Your favorite operating systems in one place. A network-based bootable operating system installer based on iPXE."

ENV TZ='Etc/UTC'
ARG WEBAPP_VERSION="0.7.3"
ENV MENU_VERSION='2.0.82'
ENV TFTPD_OPTS='--tftp-single-port'
ENV WEB_APP_PORT="3000"
ENV NGINX_PORT="80"

COPY webapp/ /app
COPY webapp/root/ /

RUN apk upgrade --no-cache && \
    apk add --no-cache wget unzip bash vim

WORKDIR "/app"
SHELL ["/bin/bash", "-ex", "-o", "pipefail", "-c"]

RUN apk upgrade --no-cache && \
    apk add --no-cache --virtual=build-dependencies nodejs npm && \
    apk add --no-cache \
      busybox \
      curl \
      envsubst \
      git \
      jq \
      nghttp2-dev \
      nginx \
      nodejs \
      shadow \
      sudo \
      supervisor \
      syslog-ng \
      tar \
      dnsmasq && \
    mkdir -p /app /config /defaults && \
    groupmod -g 1000 users && \
    useradd -u 911 -U -d /config -s /bin/false nbxyz && \
    usermod -G users nbxyz && \
    npm install --prefix /app && \
    apk del --purge build-dependencies && \
    rm -rf /tmp/*

RUN /init.sh

EXPOSE 69/udp
EXPOSE 80
EXPOSE 3000

# default command
SHELL ["/bin/bash", "-c"]
ENTRYPOINT ["/start.sh"]
