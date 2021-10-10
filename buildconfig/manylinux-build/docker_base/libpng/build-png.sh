#!/bin/bash
set -e -x

cd $(dirname `readlink -f "$0"`)

PNG=libpng-1.6.37

curl -sL http://download.sourceforge.net/libpng/${PNG}.tar.gz > ${PNG}.tar.gz
sha512sum -c png.sha512

tar xzf ${PNG}.tar.gz
cd $PNG

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure --with-zlib-prefix=/usr/local
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${PNG}
    ./configure --with-zlib-prefix=/usr/local --prefix=${MACDEP_CACHE_PREFIX_PATH}/${PNG}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${PNG}/. /usr/local
fi
