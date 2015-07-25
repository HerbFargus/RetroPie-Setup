#!/usr/bin/env bash

# This file is part of RetroPie.
# 
# (c) Copyright 2012-2015  Florian Müller (contact@petrockblock.com)
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="smw"
rp_module_desc="Super Mario War"
rp_module_menus="4+"
rp_module_flags="nobin"

function sources_smw() {
    gitPullOrClone "$md_build" https://github.com/HerbFargus/smw.git
}

function build_smw() {
    cd smw
    chmod +x configure
    ./configure
    make clean
}

function install_smw() {
    cd smw
    make install
}

function configure_smw() {
    mkRomDir "ports"

     cat > "$romdir/ports/Super Mario War.sh" << _EOF_
#!/bin/bash
/opt/retropie/supplementary/runcommand/runcommand.sh 0 "smw" "smw"
_EOF_

  chmod +x "$romdir/ports/Super Mario War.sh"

    setESSystem 'Ports' 'ports' '~/RetroPie/roms/ports' '.sh .SH' '%ROM%' 'pc' 'ports'
}
