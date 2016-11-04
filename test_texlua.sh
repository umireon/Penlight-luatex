#!/usr/bin/bash
export LUAINPUTS='..//'
for f in `cd Penlight; ls tests/*.lua`; do
  n=`basename $f .lua`
  echo $f
  echo "
    package.path = '../?.lua'
    require 'lua-penlight'
    package.path = 'tests/lua/?.lua'
    dofile('$f')
  " | ( cd Penlight && texlua ../test_texlua/$n.lua)
  [ $? == 0 ] || exit 1
done
