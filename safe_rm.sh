#！/bin/bash

function clear_terminal() {
     echo -en `clear`
}

function move_cursor() {
     line=$1
     col=$2
     tput cup ${line} ${col}
}

function check_remove_target() {
     echo "nothing check_remove_target"
}

function safe_remove_file() {
     echo "nothing safe_remove_file"
}

function safe_remove_folder() {
     echo "nothing safe_remove_folder"
}

function run_safe_rm() {
     clear_terminal

     remove_target=$(check_remove_target)

     if [ "${remove_target}" == "file" ]; then
          safe_remove_file
     elif [ "${remove_target}" == "folder" ]; then
          safe_remove_folder
     else
          echo "not support remove target..."
     fi
}

run_safe_rm
