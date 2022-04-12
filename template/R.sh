#!/bin/bash
set -eux

# LOAD DEPENDENCIES IF NEEDED
module load R/VERSION

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=
APP=
VER=

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
# NOTE: Options for `tar` depend on the file type
wget -O - /path/to/tarball | tar xzvf -
# NOTE: `$APP-$VER` depends on the downloaded file name
mv $APP-$VER $VER && cd $VER && mkdir -p lib/R
# Install dependencies (NOTE: packages depend on the software)
Rscript -e 'install.packages(c("XXX", "YYY"), lib="./lib/R")'
# Use vanilla R for custom scripts (NOTE: command depends on the software)
for FILE in *.R; do sed -i 's|#!/usr/bin/env Rscript|#!/usr/bin/env -S Rscript --vanilla|' ${FILE}; done

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("R/VERSION")
prepend_path("PATH", apphome)
prepend_path("R_LIBS", pathJoin(apphome, "lib/R"))
__END__
