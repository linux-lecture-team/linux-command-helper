#!/bin/bash

# 입력을 받는 커서의 라인입니다.
declare -i input_cursor_line=5

# 입력을 받는 커서의 열입니다.
declare -i input_cursor_col=0

# rm_helper의 옵션 메뉴얼입니다.
rm_helper_manual=`cat resource/rm_helper_manual.txt`


#######################################
# 터미널에 rm_helper 메뉴얼을 표시합니다.
# Globals:
#   rm_helper_manual
# Arguments:
#   None
# Outputs:
#   None
#######################################
function draw_rm_helper_manual() {
    echo "${rm_helper_manual}"
}


#######################################
# rm_helper를 실행합니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function rm_helper() {
    # 시작 전에 터미널을 초기화합니다.
    clear_terminal


    # rm_helper 메뉴얼을 터미널에 표시합니다. 
    draw_rm_helper_manual


    # rm 명령을 수행할 경로를 입력받습니다.
    move_cursor ${input_cursor_line} ${input_cursor_col}
    echo "rm 명령어를 수행할 파일 혹은 디렉토리 경로를 입력하세요..."
    read -p "> " rm_target_path


    # rm 옵션을 입력 받습니다.
    move_cursor `expr ${input_cursor_line} + 2` ${input_cursor_col}
    echo "rm 명령어의 옵션을 -를 제외하고 입력하세요..."
    read -p "> " rm_target_option


    # 사용자의 입력에 맞게 rm 명령을 수행합니다.
    if [ "${rm_target_path}" != "" ]; then
        `rm -${rm_target_option} ${rm_target_path}`
    fi
}

# rm_helpe를 실행합니다.
rm_helper