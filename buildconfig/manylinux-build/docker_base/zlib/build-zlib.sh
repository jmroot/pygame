#!/bin/bash
set -e -x

cd $(dirname `readlink -f "$0"`)

ZLIB_VER=1.2.11
ZLIB_NAME="zlib-$ZLIB_VER"
curl -sL https://www.zlib.net/${ZLIB_NAME}.tar.gz > ${ZLIB_NAME}.tar.gz

sha512sum -c zlib.sha512
tar -xf ${ZLIB_NAME}.tar.gz
cd ${ZLIB_NAME}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${ZLIB_NAME}
    ./configure --prefix=${MACDEP_CACHE_PREFIX_PATH}/${ZLIB_NAME}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${ZLIB_NAME}/. /usr/local
fi
