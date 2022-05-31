#!/bin/bash

# linux_command_helper의 메인 타이틀입니다.
linux_command_helper_main_title=`cat resource/main_title.txt`

# 선택 메뉴 목록입니다.
declare -a select_menu_list=(
    "[01] ls helper"
    "[02] rm helper"
    "[03] user management helper"
    "[04] exit linux command helper"
)

# 선택 메뉴 목록의 인덱스입니다.
declare -i select_menu_index=0

# 선택 메뉴 목록의 최소 인덱스입니다.
declare -i select_menu_min_index=0

# 선택 메뉴 목록의 최대 인덱스입니다.
declare -i select_menu_max_index=3

# 선택 메뉴 목록의 크기입니다.
declare -i select_menu_list_size=4

# 선택 메뉴의 터미널상 라인 위치입니다.
declare -i select_menu_line=14

# 선택 메뉴의 터미널상 열 위치입니다.
declare -i select_menu_col=3

# 실행 여부 목록입니다.
declare -a select_ok_list=(
    "[    OK    ]"
    "[  CANCEL  ]"
)

# 실행 여부 목록의 인덱스입니다.
declare -i select_ok_index=0

# 실행 여부 목록의 최소 인덱스입니다.
declare -i select_ok_min_index=0

# 실행 여부 목록의 최대 인덱스입니다.
declare -i select_ok_max_index=1

# 실행 여부 목록의 크기입니다.
declare -i select_ok_list_size=2

# 실행 여부의 터미널 상 라인 위치입니다.
declare -i select_ok_line=18

# 실행 여부의 터미널 상 열 위치입니다.
declare -i select_ok_col=40

# 선택 메뉴의 실행 여부입니다.
declare -i is_select_ok=0

# 스크립트 루프의 실행 여부입니다.
is_break_loop="no"


#######################################
# 터머널의 텍스트를 초기화합니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function clear_terminal() {
    echo -n `clear`
}


#######################################
# 터머널 커서의 위치를 변경합니다.
# Globals:
#   None
# Arguments:
#   $1 이동할 커서의 라인입니다.
#   $2 이동할 커서의 열입니다.
# Outputs:
#   None
#######################################
function move_cursor() {
     line=$1
     col=$2
     tput cup ${line} ${col}
}


#######################################
# 터머널 커서의 보이기/숨기기 설정을 수행합니다.
# Globals:
#   None
# Arguments:
#   $1 보이기/숨기기를 설정할 옵션입니다.
# Outputs:
#   None
#######################################
function visible_cursor() {
    option=$1

    if [ ${option} == "on" ]; then
        tput cnorm
    elif [ ${option} == "off" ]; then
        tput civis
    fi
}


#######################################
# 터머널의 텍스트 색상을 설정합니다.
# Globals:
#   None
# Arguments:
#   $1 터미널 텍스트의 타입입니다.
#   $2 터미널 텍스트의 색상입니다.
# Outputs:
#   None
#######################################
function set_text_color() {
    text_type=$1
    color_type=$2

    case ${color_type} in
    $"black")
    if [ "${text_type}" == "background" ]; then
        tput setab 0
    elif [ "${text_type}" == "string" ]; then
        tput setaf 0
    fi
    ;;

    $"red")
    if [ "${text_type}" == "background" ]; then
        tput setab 1
    elif [ "${text_type}" == "string" ]; then
        tput setaf 1
    fi
    ;;

    $"green")
    if [ "${text_type}" == "background" ]; then
        tput setab 2
    elif [ "${text_type}" == "string" ]; then
        tput setaf 2
    fi
    ;;

    $"yellow")
    if [ "${text_type}" == "background" ]; then
        tput setab 3
    elif [ "${text_type}" == "string" ]; then
        tput setaf 3
    fi
    ;;

    $"blue")
    if [ "${text_type}" == "background" ]; then
        tput setab 4
    elif [ "${text_type}" == "string" ]; then
        tput setaf 4
    fi
    ;;

    $"magenta")
    if [ "${text_type}" == "background" ]; then
        tput setab 5
    elif [ "${text_type}" == "string" ]; then
        tput setaf 5
    fi
    ;;

    $"cyan")
    if [ "${text_type}" == "background" ]; then
        tput setab 6
    elif [ "${text_type}" == "string" ]; then
        tput setaf 6
    fi
    ;;

    $"white")
    if [ "${text_type}" == "background" ]; then
        tput setab 7
    elif [ "${text_type}" == "string" ]; then
        tput setaf 7
    fi
    ;;
    *)
    echo -n ""
    ;;
    esac
}


#######################################
# 방향키와 엔터키를 입력받습니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   입력받은 키의 문자열을 반환합니다.
#######################################
function input_enter_and_arrow_key() {
    escape_char=$(printf "\u1b")
    read -rsn1 key

    if [[ $key == $escape_char ]]; then
        read -rsn2 key
    fi

    case $key in
        '[A') echo "up" ;;
        '[B') echo "down" ;;
        '[D') echo "left" ;;
        '[C') echo "right" ;;
        '') echo "enter" ;;
        *) >&2 echo -n "" ;;
    esac
}


