#!/bin/bash

function clear_terminal() {
    echo -n `clear`
}

function move_cursor() {
     line=$1
     col=$2
     tput cup ${line} ${col}
}

function linux_command_helper() {
    echo "Hello World!"
}

linux_command_helper