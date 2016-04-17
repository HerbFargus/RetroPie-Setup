#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="linapple"
rp_module_desc="Apple 2 emulator LinApple"
rp_module_menus="2+"
rp_module_flags="dispmanx !mali"

function depends_linapple() {
    getDepends libzip-dev libsdl1.2-dev libcurl4-openssl-dev
}

function sources_linapple() {
    gitPullOrClone "$md_build" https://github.com/dabonetn/linapple-pie.git
}

function build_linapple() {
    cd src
    make clean
    make
}

function install_linapple() {
    mkdir -p "$md_inst/ftp/cache"
    mkdir -p "$md_inst/images"
    md_ret_files=(
    'CHANGELOG'
    'INSTALL'
    'LICENSE'
    'linapple'
    'Master.dsk'
    'README'
    'README-linapple-pie'
    'linapple.conf'
    )
    # install linapple.conf under another name as we will copy it
    cp -v "$md_build/linapple.conf" "$md_conf_root/apple2/linapple.conf"
    cp -v "$md_build/Master.dsk" "$md_conf_root/apple2/Master.dsk"
}

function configure_linapple() {
    mkRomDir "apple2"
    mkUserDir "$md_conf_root/apple2"

    addSystem 1 "$md_id" "apple2" "$md_inst/linapple -1 %ROM%" "Apple II" ".po .dsk .nib"

<<<<<<< HEAD
    moveConfigDir "$home/.linapple" "$md_conf_root/apple2"
    chown -R $user:$user "$md_conf_root/apple2"
=======
    rm -f "$romdir/apple2/Start.txt"
    cat > "$romdir/apple2/+Start LinApple.sh" << _EOF_
#!/bin/bash
pushd "$md_inst"
./linapple
popd
_EOF_
    chmod +x "$romdir/apple2/+Start LinApple.sh"

    mkUserDir "$md_conf_root/apple2"

    # if the user doesn't already have a config, we will copy the default.
    if [[ ! -f "$md_conf_root/apple2/linapple.conf" ]]; then
        cp -v "linapple.conf.sample" "$md_conf_root/apple2/linapple.conf"
        iniConfig " = " "" "$md_conf_root/apple2/linapple.conf"
        iniSet "Joystick 0" "1"
        iniSet "Joystick 1" "1"
    fi
    ln -sf "$md_conf_root/apple2/linapple.conf"
    chown $user:$user "$md_conf_root/apple2/linapple.conf"

    addSystem 1 "$md_id" "apple2" "$romdir/apple2/+Start\ LinApple.sh" "Apple II" ".sh"
>>>>>>> c890d526c3a8c909a4a2b542d85860f743a4b445
}
