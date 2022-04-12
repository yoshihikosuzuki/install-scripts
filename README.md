# Collection of scripts for installing Lmod modules on HPC

## How to load a module

```bash
. $LMOD_INIT            # Make Lmod available; Specific to HPC (see below)
module use $MODROOT     # Make the modules under $MODROOT visible to Lmod
module load $APP/$VER   # Load a module
```

## List of HPCs and their `$LMOD_INIT`

| Name | Description | `$LMOD_INIT` |
|:-|:-|:-|
| Deigo | OIST's HPC |  `/apps/free/lmod/lmod/init/bash` |
| hx | Morishita lab's HPC for non-human researches | `/home/yoshihiko_s/.local/lmod/lmod/init/bash` |
| pg | Morishita lab's HPC for human researches | `/home/yoshihiko_s/.local/lmod/lmod/init/bash` |
| Oakbridge-CX (OBCX) | UT's HPC | (Not installed yet) |

**NOTE**: The installation script of Lmod for hx and pg is `hx/local/01-lmod.sh` and `pg/local/01-lmod.sh`, respectively, in this repository.

## List of `$MODROOT`s

### Deigo

| Name | `$MODROOT` |
|:-|:-|
| Pre-installed<br>(loaded on login) | `/apps/.modulefiles81` |
| Additional pre-installed | `/apps/.modulefiles72` |
| Bioinfo Ugrp | `/apps/.bioinfo-ugrp-modulefiles81` |
| DebianMed<br>(needs Bioinfo Ugrp) | `/apps/unit/BioinfoUgrp/DebianMed/10.7/modulefiles` |
| MyersU | `/hpcshare/appsunit/MyersU/.modulefiles` |
| Yoshi's personal | `/hpcshare/appsunit/MyersU/yoshihiko-suzuki/.modulefiles` |

### hx

| Name | `$MODROOT` |
|:-|:-|
| Yoshi's personal | `/work/yoshihiko_s/app/.modulefiles` |

### pg

| Name | `$MODROOT` |
|:-|:-|
| Yoshi's personal | `/hpgwork2/yoshihiko_s/app/.modulefiles` |

### Oakbridge-CX

| Name | `$MODROOT` |
|:-|:-|
|||

## Supplementary information

### Directory structure of modules and modulefiles

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

Every installation of a module overall takes the following form:

```bash
#!/bin/bash
set -eux

# LOAD DEPENDENCIES IF NEEDED
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

Basically what you need to do for a specific software's installation are:

1. Set `$MODROOT`, `$APP`, and `$VER` variables
2. Modify the "DOWNLOAD AND INSTALL" part
3. Modify the "Package settings" part in the modulefile
4. Run the script
