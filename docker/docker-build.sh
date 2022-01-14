set -ex
# run dependencies
apk add --update --no-cache \
    openssh-client \
    libusb-compat \
    nss \
    ;
# build dependencies
apk add --update --no-cache --virtual .build-deps \
    libusb-compat-dev \
    net-snmp-dev \
    openssl-dev \
    nss-dev \
    neon-dev \
    build-base \
    git \
    python3 \
    ;
# download and extract
git clone --depth=2 https://github.com/networkupstools/nut /tmp/nut
cd /tmp/nut
# prepare
./autogen.sh
# build
./configure \
    --prefix=/usr \
    --sysconfdir=/etc/nut \
    --disable-dependency-tracking \
    --enable-strip \
    --disable-static \
    --with-all=no \
    --with-usb=yes \
    --with-serial=yes \
    --datadir=/usr/share/nut \
    --with-nss \
    --with-openssl \
    --with-neon \
    --with-snmp \
    --with-drvpath=/usr/share/nut \
    --with-statepath=/var/run/nut \
    --with-user=nut \
    --with-group=nut \
    ;
# install
make install
# create nut user
adduser -D -h /var/run/nut nut
chgrp -R nut /etc/nut
chmod -R o-rwx /etc/nut
install -d -m 750 -o nut -g nut /var/run/nut
# cleanup
rm -rf /tmp/nut
rm -rf /usr/share/man/man5 /usr/share/man/man8
apk del .build-deps
