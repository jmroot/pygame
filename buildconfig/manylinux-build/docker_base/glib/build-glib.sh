#!/bin/bash
set -e -x

cd $(dirname `readlink -f "$0"`)

GLIB=glib-2.56.4

curl -sL https://download.gnome.org/sources/glib/2.56/${GLIB}.tar.xz > ${GLIB}.tar.xz
sha512sum -c glib.sha512

unxz ${GLIB}.tar.xz
tar xzf ${GLIB}.tar
cd $GLIB

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure --with-pcre=internal
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${GLIB}
    ./configure --with-pcre=internal --prefix=${MACDEP_CACHE_PREFIX_PATH}/${GLIB}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${GLIB}/. /usr/local
fi
