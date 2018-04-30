#!/bin/bash

set -e
source $(dirname $0)/make_static_libs_common.sh


# zlib
wget https://www.zlib.net/zlib-1.2.11.tar.gz
CFLAGS="-fPIC" ./configure --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# libpng
wget https://prdownloads.sourceforge.net/libpng/libpng-1.6.34.tar.gz
#./configure --enable-static --prefix ${WORKDIR}
${MAKE} -f scripts/makefile.linux CFLAGS="-fPIC -DPIC" ZLIBLIB=${LIBDIR} ZLIBINC=${INCLUDEDIR} prefix=${WORKDIR}
${MAKE} -f scripts/makefile.linux prefix=${WORKDIR} install

# libjpeg
wget http://www.ijg.org/files/jpegsrc.v9b.tar.gz
./configure --with-pic --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# libtiff
wget https://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz
./configure --with-pic --disable-lzma --disable-jbig --prefix ${WORKDIR}
${MAKE}
${MAKE} install


# libIL (DevIL)
wget https://api.github.com/repos/DentonW/DevIL/tarball/e34284a7e07763769f671a74b4fec718174ad862
cmake DevIL -DCMAKE_CXX_FLAGS=-fPIC -DBUILD_SHARED_LIBS=0 -DCMAKE_INSTALL_PREFIX=${WORKDIR} \
        -DPNG_PNG_INCLUDE_DIR=${INCLUDEDIR} -DPNG_LIBRARY_RELEASE=${LIBDIR}/libpng.a \
        -DJPEG_INCLUDE_DIR=${INCLUDEDIR} -DJPEG_LIBRARY=${LIBDIR}/libjpeg.a \
        -DTIFF_INCLUDE_DIR=${INCLUDEDIR} -DTIFF_LIBRARY_RELEASE=${LIBDIR}/libtiff.a \
        -DZLIB_INCLUDE_DIR=${INCLUDEDIR} -DZLIB_LIBRARY_RELEASE=${LIBDIR}/libz.a
${MAKE}
${MAKE} install

# libunwind
wget https://download.savannah.nongnu.org/releases/libunwind/libunwind-1.2.1.tar.gz
./configure --with-pic --disable-minidebuginfo --prefix ${WORKDIR}
${MAKE}
${MAKE} install

# glew
wget https://sourceforge.net/projects/glew/files/glew/2.1.0/glew-2.1.0.tgz
${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR}
${MAKE} GLEW_PREFIX=${WORKDIR} GLEW_DEST=${WORKDIR} LIBDIR=${LIBDIR} install