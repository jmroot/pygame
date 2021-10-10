#!/bin/bash
set -e -x

cd $(dirname `readlink -f "$0"`)

FSYNTH_VERSION="v2.2.3"
FSYNTH="fluidsynth-2.2.3"

curl -sL https://github.com/FluidSynth/fluidsynth/archive/${FSYNTH_VERSION}.tar.gz > ${FSYNTH}.tar.gz
sha512sum -c fluidsynth.sha512
tar xzf ${FSYNTH}.tar.gz

cd $FSYNTH
mkdir build
cd build

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cmake .. -Denable-readline=OFF
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${FSYNTH}
    cmake -DCMAKE_INSTALL_PREFIX=${MACDEP_CACHE_PREFIX_PATH}/${FSYNTH} .. -Denable-readline=OFF
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${FSYNTH}/. /usr/local
fi
