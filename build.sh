#!/bin/bash
set -e
env
cwd=`pwd`
mkdir -p tmp/xhyve
[ ! -d tmp/xhyve/.git ] && git clone https://github.com/mist64/xhyve.git tmp/xhyve

cd tmp/xhyve
git fetch
git reset --hard origin/master

make
cd $cwd

mkdir -p lib/xhyve/vendor
cp tmp/xhyve/build/xhyve lib/xhyve/vendor
