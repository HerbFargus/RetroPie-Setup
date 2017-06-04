#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="digger"
rp_module_desc="Digger - Arcade digging game from 1983"
rp_module_licence="GPL https://raw.githubusercontent.com/sobomax/digger/master/digger.txt"
rp_module_section="opt"
rp_module_flags="!mali"

function depends_digger() {
    getDepends libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev build-essential
}

function sources_digger() {
    gitPullOrClone "$md_build" https://github.com/sobomax/digger.git
}

function build_digger() {
    make
    md_ret_require="$md_build"
}

function install_digger() {
    md_ret_files=(
        'digger'
    )
}

function configure_digger() {
    addPort "$md_id" "digger" "Digger" "pushd $md_inst; $md_inst/digger; popd"
}
