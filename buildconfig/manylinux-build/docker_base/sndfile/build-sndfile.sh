#!/bin/bash
set -e -x

cd $(dirname `readlink -f "$0"`)

SNDFILEVER=1.0.31
SNDNAME="libsndfile-$SNDFILEVER"
SNDFILE="$SNDNAME.tar.bz2"
curl -sL https://github.com/libsndfile/libsndfile/releases/download/${SNDFILEVER}/${SNDFILE} > ${SNDFILE}

sha512sum -c sndfile.sha512
tar xf ${SNDFILE}
cd $SNDNAME
# autoreconf -fvi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${SNDNAME}
    ./configure --prefix=${MACDEP_CACHE_PREFIX_PATH}/${SNDNAME}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${SNDNAME}/. /usr/local
fi
