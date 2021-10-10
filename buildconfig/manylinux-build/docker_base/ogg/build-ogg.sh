#!/bin/bash
set -e -x

cd $(dirname `readlink -f "$0"`)

OGG=libogg-1.3.5
VORBIS=libvorbis-1.3.7

curl -sL http://downloads.xiph.org/releases/ogg/${OGG}.tar.gz > ${OGG}.tar.gz
curl -sL http://downloads.xiph.org/releases/vorbis/${VORBIS}.tar.gz > ${VORBIS}.tar.gz
sha512sum -c ogg.sha512

tar xzf ${OGG}.tar.gz
cd $OGG

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${OGG}
    ./configure --prefix=${MACDEP_CACHE_PREFIX_PATH}/${OGG}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${OGG}/. /usr/local
fi

cd ..

tar xzf ${VORBIS}.tar.gz
cd $VORBIS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${VORBIS}
    ./configure --prefix=${MACDEP_CACHE_PREFIX_PATH}/${VORBIS}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${VORBIS}/. /usr/local
fi

cd ..
