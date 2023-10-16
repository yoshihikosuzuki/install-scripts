#!/bin/bash
module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/nfs/data05/yoshihiko_s/app
APP=t2t-polish
VER=1.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
git clone https://github.com/arangrhie/T2T-Polish
mv T2T-Polish $VER
cd $VER
chmod +x automated_polishing/*.sh

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("samtools/1.15.1", "bcftools/1.15.1", "pbipa/1.3.2", "racon/1.5.0", "merfin/1.0", "meryl/1.3", "winnowmap/2.03")
prepend_path("PATH", pathJoin(apphome, "automated_polishing"))
__END__
