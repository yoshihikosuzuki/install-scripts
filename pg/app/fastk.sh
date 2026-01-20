#!/bin/bash
module purge
set -eu
# module use /bio/package/.modulefiles
# module load gcc/9.2.0 openssl/1.1.1d curl/7.65.3 zlib/1.2.3.6 xz/5.2.5
set -x

MODROOT=/nfs/data05/yoshihiko_s/app
APP=fastk
VER=2025.09.13

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

# from releases
# wget -O - https://github.com/thegenemyers/FASTK/archive/refs/tags/v1.1.0.tar.gz | tar xzvf -
# mv FASTK-1.1.0/ $VER
# cd $VER
# cat <<__END__ >HTSLIB/htslib_static.mk
# HTSLIB_static_LDFLAGS = -L/bio/package/openssl/1.1.1d/lib -L/bio/package/curl/curl-7.65.3/lib/.libs -L/nfs/data05/yoshihiko_s/app/zlib/1.2.3.6/lib -L/nfs/data05/yoshihiko_s/app/xz/5.2.5/lib -Wl,-rpath=/bio/package/openssl/1.1.1d/lib -Wl,-rpath=/bio/package/curl/curl-7.65.3/lib/.libs -Wl,-rpath=/nfs/data05/yoshihiko_s/app/zlib/1.2.3.6/lib -Wl,-rpath=/nfs/data05/yoshihiko_s/app/xz/5.2.5/lib
# HTSLIB_static_LIBS = -lz -lm -lbz2 -llzma -lcurl -lrt
# __END__
# make

# from git clone
git clone https://github.com/thegenemyers/FASTK
mv FASTK $VER
cd $VER
make clean
# cat <<__END__ >HTSLIB/htslib_static.mk
# HTSLIB_static_LDFLAGS = -L/bio/package/openssl/1.1.1d/lib -L/bio/package/curl/curl-7.65.3/lib/.libs -L/nfs/data05/yoshihiko_s/app/zlib/1.2.3.6/lib -L/nfs/data05/yoshihiko_s/app/xz/5.2.5/lib -Wl,-rpath=/bio/package/openssl/1.1.1d/lib -Wl,-rpath=/bio/package/curl/curl-7.65.3/lib/.libs -Wl,-rpath=/nfs/data05/yoshihiko_s/app/zlib/1.2.3.6/lib -Wl,-rpath=/nfs/data05/yoshihiko_s/app/xz/5.2.5/lib
# HTSLIB_static_LIBS = -lz -lm -lbz2 -llzma -lcurl -lrt
# __END__
make

cd $MODROOT/.modulefiles
mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
__END__
