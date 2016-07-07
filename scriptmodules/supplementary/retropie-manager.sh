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
rp_module_desc="Web Based Manager for RetroPie files and configs based on the Recalbox Manager"
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
    gitPullOrClone "$md_build" "https://github.com/botolo78/RetroPie-Manager.git"
}

function build_retropie-manager() {
    md_ret_require="$md_build"
}

function install_retropie-manager() {
    make install
    md_ret_files=(
    "compass"
    "bin"
    "project"
    "lib"
    "include"
    "deployment"
    "pip-requirements"
    "manage.py"
    "Gruntfile.js"
    "db.sqlite3"
    "__init__.py"
)
chown -R "$user":"$user" "$md_inst"
}

function enable_retropie-manager() {
    local config="\"$md_inst/bin/python\" \"$md_inst/manage.py\" runserver 0.0.0.0:8000 --settings=project.settings_production --noreload \&"

    if grep -q "runserver" /etc/rc.local; then
        dialog --yesno "RetroPie-Manager is already enabled in /etc/rc.local with the following config. Do you want to update it ?\n\n$(grep "runserver" /etc/rc.local)" 22 76 2>&1 >/dev/tty || return
    fi

    sed -i "/runserver/d" /etc/rc.local
    sed -i "s|^exit 0$|${config}\\nexit 0|" /etc/rc.local
    printMsgs "dialog" "RetroPie-Manager enabled in /etc/rc.local with the following config\n\n$config\n\nIt will be started on next boot."
    
}

function disable_retropie-manager() {
    sed -i "/runserver/d" /etc/rc.local
    printMsgs "dialog" "RetroPie-Manager configuration in /etc/rc.local has been removed."
}

function gui_retropie-manager() {
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)

    while true; do
        local options=(
            1 "Enable RetroPie-Manager on Boot"
            2 "Disable RetroPie-Manager Boot"
        )
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [[ -n "$choice" ]]; then

            case $choice in
                1)
                    enable_retropie-manager
                    ;;
                2)
                    disable_retropie-manager
                    ;;
            esac
        else
            break
        fi
    done
}
