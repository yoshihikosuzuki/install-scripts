#!/bin/bash
module purge
set -eux

MODROOT=/hpgwork2/yoshihiko_s/app
APP=peregrine
VER=1.6.3

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

mkdir $VER
cd $VER
singularity pull $APP.sif docker://cschin/$APP:$VER
cat <<__END__ >$APP
#!/bin/sh
echo yes | singularity run $APPDIR/$VER/$APP.sif asm \$*
__END__
chmod +x $APP

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
setenv("SINGULARITY_BIND", "/data,/glusterfs,/glusterfs2,/glusterfs3,/grid2,/hpgdata,/hpgwork,/hpgwork2,/nfs/data05,/nfs/data06")
execute {
    cmd = "OS_VER=\$(cat /etc/redhat-release | grep -oP '[0-9]+' | head -1); if [ \"\${OS_VER}\" == '6' ]; then printf \"\\\\033[0;33m [WARN]\\\\033[0m \"; echo \"Module " .. appname .. "/" .. appversion .. " does not work on CentOS 6\"; fi",
    modeA = { "load" }
}
__END__
