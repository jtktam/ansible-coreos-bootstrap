#/bin/bash

set -e

cd

## if already bootstrapped, quit
if [[ -e $HOME/.bootstrapped ]]; then
  exit 0
fi

## define download version and URL
PYPY_VERSION=2.4.0
PYPY_URL=https://bitbucket.org/pypy/pypy/downloads

## download and untar pypy
wget -O - $PYPY_URL/pypy-$PYPY_VERSION-linux64.tar.bz2 |tar -xjf -
mv -n pypy-$PYPY_VERSION-linux64 pypy

## library fixup
mkdir -p pypy/lib
ln -snf /lib64/libncurses.so.5.9 $HOME/pypy/lib/libtinfo.so.5

## create python shell stub
mkdir -p $HOME/bin

cat > $HOME/bin/python <<EOF
#!/bin/bash
LD_LIBRARY_PATH=$HOME/pypy/lib:$LD_LIBRARY_PATH exec $HOME/pypy/bin/pypy "\$@"
EOF

## make stub executable
chmod +x $HOME/bin/python
$HOME/bin/python --version

## create .bootstrapped file to bypass
touch $HOME/.bootstrapped
