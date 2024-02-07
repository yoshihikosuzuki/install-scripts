#!/bin/bash
module purge
set -eux

MODROOT=/large/yoshihiko_s/app
APP=pepper_deepvariant
VER=0.8

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

SINGULARITY_TMPDIR=$(pwd) singularity pull $APP.sif docker://kishwars/$APP:r$VER
CMD=run_pepper_margin_deepvariant
cat <<__END__ >$CMD
#!/bin/sh
singularity exec $APPDIR/$APP.sif run_pepper_margin_deepvariant call_variant \$*
__END__
chmod +x $CMD
# NOTE: need `pip install altair`
# NOTE: Following error occurs when `singularity exec`:
#       FATAL:   container creation failed: mount /proc/self/fd/3->/var/lib/singularity/mnt/session/rootfs error: while mounting image /proc/self/fd/3: kernel reported a bad superblock for squashfs image partition, possible causes are that your kernel doesn't support the compression algorithm or the image is corrupted

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
