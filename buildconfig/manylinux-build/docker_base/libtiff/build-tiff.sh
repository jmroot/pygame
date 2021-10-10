#!/bin/bash
set -e -x

cd $(dirname `readlink -f "$0"`)

TIFF=tiff-4.3.0

curl -sL https://download.osgeo.org/libtiff/${TIFF}.tar.gz > ${TIFF}.tar.gz
sha512sum -c tiff.sha512

tar xzf ${TIFF}.tar.gz
cd $TIFF

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure --disable-lzma --disable-webp --disable-zstd
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${TIFF}
    ./configure --disable-lzma --disable-webp --disable-zstd \
         --prefix=${MACDEP_CACHE_PREFIX_PATH}/${TIFF}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${TIFF}/. /usr/local
fi
