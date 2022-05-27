#!/bin/bash

function clear_terminal() {
    echo -n `clear`
}

function move_cursor() {
     line=$1
     col=$2
     tput cup ${line} ${col}
}

declare -i input_cursor_line=5
declare -i input_cursor_col=0

function rm_helper() {
    clear_terminal

    rm_helper_manual=`cat resource/rm_helper_manual.txt`
    echo "${rm_helper_manual}"

    move_cursor ${input_cursor_line} ${input_cursor_col}
    echo "rm 명령어를 수행할 파일 혹은 디렉토리 경로를 입력하세요..."
    read -p "> " rm_target_path

    move_cursor `expr ${input_cursor_line} + 2` ${input_cursor_col}
    echo "rm 명령어의 옵션을 -를 제외하고 입력하세요..."
    read -p "> " rm_target_option

    if [ "${rm_target_path}" != "" ]; then
        `rm -${rm_target_option} ${rm_target_path}`
    fi
}

rm_helper