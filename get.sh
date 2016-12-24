#!/bin/bash

DIR=/tmp/russleyshaw/dotfiles/
rm -rf ${DIR}
git clone https://github.com/russleyshaw/dotfiles.git ${DIR}
cd ${DIR}

bash ./install.sh