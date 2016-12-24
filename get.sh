#!/bin/bash

DIR=/tmp/russleyshaw/dotfiles/
rm -rf ${DIR}
git clone https://github.com/russleyshaw/dotfiles.git ${DIR}
cd ${DIR}

echo "Which configuration do you want to use?"
select config in "laptop" "desktop"; do
    export DOTFILE_CONFIG=config
done

bash ./install.sh