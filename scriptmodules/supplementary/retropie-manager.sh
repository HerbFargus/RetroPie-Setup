#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="retropie-manager"
rp_module_desc="Web Based Manager for RetroPie files and configs"
rp_module_help="Open your browser and go to http://your_retropie_ip:8000/"
rp_module_section="exp"

function depends_retropie-manager() {
    local depends=(python-dev)
    if [[ "$__raspbian_ver" -lt "8" ]]; then
        depends+=(virtualenv)
    else
        depends+=(python-virtualenv)
    fi
    getDepends "${depends[@]}"
}

function sources_retropie-manager() {
    gitPullOrClone "$md_build" "https://github.com/HerbFargus/retropie-manager.git" "retropie"
}

function install_retropie-manager() {
    cd "$md_inst"
    make install
}

#function configure_retropie-manager() {
#    TODO: Start Python script, Add to autostart function
#    bin/python manage.py rserver 0.0.0.0:8000 --settings=project.settings_production --noreload
#}
