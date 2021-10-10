#!/bin/bash
set -e -x

cd $(dirname `readlink -f "$0"`)

JPEG=jpegsrc.v9d

curl -sL http://www.ijg.org/files/${JPEG}.tar.gz > ${JPEG}.tar.gz
sha512sum -c jpeg.sha512

tar xzf ${JPEG}.tar.gz
cd jpeg-*

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${JPEG}
    ./configure --prefix=${MACDEP_CACHE_PREFIX_PATH}/${JPEG}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${JPEG}/. /usr/local
fi
