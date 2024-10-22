#!/bin/bash

# The Linux VM used by Travis has OpenEXR 1.x. We really want 2.x.

EXRINSTALLDIR=${EXRINSTALLDIR:=$HOME/local}
EXRVERSION=${EXRVERSION:=2.2.0}
BASEDIR=`pwd`
pwd
echo "EXR install dir will be: ${EXRINSTALLDIR}"

if [ ! -e ${EXRINSTALLDIR} ] ; then
    mkdir ${EXRINSTALLDIR}
fi

# Clone OpenEXR project (including IlmBase) from GitHub and build
if [ ! -e ./openexr ] ; then
    git clone -b v${EXRVERSION} https://github.com/openexr/openexr.git ./openexr
fi

flags=

if [ ${LINKSTATIC:=0} == 1 ] ; then
    flags=${flags} --enable-static --enable-shared=no --with-pic
fi

pushd ./openexr
git checkout v${EXRVERSION} --force
cd IlmBase
mkdir build
cd build
cmake --config Release -DCMAKE_INSTALL_PREFIX=${EXRINSTALLDIR} .. && make clean && make -j 4 && make install
cd ..
cd ../OpenEXR
mkdir build
mkdir build/IlmImf
cd build
cmake -DCMAKE_BUILD_TYPE=Release \
	  -DILMBASE_PACKAGE_PREFIX=$EXRINSTALLDIR \
	  -DCMAKE_INSTALL_PREFIX=$EXRINSTALLDIR \
      -DBUILD_UTILS=0 -DBUILD_TESTS=0 .. 
make clean && make -j 4 && make install
popd

ls -R ${EXRINSTALLDIR}

#echo "listing .."
#ls ..
