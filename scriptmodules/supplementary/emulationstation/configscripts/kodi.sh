#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

function onstart_kodi_joystick() {
    local device_type=$1
    local device_name=$2
    local file
    
    case "$device_name" in
        *)
            file="$configdir/ports/kodi/userdata/keymaps/${device_name// /}.xml"
            ;;
    esac

    # create mapping dir if necessary.
    mkdir -p "$configdir/ports/kodi/userdata/keymaps"

    # remove old config file
    rm -f "$file"

    # write config template
    cat > "$file" << _EOF_
<?xml version="1.0" encoding="UTF-8"?>
<keymap>
  <global>
    <joystick name="Xbox Gamepad (userspace driver)">
_EOF_

    # write temp file header
    iniConfig " = " "" "$file"
    iniSet "<joystick name" "\"$device_name\">"
}

function map_kodi_joystick() {
    local device_type="$1"
    local device_name="$2"
    local input_name="$3"
    local input_type="$4"
    local input_id="$5"
    local input_value="$6"

    local keys
    local dir
    case "$input_name" in
        up)
            keys=("btn_dpad1_up")
            ;;
        down)
            keys=("btn_dpad1_down")
            ;;
        left)
            keys=("btn_dpad1_left")
            ;;
        right)
            keys=("btn_dpad1_right")
            ;;
        a)
            keys=(btn_a)
            ;;
        b)
            keys=("btn_b")
            ;;
        x)
            keys=("btn_x")
            ;;
        y)
            keys=("btn_y")
            ;;
        leftbottom)
            keys=("btn_trigger_left")
            ;;
        rightbottom)
            keys=("btn_trigger_right")
            ;;
        lefttop)
            keys=("axis_trigger_left")
            ;;
        righttop)
            keys=("axis_trigger_right")
            ;;
        leftthumb)
            keys=("left_analogue_stick_button")
            ;;
        rightthumb)
            keys=("right_analogue_stick_button")
            ;;
        start)
            keys=("btn_start")
            ;;
        select)
            keys=("btn_escape")
            ;;
        leftanalogleft)
            keys=("axis_x")
            ;;
        leftanalogright)
            keys=("axis_x")
            ;;
        leftanalogup)
            keys=("axis_y")
            ;;
        leftanalogdown)
            keys=("axis_y")
            ;;
        rightanalogleft)
            keys=("axis_dpad1_x")
            ;;
        rightanalogright)
            keys=("axis_dpad1_x")
            ;;
        rightanalogup)
            keys=("axis_dpad1_y")
            ;;
        rightanalogdown)
            keys=("axis_dpad1_y")
            ;;
        *)
            return
            ;;
    esac

    local key
    local value
    for key in "${keys[@]}"; do
        # read key value. Axis takes two key/axis values.
        case "$input_type" in
            axis) 
                # key "X/Y Axis" needs different button naming
                if [[ "$key" == "axis_trigger_left" ]] ; then
				    iniSet "<!--LEFT TRIGGER--><axis limit=\"-1\" id" "\"$input_id\">ScrollDown</axis>"
                elif [[ "$key" == "axis_trigger_right" ]] ; then
				    iniSet "<!--RIGHT TRIGGER--><axis limit=\"+1\" id" "\"$input_id\">ScrollUp</axis>"
                elif [[ "$key" == "btn_dpad1_up" ]]; then
				    iniSet "<!--DPAD UP--><hat id" "\"$input_id\"position="up">Up</hat>"
                elif [[ "$key" == "btn_dpad1_down" ]]; then
				    iniSet "<!--DPAD DOWN--><hat id" "\"$input_id\"position="down">Down</hat>"
                elif [[ "$key" == "btn_dpad1_left" ]]; then
				    iniSet "<!--DPAD LEFT--><hat id" "\"$input_id\"position="left">Left</hat>"
                elif [[ "$key" == "btn_dpad1_right" ]]; then
				    iniSet "<!--DPAD RIGHT--><hat id" "\"$input_id\"position="right">Right</hat>"
                fi
                ;;
            hat)
                if [[ "$key" == "btn_dpad1_up" ]]; then
				    iniSet "<!--DPAD UP--><hat id" "\"$input_id\"position="up">Up</hat>"
                elif [[ "$key" == "btn_dpad1_down" ]]; then
				    iniSet "<!--DPAD DOWN--><hat id" "\"$input_id\"position="down">Down</hat>"
                elif [[ "$key" == "btn_dpad1_left" ]]; then
				    iniSet "<!--DPAD LEFT--><hat id" "\"$input_id\"position="left">Left</hat>"
                elif [[ "$key" == "btn_dpad1_right" ]]; then
				    iniSet "<!--DPAD RIGHT--><hat id" "\"$input_id\"position="right">Right</hat>"
                fi
                ;;
            *)
                if [[ "$key" == "btn_a" ]] ; then
				    iniSet "<!--A--><button id>" "\"$input_id\">Select</button>"
                elif [[ "$key" == "btn_b" ]] ; then
				    iniSet "<!--B--><button id>" "\"$input_id\">ParentDir</button>"
                elif [[ "$key" == "btn_x" ]] ; then
				    iniSet "<!--X--><button id>" "\"$input_id\">FullScreen</button>"
                elif [[ "$key" == "btn_y" ]] ; then
				    iniSet "<!--Y--><button id>" "\"$input_id\">ContextMenu</button>"
                elif [[ "$key" == "btn_trigger_left" ]] ; then
				    iniSet "<!--LEFT SHOULDER BUTTON--><button id>" "\"$input_id\">Stop</button>"
                elif [[ "$key" == "btn_trigger_right" ]] ; then
				    iniSet "<!--RIGHT SHOULDER BUTTON--><button id>" "\"$input_id\">Pause</button>"
                elif [[ "$key" == "btn_escape" ]] ; then
				    iniSet "<!--BACK--><button id>" "\"$input_id\">PreviousMenu</button>"
                elif [[ "$key" == "btn_start" ]] ; then
				    iniSet "<!--START--><button id>" "\"$input_id\">XBMC.ActivateWindow(settings)</button>"
                elif [[ "$key" == "left_analogue_stick_button" ]] ; then
				    iniSet "<!--LEFT ANALOGUE STICK BUTTON-->" "\"$input_id\">Playlist</button>"
                elif [[ "$key" == "right_analogue_stick_button" ]] ; then
				    iniSet "<!--RIGHT ANALOGUE STICK BUTTON--><button id>" "\"$input_id\">XBMC.UpdateLibrary(video)</button>"
#                if [[ "$key" != *axis* || "$key" == "btn_a" ]] ; then
#				    iniSet "      <!--A--><button id>" "\"$input_id\">Select</button>"
#               elif [[ "$key" != *axis* || "$key" == "btn_b" ]] ; then
#				    iniSet "<!--B--><button id>" "\"$input_id\">ParentDir</button>"
#				elif [[ "$key" == "btn_a" ]] ; then
#				iniSet "      <button id=\"" "$input_id" "\">Select</button><!--A-->"
#				elif [[ "$key" == "btn_b" ]] ; then
#				iniSet "      <button id\"" "$input_id" "\"ParentDir</button><!--B-->"
                fi
                ;;
        esac
    done
}
function onend_kodi_joystick() {
    local device_type=$1
    local device_name=$2
    local file
    
    case "$device_name" in
        *)
            file="$configdir/ports/kodi/userdata/keymaps/${device_name// /}.xml"
			iniConfig "" "" "$file"
 			iniSet "</joystick>" "</global>" 
 			iniSet "</keymap>"
 #			iniSet "</keymap>"
            ;;
    esac
    
    # add empty end line
    echo "" >> "$file"
}
