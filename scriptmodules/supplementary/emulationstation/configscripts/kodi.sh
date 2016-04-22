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
[dreamcast]
btn_a =
btn_b =
btn_c =
btn_d =
btn_x =
btn_y =
btn_z =
btn_start =
btn_dpad1_left =
btn_dpad1_right =
btn_dpad1_up =
btn_dpad1_down =
btn_dpad2_left =
btn_dpad2_right =
btn_dpad2_up =
btn_dpad2_down =
axis_x =
axis_y =
axis_trigger_left =
axis_trigger_right =

[compat]
btn_trigger_left =
btn_trigger_right =
axis_dpad1_x =
axis_dpad1_y =
axis_dpad2_x =
axis_dpad2_y =
axis_x_inverted =
axis_y_inverted =
axis_trigger_left_inverted =
axis_trigger_right_inverted =

***********
KODI CONFIGURATIONS
***********
<?xml version="1.0" encoding="UTF-8"?>
<keymap>
  <global>
    <joystick name="Xbox Gamepad (userspace driver)">
      <altname>Controller (Xbox 360 Wireless Receiver for Windows)</altname>
      <button id="1">Select</button><!--A-->
      <button id="2">ParentDir</button><!--B-->
      <button id="3">FullScreen</button><!--X-->
      <button id="4">ContextMenu</button><!--Y-->
      <button id="5">Stop</button><!--LEFT SHOULDER BUTTON-->
      <button id="6">Pause</button><!--RIGHT SHOULDER BUTTON-->
      <button id="7">PreviousMenu</button><!--BACK-->
      <button id="7,8">Quit</button><!--BACK+START-->
      <button id="8">XBMC.ActivateWindow(settings) </button><!--START-->
      <button id="9">Playlist</button><!--LEFT ANALOGUE STICK BUTTON-->
      <button id="10">XBMC.UpdateLibrary(video)</button><!--RIGHT ANALOGUE STICK BUTTON-->

      <hat id="1" position="up">Up</hat><!--DPAD UP-->
      <hat id="1" position="down">Down</hat><!--DPAD DOWN-->
      <hat id="1" position="right">Right</hat><!--DPAD RIGHT-->
      <hat id="1" position="left">Left</hat><!--DPAD LEFT-->

      <axis limit="-1" id="2">Up</axis><!--LEFT ANALOGUE UP-->
      <axis limit="+1" id="2">Down</axis><!--LEFT ANALOGUE DOWN-->
      <axis limit="+1" id="1">Right</axis><!--LEFT ANALOGUE RIGHT-->
      <axis limit="-1" id="1">Left</axis><!--LEFT ANALOGUE LEFT-->

      <axis limit="-1" id="4">VolumeUp</axis><!--RIGHT ANALOGUE UP-->
      <axis limit="+1" id="4">VolumeDown</axis><!--RIGHT ANALOGUE DOWN-->
      <axis limit="-1" id="5">AnalogSeekBack</axis><!--RIGHT ANALOGUE LEFT-->
      <axis limit="+1" id="5">AnalogSeekForward</axis> <!--RIGHT ANALOGUE RIGHT-->

      <axis limit="-1" id="3">ScrollDown</axis><!--LEFT TRIGGER-->
      <axis limit="+1" id="3">ScrollUp</axis><!--RIGHT TRIGGER-->
    </joystick>
  </global>
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
            keys=(btn_b)
            ;;
        b)
            keys=("btn_a")
            ;;
        x)
            keys=("btn_y")
            ;;
        y)
            keys=("btn_x")
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
                if [[ "$key" == "btn_trigger_left" ]] ; then
                    iniSet "axis_trigger_left" "$input_id"
                    iniSet "axis_trigger_left_inverted" "no"
                elif [[ "$key" == "btn_trigger_right" ]] ; then
                    iniSet "axis_trigger_right" "$input_id"
                    iniSet "axis_trigger_right_inverted" "no"
                elif [[ "$key" == "btn_dpad1_up" || "$key" == "btn_dpad1_down" ]]; then
                    iniSet "axis_y" "$input_id"
                    iniSet "axis_y_inverted" "no"
                elif [[ "$key" == "btn_dpad1_left" || "$key" == "btn_dpad1_right" ]]; then
                    iniSet "axis_x" "$input_id"
                    iniSet "axis_x_inverted" "no"
                elif [[ "$key" == *axis* ]] ; then
                    case "$device_name" in 
                    esac
                    iniSet "${key}" "$input_id"
                    iniSet "${key}_inverted" "no"
                fi
                ;;
            hat)
                ;;
            *)
                if [[ "$key" != *axis* || "$key" == "btn_a" ]] ; then
				    iniSet "<button id="1">" "\"$input_id\">Select</button><!--A-->"
                if [[ "$key" != *axis* || "$key" == "btn_b" ]] ; then
				    iniSet "<button id="2">" "\"$input_id\">ParentDir</button><!--B-->"
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
            ;;
    esac
    
    # add empty end line
    echo "" >> "$file"
}
