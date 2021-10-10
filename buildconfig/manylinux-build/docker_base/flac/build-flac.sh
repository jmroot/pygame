#!/bin/bash
set -e -x

cd $(dirname `readlink -f "$0"`)

FLAC=flac-1.3.2

curl -sL http://downloads.xiph.org/releases/flac/${FLAC}.tar.xz > ${FLAC}.tar.xz
sha512sum -c flac.sha512

# The tar we have is too old to handle .tar.xz directly
unxz ${FLAC}.tar.xz
tar xf ${FLAC}.tar
cd $FLAC

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${FLAC}
    ./configure --prefix=${MACDEP_CACHE_PREFIX_PATH}/${FLAC}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${FLAC} /usr/local
fi

