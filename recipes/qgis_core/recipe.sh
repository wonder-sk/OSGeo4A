#!/bin/bash

# version of your package
VERSION_qgis_core=2.11.0

# dependencies of this recipe
DEPS_qgis_core=(gdal libspatialite spatialindex expat)

# url of the package
URL_qgis_core=https://github.com/wonder-sk/QGIS/archive/only-core.zip

# md5 of the package
MD5_qgis_core=915ba87f35bebb30b2ecd1c3b45babf4

# default build path
BUILD_qgis_core=$BUILD_PATH/qgis_core/QGIS-only-core

# default recipe path
RECIPE_qgis_core=$RECIPES_PATH/qgis_core

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_qgis_core() {
  true
}

# function called to build the source code
function build_qgis_core() {
  try mkdir -p $BUILD_PATH/qgis_core/build-$ARCH
  try cd $BUILD_PATH/qgis_core/build-$ARCH
  echo "BP: $BUILD_PATH"
  echo "BQ: $BUILD_qgis_core"
  echo "PWD:" `pwd`
	push_arm
  try cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=$ROOT_PATH/tools/android.toolchain.cmake \
    -DWITH_CORE_ONLY=ON \
    -DFLEX_EXECUTABLE=/usr/bin/flex \
    -DBISON_EXECUTABLE=/usr/bin/bison \
    -DGDAL_CONFIG=$STAGE_PATH/bin/gdal-config \
    -DGDAL_CONFIG_PREFER_FWTOOLS_PAT=/bin_safe \
    -DGDAL_CONFIG_PREFER_PATH=$STAGE_PATH/bin \
    -DGDAL_INCLUDE_DIR=$STAGE_PATH/include \
    -DGDAL_LIBRARY=$STAGE_PATH/lib/libgdal.so \
    -DGEOS_CONFIG=$STAGE_PATH/bin/geos-config \
    -DGEOS_CONFIG_PREFER_PATH=$STAGE_PATH/bin \
    -DGEOS_INCLUDE_DIR=$STAGE_PATH/include \
    -DGEOS_LIBRARY=$STAGE_PATH/lib/libgeos_c.so \
    -DGEOS_LIB_NAME_WITH_PREFIX=-lgeos_c \
    -DICONV_INCLUDE_DIR=$STAGE_PATH/include \
    -DICONV_LIBRARY=$STAGE_PATH/lib/libiconv.so \
    -DSQLITE3_INCLUDE_DIR=$STAGE_PATH/include \
    -DSQLITE3_LIBRARY=$STAGE_PATH/lib/libsqlite3.so \
    -DWITH_INTERNAL_SPATIALITE=OFF \
    -DWITH_QTMOBILITY=OFF \
    -DCMAKE_INSTALL_PREFIX:PATH=$STAGE_PATH \
    -DENABLE_QT5=ON \
    -DWITH_QTWEBKIT=OFF \
    -DENABLE_TESTS=OFF \
    -DSPATIALINDEX_LIBRARY=$STAGE_PATH/lib/libspatialindex.so \
    -DWITH_APIDOC=OFF \
    -DWITH_ASTYLE=OFF \
    -DANDROID_NDK=$ANDROIDNDK \
    -DANDROID_STL=gnustl_shared \
    -DANDROID_ABI=$ARCH \
    -DANDROID_NATIVE_API_LEVEL=$ANDROIDAPI \
    $BUILD_qgis_core
  try make
  try make install
	pop_arm
}

# function called after all the compile have been done
function postbuild_qgis_core() {
	true
}