#######################################
# 터미널에 메인 타이틀을 표시합니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function draw_main_title() {
    move_cursor 0 0
    echo "${linux_command_helper_main_title}"
}


#######################################
# 터미널에 선택 메뉴를 표시합니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function draw_select_menu() {
     for((index=0;index<${select_menu_list_size};index++))
     do
          if [ ${index} == ${select_menu_index} ]; then
               set_text_color "background" "red"
          else
               set_text_color "background" "black"
          fi

          move_cursor `expr ${index} + ${select_menu_line}` ${select_menu_col}
          echo "${select_menu_list[index]}"
     done

     set_text_color "background" "black"
}


#######################################
# 선택 메뉴의 인덱스를 감소시킵니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function up_select_menu_index() {
     select_menu_index=`expr ${select_menu_index} - 1`

     if [[ ${select_menu_index} < ${select_menu_min_index} ]]; then
          select_menu_index=select_menu_max_index
     fi
}


#######################################
# 선택 메뉴의 인덱스를 증가시킵니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function down_select_menu_index() {
     select_menu_index=`expr ${select_menu_index} + 1`

     if [[ ${select_menu_index} > ${select_menu_max_index} ]]; then
          select_menu_index=select_menu_min_index
     fi
}


#######################################
# 터미널에 실행 여부를 표시합니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function draw_ok() {

    if [ ${is_select_ok} == 1 ]; then
        if [ ${select_ok_index} == ${select_ok_min_index} ]; then
            set_text_color "background" "red"
        else 
            set_text_color "background" "black"
        fi

        move_cursor ${select_ok_line} ${select_ok_col}
        echo "${select_ok_list[0]}"


        if [ ${select_ok_index} == ${select_ok_max_index} ]; then
            set_text_color "background" "red"
        else 
            set_text_color "background" "black"
        fi
        move_cursor ${select_ok_line} `expr ${select_ok_col} + 15`
        echo "${select_ok_list[1]}"
    else
        set_text_color "background" "black"

        move_cursor ${select_ok_line} ${select_ok_col}
        echo "            "

        move_cursor ${select_ok_line} `expr ${select_ok_col} + 15`
        echo "            "
    fi
}


#######################################
# 실행 여부 인덱스를 감소시킵니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function left_select_ok_index() {
    select_ok_index=`expr ${select_ok_index} - 1`

    if [[ ${select_ok_index} < ${select_ok_min_index} ]]; then
        select_ok_index=select_ok_max_index
    fi
}


#######################################
# 실행 여부 인덱스를 증가시킵니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function right_select_ok_index() {
    select_ok_index=`expr ${select_ok_index} + 1`

    if [[ ${select_ok_index} > ${select_ok_max_index} ]]; then
        select_ok_index=select_ok_min_index
    fi
}


#######################################
# 스크립트 루프의 상태를 업데이트합니다.
# Globals:
#   None
# Arguments:
#   $1 키 값입니다.
# Outputs:
#   None
#######################################
function update_loop_state() {
    detect_input_key=$1

    if [ "${detect_input_key}" == "up" ]; then
        is_select_ok=0
        up_select_menu_index
    fi

    if [ "${detect_input_key}" == "down" ]; then
        is_select_ok=0
        down_select_menu_index
    fi

    if [ "${detect_input_key}" == "enter" ]; then

        if [ ${is_select_ok} == 0 ]; then
            is_select_ok=1
        else # ${is_select_ok} == 1
            if [ ${select_ok_index} == 0 ]; then
            is_break_loop="yes"
            else
            is_select_ok=0
            fi
        fi
    fi

    if [ "${detect_input_key}" == "left" ]; then
        if [ ${is_select_ok} == 1 ]; then
        left_select_ok_index
        fi
    fi

    if [ "${detect_input_key}" == "right" ]; then
        if [ ${is_select_ok} == 1 ]; then
        right_select_ok_index
        fi
    fi
}

#######################################
# 사용자가 선택한 옵션을 실행합니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function run_select_option() {
    case ${select_menu_index} in
    0) source source/ls_helper.sh ;;
    1) source source/rm_helper.sh ;;
    2) source source/user_management_helper.sh ;;
    *) echo -n "" ;;
    esac
}


#######################################
# linux_command_helper를 실행합니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function linux_command_helper() {
    visible_cursor "off"
    set_text_color "string" "white"
    set_text_color "background" "black"

    clear_terminal
    draw_main_title
    draw_select_menu
    draw_ok

    while true;
    do
        if [ "${is_break_loop}" == "yes" ]; then
        break
        fi

        detect_input_key=$(input_enter_and_arrow_key)

        if [[ "${detect_input_key}" != "" ]]; then
            update_loop_state "${detect_input_key}"
        fi

        draw_select_menu
        draw_ok
    done

    clear_terminal
    visible_cursor "on"
    set_text_color "string" "white"
    set_text_color "background" "black"

    run_select_option
}

# linux_command_helper를 실행합니다.
linux_command_helper
