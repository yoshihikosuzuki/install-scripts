# Collection of scripts for installing Lmod modules on HPC

## TODO

- hx,pg の `/bio/package` 以下のソフトウエアを Lmod module 化する
- hx,pg のインストールスクリプトを `$HOME/.bashrc` に依存しないようにする、CentOS 6 でも使えるようにする
- pg のプロキシ設定を `$HOME` 以下の設定ファイルに依存しないようにする、もしくは依存を明記する

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
| hx | Morishita lab's HPC for non-human researches | `/bio/lmod/lmod/init/bash` |
| pg | Morishita lab's HPC for human researches | `/bio/lmod/lmod/init/bash` |
| Oakbridge-CX (OBCX) | UT's HPC | ? |

**NOTE**: The bundle of commands used for installing Lmod to hx and pg is summarized in `hx/bio/lmod.sh` and `pg/bio/lmod.sh` in this repository, respectively.

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
| Imported from `/bio/package` | TBA |
| Yoshi's personal | `/work/yoshihiko_s/app/.modulefiles` |

### pg

| Name | `$MODROOT` |
|:-|:-|
| Imported from `/bio/package` | TBA |
| Yoshi's personal | `/hpgwork2/yoshihiko_s/app/.modulefiles` |

### Oakbridge-CX

| Name | `$MODROOT` |
|:-|:-|
|||

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

In general, every installation of a module overall takes the following form (`template/general.sh` in this repository):

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

0. Revert to the *default* shell environment (i.e. no modules, no functions/aliases, no user-appended PATH/etc.) as much as possible.
1. Set `$MODROOT`, `$APP`, and `$VER` variables.
2. Modify the "DOWNLOAD AND INSTALL" part and "LOAD DEPENDENCIES" (possibly while installing the software).
3. Modify the "Package settings" part in the modulefile.
4. Run the script.

In the `template/` directory of this repository, there are template installation scripts for several installation types:

| Installation Type | File name |
|:-|:-|
| Make | `make.sh` |
| Autotools | `autotools.sh` |
| Python/pip | `python.sh` |
| Anaconda/Bioconda | `conda.sh` |
| R | `R.sh` |
| Singularity/Docker | `singularity.sh` |
