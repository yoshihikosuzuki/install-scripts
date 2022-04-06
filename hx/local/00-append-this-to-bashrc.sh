source /bio/package/gcc/setup9.sh

alias wget='wget --no-check-certificate'

export PATH="$HOME/.local/bin:$PATH"
export LIBRARY_PATH="$HOME/.local/lib:$HOME/.local/lib64:$LIBRARY_PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:$HOME/.local/lib64:$LD_LIBRARY_PATH"
export LDFLAGS="-L$HOME/.local/lib -L$HOME/.local/lib64 $LDFLAGS"
export CPATH="$HOME/.local/include:$CPATH"
export CPPFLAGS="-I$HOME/.local/include $CPPFLAGS"
