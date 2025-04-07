#!/bin/bash
module purge
set -eux

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=/large/yoshihiko_s/app
APP=interproscan
VER=5.73-104.0

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
mkdir -p $VER
cd $VER
singularity pull $APP.sif docker://interpro/$APP:$VER
curl -O http://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/$VER/alt/interproscan-data-$VER.tar.gz
tar xzvf interproscan-data-$VER.tar.gz
for CMD in interproscan.sh; do
    echo '#!/bin/sh' >$CMD
    echo "singularity exec -v $APPDIR/$VER/interproscan-$VER/data:/opt/interproscan/data $APPDIR/$VER/$APP.sif /opt/interproscan/$CMD \$*" >>$CMD
    chmod +x $CMD
done

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
setenv("SINGULARITY_BIND", "/home,/fast,/large")
__END__
