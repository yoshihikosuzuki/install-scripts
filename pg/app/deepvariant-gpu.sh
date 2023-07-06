#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=deepvariant-gpu
VER=1.5.0

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

singularity pull deepvariant.sif docker://google/deepvariant:$VER-gpu
for CMD in run_deepvariant make_examples call_variants postprocess_variants; do
    echo '#!/bin/sh' >$CMD
    echo "singularity exec --nv $APPDIR/deepvariant.sif $CMD \$*" >>$CMD
    chmod +x $CMD
done
# TODO: pip install altair?

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
unsetenv("PERL5LIB")
setenv("PERL_BADLANG", "0")
setenv("SINGULARITY_BIND", "/data,/glusterfs,/glusterfs2,/glusterfs3,/grid2,/hpgdata,/hpgwork,/hpgwork2,/nfs/data05,/nfs/data06,/nfs/data07,/nfs/data08")
__END__
