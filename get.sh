#!/bin/bash

DIR=/tmp/russleyshaw/dotfiles/
REPO=https://github.com/russleyshaw/dotfiles.git
REPO=
rm -rf ${DIR}
git clone ${REPO} ${DIR}
cd ${DIR}

bash ./install.sh