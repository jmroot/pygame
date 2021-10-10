#!/bin/bash
set -e -x

cd $(dirname `readlink -f "$0"`)

MODPLUG_VER=0.8.8.5
MODPLUG_NAME="libmodplug-$MODPLUG_VER"
curl -sL https://sourceforge.net/projects/modplug-xmms/files/libmodplug/${MODPLUG_VER}/${MODPLUG_NAME}.tar.gz/download > ${MODPLUG_NAME}.tar.gz

sha512sum -c libmodplug.sha512
tar -xf ${MODPLUG_NAME}.tar.gz
cd ${MODPLUG_NAME}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${MODPLUG_NAME}
    ./configure--prefix=${MACDEP_CACHE_PREFIX_PATH}/${MODPLUG_NAME}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${MODPLUG_NAME}/. /usr/local
fi
