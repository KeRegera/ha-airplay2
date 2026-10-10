ARG BUILD_FROM
FROM ${BUILD_FROM} AS builder

ARG NQPTP_VERSION=1.2.4
ARG SPS_VERSION=4.3.7

RUN apk add --no-cache \
    build-base git autoconf automake libtool xxd xmltoman \
    alsa-lib-dev popt-dev libconfig-dev avahi-dev openssl-dev soxr-dev \
    ffmpeg-dev libplist-dev libsodium-dev libgcrypt-dev libuuid util-linux-dev \
    dbus-dev

# NQPTP (PTP-Zeitgeber, zwingend für AirPlay 2)
RUN git clone --depth 1 --branch ${NQPTP_VERSION} https://github.com/mikebrady/nqptp.git /src/nqptp \
 && cd /src/nqptp && autoreconf -fi && ./configure && make -j"$(nproc)" \
 && make DESTDIR=/out install

# Shairport Sync mit AirPlay 2
RUN git clone --depth 1 --branch ${SPS_VERSION} https://github.com/mikebrady/shairport-sync.git /src/sps \
 && cd /src/sps && autoreconf -fi \
 && ./configure --sysconfdir=/etc --with-alsa --with-soxr --with-avahi \
      --with-ssl=openssl --with-airplay-2 --with-metadata --with-pipe \
 && make -j"$(nproc)" \
 && make DESTDIR=/out install

FROM ${BUILD_FROM}

RUN apk add --no-cache \
    alsa-lib alsa-utils alsa-plugins-pulse popt libconfig avahi-libs \
    soxr ffmpeg-libs libplist libsodium libgcrypt openssl dbus-libs libuuid

COPY --from=builder /out/usr/ /usr/
COPY rootfs /

RUN chmod a+x /etc/services.d/*/run /etc/services.d/*/finish /etc/cont-init.d/*

LABEL io.hass.type="addon"
