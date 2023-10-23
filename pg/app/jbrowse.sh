#!/bin/bash
module purge
set -eux

MODROOT=/nfs/data05/yoshihiko_s/app
APP=jbrowse
VER=2.7.1

APPDIR=$MODROOT/$APP
mkdir -p $APPDIR
cd $APPDIR

mkdir $VER
cd $VER
npm install @jbrowse/cli

CMD=jbrowse
cat <<__END__ >$CMD
#!/bin/bash
npx $APPDIR/$VER/node_modules/@jbrowse/cli \$*
__END__
chmod +x $CMD

CMD=jbrowse_run
cat <<__END__ >$CMD
#!/bin/bash
npx serve -S . \$*
__END__
chmod +x $CMD

cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
prepend_path("PATH", apphome)
__END__
