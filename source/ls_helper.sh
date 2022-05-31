#!/bin/bash

# 입력을 받는 커서의 라인입니다.
declare -i input_cursor_line=10

# 입력을 받는 커서의 열입니다.
declare -i input_cursor_col=0

# ls_helper의 옵션 메뉴얼입니다.
ls_helper_manual=`cat resource/ls_helper_manual.txt`


#######################################
# 터미널에 ls_helper 메뉴얼을 표시합니다.
# Globals:
#   ls_helper_manual
# Arguments:
#   None
# Outputs:
#   None
#######################################
function draw_ls_helper_manual() {
    echo "${ls_helper_manual}"
}


#######################################
# ls_helper를 실행합니다.
# Globals:
#   None
# Arguments:
#   $1 텍스트 파일명
# Outputs:
#   None
#######################################
function ls_helper() {
    # 시작 전에 터미널을 초기화합니다.
    clear_terminal


    # ls_helper 메뉴얼을 터미널에 표시합니다.
    draw_ls_helper_manual
    
    
    move_cursor ${input_cursor_line} ${input_cursor_col}
    echo "ls 명령어를 수행할 절대 경로 혹은 상대 경로를 입력하세요..."
    read -p "> " ls_target_path

    move_cursor `expr ${input_cursor_line} + 2` ${input_cursor_col}
    echo "ls 명령어의 옵션을 -를 제외하고 입력하세요..."
    read -p "> " ls_target_option

    if [ "${ls_target_option}" == "" ]; then
        ls_execute_result=`ls ${ls_target_path}`
    else
        ls_execute_result=`ls -${ls_target_option} ${ls_target_path}`
    fi
    
    echo "${ls_execute_result}"
}

# ls_helper를 실행합니다.
ls_helper