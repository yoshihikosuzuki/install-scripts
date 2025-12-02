# Collection of scripts for installing Lmod modules on HPC

## How to load a module

```bash
. /path/to/lmod/init/bash   # Make Lmod available (the path depends on environment)
module use $MODROOT         # Make the modules under the $MODROOT directory visible to Lmod
module load $APP/$VER       # Load a module
```

## Directory structure of modules and modulefiles

Given a root path where the modules are to be installed, `$MODROOT`, a module named `$APP` whose version is `$VER` along with its modulefile (i.e. a Lua file) is installed in the following directory structure:

```
$MODROOT/
├── .modulefiles/
│   ├── $APP1/
│   │    └── $VER.lua
│   ├── $APP2/
│   │    └── $VER.lua
│   └── ...
├── $APP1/
│    └── $VER/
│         ├── bin/
│         ├── lib/
│         └── ...
├── $APP2/
│    └── $VER/
│         ├── bin/
│         ├── lib/
│         └── ...
└── ...
```

## How to install a module

In general, every installation of a module overall takes the following form (`template.sh`):

```bash
#!/bin/bash
module purge
set -eux

# LOAD DEPENDENCIES IF NEEDED
module use /path/to/.modulefiles
module load XXX

# DEFINE WHERE TO INSTALL, APP NAME AND VERSION
MODROOT=
APP=
VER=

# MAKE THE MODULE DIRECTORY
APPDIR=$MODROOT/$APP
mkdir -p $APPDIR && cd $APPDIR

# DOWNLOAD AND INSTALL TO `$APPDIR/$VER`
...

# WRITE A MODULEFILE
cd $MODROOT/.modulefiles && mkdir -p $APP
cat <<__END__ >$APP/$VER.lua
-- Default settings
local modroot    = "$MODROOT"
local appname    = myModuleName()
local appversion = myModuleVersion()
local apphome    = pathJoin(modroot, myModuleFullName())

-- Package settings
depends_on("XXX")
prepend_path("PATH", apphome)
...
__END__
```
