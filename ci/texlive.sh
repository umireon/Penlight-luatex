#!/bin/sh
INSTALL_TL_URL=http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
INSTALL_TL_DIR=$HOME/install-tl
export TEXLIVE_INSTALL_PREFIX=$HOME/texlive

if [ ! -x $TEXLIVE_INSTALL_PREFIX/bin/*/tex ]; then
  mkdir -p $INSTALL_TL_DIR
  echo "
    selected_scheme scheme-basic
    option_doc 0
    option_src 0
  " > $INSTALL_TL_DIR/texlive.profile
  curl -L $INSTALL_TL_URL | tar xz -C $INSTALL_TL_DIR
  $INSTALL_TL_DIR/install-tl-*/install-tl -portable -profile $INSTALL_TL_DIR/texlive.profile 1>&2
fi

TEXLIVE_BIN=`dirname $TEXLIVE_INSTALL_PREFIX/bin/*/tex`

echo export PATH=\'$TEXLIVE_BIN\':\$PATH
