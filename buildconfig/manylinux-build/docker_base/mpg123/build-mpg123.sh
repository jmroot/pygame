#!/bin/bash
set -e -x

MPG123="mpg123-1.28.2"

cd $(dirname `readlink -f "$0"`)

curl -sL https://downloads.sourceforge.net/sourceforge/mpg123/${MPG123}.tar.bz2 > ${MPG123}.tar.bz2
sha512sum -c mpg123.sha512

bzip2 -d ${MPG123}.tar.bz2
tar xf ${MPG123}.tar
cd $MPG123

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure --enable-int-quality --disable-debug
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${MPG123}
    ./configure --enable-int-quality --disable-debug \
        --prefix=${MACDEP_CACHE_PREFIX_PATH}/${MPG123}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${MPG123}/. /usr/local
fi

cd ..
