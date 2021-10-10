#!/bin/bash
set -e -x

cd $(dirname `readlink -f "$0"`)

HARFBUZZ_VER=3.0.0
HARFBUZZ_NAME="harfbuzz-$HARFBUZZ_VER"
curl -sL https://github.com/harfbuzz/harfbuzz/releases/download/${HARFBUZZ_VER}/${HARFBUZZ_NAME}.tar.xz > ${HARFBUZZ_NAME}.tar.xz

sha512sum -c harfbuzz.sha512
unxz -xf ${HARFBUZZ_NAME}.tar.xz
tar -xf ${HARFBUZZ_NAME}.tar
cd ${HARFBUZZ_NAME}

if [[ "$OSTYPE" == "darwin"* ]]; then
    # To avoid a circular dependency on freetype
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${HARFBUZZ_NAME}
    ./configure --with-freetype=no --with-fontconfig=no \
        --prefix=${MACDEP_CACHE_PREFIX_PATH}/${HARFBUZZ_NAME}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${HARFBUZZ_NAME}/. /usr/local
fi
