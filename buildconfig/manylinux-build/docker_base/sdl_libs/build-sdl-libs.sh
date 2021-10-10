#!/bin/bash
set -e -x

cd /sdl_build/

SDL="SDL-1.2.15"
IMG="SDL_image-1.2.12"
TTF="SDL_ttf-2.0.11"
MIX="SDL_mixer-1.2.12"

# Download
curl -sL https://www.libsdl.org/release/${SDL}.tar.gz > ${SDL}.tar.gz
curl -sL https://www.libsdl.org/projects/SDL_image/release/${IMG}.tar.gz > ${IMG}.tar.gz
curl -sL https://www.libsdl.org/projects/SDL_ttf/release/${TTF}.tar.gz > ${TTF}.tar.gz
curl -sL https://www.libsdl.org/projects/SDL_mixer/release/${MIX}.tar.gz > ${MIX}.tar.gz
sha512sum -c sdl.sha512

# Build SDL
tar xzf ${SDL}.tar.gz
cd $SDL

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure --enable-png --disable-png-shared --enable-jpg --disable-jpg-shared
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${SDL}
    ./configure --enable-png --disable-png-shared --enable-jpg --disable-jpg-shared \
        --prefix=${MACDEP_CACHE_PREFIX_PATH}/${SDL}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${SDL}/. /usr/local
fi

cd ..

# Link sdl-config into /usr/bin so that smpeg-config can find it
ln -s /usr/local/bin/sdl-config /usr/bin/

# Build smpeg.
svn co svn://svn.icculus.org/smpeg/tags/release_0_4_5
# Check the sha512sum of the svn checkout is the same.
find release_0_4_5 -not -iwholename '*.svn*' -exec sha512sum {} + | awk '{print $1}' | sort | sha512sum -c smpeg.sha512


cd release_0_4_5
./autogen.sh
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure --disable-dependency-tracking --disable-debug --disable-gtk-player \
        --disable-gtktest --disable-opengl-player --disable-sdltest
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/smpeg
    ./configure --disable-dependency-tracking --disable-debug --disable-gtk-player \
        --disable-gtktest --disable-opengl-player --disable-sdltest \
        --prefix=${MACDEP_CACHE_PREFIX_PATH}/smpeg
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/smpeg/. /usr/local
fi

cd ..

# Build SDL_image
tar xzf ${IMG}.tar.gz
cd $IMG
# The --disable-x-shared flags make it use standard dynamic linking rather than
# dlopen-ing the library itself. This is important for when auditwheel moves
# libraries into the wheel.
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure --enable-png --disable-png-shared --enable-jpg --disable-jpg-shared \
        --enable-tif --disable-tif-shared --enable-webp --disable-webp-shared
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${IMG}
    ./configure --enable-png --disable-png-shared --enable-jpg --disable-jpg-shared \
        --enable-tif --disable-tif-shared --enable-webp --disable-webp-shared \
        --prefix=${MACDEP_CACHE_PREFIX_PATH}/${IMG}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${IMG}/. /usr/local
fi

cd ..

# Build SDL_ttf
tar xzf ${TTF}.tar.gz
cd $TTF

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${TTF}
    ./configure --prefix=${MACDEP_CACHE_PREFIX_PATH}/${TTF}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${TTF}/. /usr/local
fi

cd ..

# Build SDL_mixer
tar xzf ${MIX}.tar.gz
cd $MIX
# The --disable-x-shared flags make it use standard dynamic linking rather than
# dlopen-ing the library itself. This is important for when auditwheel moves
# libraries into the wheel.
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ./configure --enable-music-mod --disable-music-mod-shared \
            --enable-music-fluidsynth --disable-music-fluidsynth-shared \
            --enable-music-ogg --disable-music-ogg-shared \
            --enable-music-flac --disable-music-flac-shared \
            --enable-music-mp3 --disable-music-mp3-shared
    make
    make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir ${MACDEP_CACHE_PREFIX_PATH}/${MIX}
    ./configure --enable-music-mod --disable-music-mod-shared \
            --enable-music-fluidsynth --disable-music-fluidsynth-shared \
            --enable-music-ogg --disable-music-ogg-shared \
            --enable-music-flac --disable-music-flac-shared \
            --enable-music-mp3 --disable-music-mp3-shared \
            --prefix=${MACDEP_CACHE_PREFIX_PATH}/${MIX}
    make
    make install
    sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${MIX}/. /usr/local
fi

cd ..
