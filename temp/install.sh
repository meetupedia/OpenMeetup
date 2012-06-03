#!/bin/bash
mkdir -p ~/local
command -v identify > /dev/null
if [ $? -eq 1 ]; then
    echo "${bldgrn}Installing imagemagick into ${txtwht}$HOME/local/imagemagick${txtrst}"
        wget -N --retr-symlinks ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz
            tar -xzvf ImageMagick.tar.gz
                cd ImageMagick-*
                    ./configure --prefix=$HOME/local/imagemagick
                        make
                            make install
                                cd ..
                                    rm -rf ImageMagick-*
                                    fi