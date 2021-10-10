#!/bin/bash
set -e -x

cd $(dirname `readlink -f "$0"`)

GETTEXT=gettext-0.21

curl -sL https://ftp.gnu.org/gnu/gettext/${GETTEXT}.tar.gz > ${GETTEXT}.tar.gz
sha512sum -c gettext.sha512

tar xzf ${GETTEXT}.tar.gz
cd $GETTEXT

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  ./configure --disable-dependency-tracking \
    --disable-silent-rules \
    --disable-debug \
    --with-included-glib \
    --with-included-libcroco \
    --with-included-libunistring \
    --with-included-libxml \
    --without-emacs \
    --disable-java \
    --disable-csharp \
    --without-git \
    --without-cvs \
    --without-xz
  make
  make install
elif [[ "$OSTYPE" == "darwin"* ]]; then
  mkdir ${MACDEP_CACHE_PREFIX_PATH}/${GETTEXT}
  ./configure --prefix=${MACDEP_CACHE_PREFIX_PATH}/${GETTEXT} \
    --disable-dependency-tracking \
    --disable-silent-rules \
    --disable-debug \
    --with-included-glib \
    --with-included-libcroco \
    --with-included-libunistring \
    --with-included-libxml \
    --without-emacs \
    --disable-java \
    --disable-csharp \
    --without-git \
    --without-cvs \
    --without-xz \
    --with-included-gettext # this flag is only on mac
  make
  make install
  sudo cp -dR --preserve=mode,ownership ${MACDEP_CACHE_PREFIX_PATH}/${GETTEXT}/. /usr/local
fi
