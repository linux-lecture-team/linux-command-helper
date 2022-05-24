#!/bin/bash

function clear_terminal() {
    echo -n `clear`
}

function move_cursor() {
     line=$1
     col=$2
     tput cup ${line} ${col}
}

function visible_cursor() {
    option=$1

    if [ ${option} == "on" ]; then
        tput cnorm
    elif [ ${option} == "off" ]; then
        tput civis
    fi
}

function linux_command_helper() {
    visible_cursor "off"
    echo "Hello World!"
    visible_cursor "on"
}

linux_command_helper