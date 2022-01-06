#!/bin.bash

APP=seqkit
VER=2.0.0
MODROOT=/apps/unit/BioinfoUgrp/Other

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

wget -O - https://github.com/shenwei356/seqkit/releases/download/v$VER/seqkit_linux_amd64.tar.gz | tar xzvf -

cd $MODROOT/modulefiles/
mkdir -p $APP
cat <<'__END__' > $APP/$VER.lua
-- Default settings
local modroot    = "/apps/unit/BioinfoUgrp"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package information
whatis("Name: "..appname)
whatis("Version: "..appversion)
whatis("URL: ".."https://github.com/shenwei356/seqkit")
whatis("Category: ".."bioinformatics")
whatis("Keywords: ".."fasta, fastq, sequence analysis")
whatis("Description: ".."A cross-platform and ultrafast toolkit for FASTA/Q file manipulation in Golang")

-- Package settings
prepend_path("PATH", apphome)
__END__
