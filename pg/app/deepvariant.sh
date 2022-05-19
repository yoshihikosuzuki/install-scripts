#!/bin/bash
module purge
set -eux

MODROOT=/hpgwork2/yoshihiko_s/app
APP=deepvariant
VER=1.1.0

APPDIR=$MODROOT/$APP/$VER
mkdir -p $APPDIR
cd $APPDIR

singularity pull $APP.sif docker://google/$APP:$VER
for CMD in run_deepvariant make_examples call_variants postprocess_variants; do
    echo '#!/bin/sh' >$CMD
    echo "singularity exec $APPDIR/$APP.sif $CMD \$*" >>$CMD
    chmod +x $CMD
done

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
setenv("SINGULARITY_BIND", "/bio,/data,/glusterfs,/glusterfs2,/glusterfs3,/grid,/grid2,/home,/hpgdata,/hpgwork,/hpgwork2")
__END__
