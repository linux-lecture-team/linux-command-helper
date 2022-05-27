#!/bin/bash

declare -i input_cursor_line=10
declare -i input_cursor_col=0

function ls_helper() {
    clear_terminal

    ls_helper_manual=`cat resource/ls_helper_manual.txt`
    echo "${ls_helper_manual}"

    move_cursor ${input_cursor_line} ${input_cursor_col}
    echo "ls 명령어를 수행할 절대 경로 혹은 상대 경로를 입력하세요..."
    read -p "> " ls_target_path

    move_cursor `expr ${input_cursor_line} + 2` ${input_cursor_col}
    echo "ls 명령어의 옵션을 -를 제외하고 입력하세요..."
    read -p "> " ls_target_option

    cd ${ls_target_path}

    if [ "${ls_target_option}" == "" ]; then
        ls_execute_result=`ls`
    else
        ls_execute_result=`ls -${ls_target_option}`
    fi
    
    echo "${ls_execute_result}"
}

ls_helper

