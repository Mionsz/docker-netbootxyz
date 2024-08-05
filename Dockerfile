FROM alpine:3.20

# set version label
ARG BUILD_DATE
ARG VERSION="1.0.0"
ARG WEBAPP_VERSION="0.7.3"

LABEL org.opencontainers.image.maintainer="milosz.linkiewicz@intel.com"
LABEL org.opencontainers.image.url="https://github.com/Mionsz/docker-netbootxyz"
LABEL org.opencontainers.image.title="netboot.xyz version: ${VERSION} Build-date: ${BUILD_DATE}"
LABEL org.opencontainers.image.description netboot.xyz official docker container - Your favorite operating systems in one place. A network-based bootable operating system installer based on iPXE.

COPY webapp/ /app
RUN apk add --no-cache \
      bash \
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
      vim \
      dnsmasq && \
    apk add --no-cache --virtual=build-dependencies \
      npm && \
    groupmod -g 1000 users && \
    useradd -u 911 -U -d /config -s /bin/false nbxyz && \
    usermod -G users nbxyz && \
    mkdir /config /defaults && \
    if [ -z ${WEBAPP_VERSION+x} ]; then \
      WEBAPP_VERSION=$(curl -sX GET "https://api.github.com/repos/netbootxyz/webapp/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]'); \
    fi && \
    npm install --prefix /app && \
    apk del --purge build-dependencies && \
    rm -rf /tmp/*

ENV TFTPD_OPTS=''
ENV NGINX_PORT='80'
ENV WEB_APP_PORT='3000'

EXPOSE 69/udp
EXPOSE 80
EXPOSE 3000

COPY root/ /

# default command
CMD ["sh","/start.sh"]
