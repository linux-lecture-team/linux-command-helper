#!/bin/bash

##############################################################
# 공통 기능 시작
##############################################################
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


##############################################################
# linux command helper 내부 리소스 시작
##############################################################
linux_command_helper_main_title=`cat resource/main_title.txt`


##############################################################
# select menu 기능 시작
##############################################################
declare -a select_menu_list=(
    "[01] linux command helper"
    "[02] ls helper"
    "[03] rm helper"
    "[04] user management helper"
    "[05] go to github repository"
    "[06] exit linux command helper"
)

declare -i select_menu_index=0
declare -i select_menu_min_index=0
declare -i select_menu_max_index=5
declare -i select_menu_list_size=6
declare -i select_menu_line=14
declare -i select_menu_col=2

function draw_main_title() {
    move_cursor 0 0
    echo "${linux_command_helper_main_title}"
}

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

function up_select_menu_index() {
     select_menu_index=`expr ${select_menu_index} - 1`

     if [[ ${select_menu_index} < ${select_menu_min_index} ]]; then
          select_menu_index=select_menu_max_index
     fi
}

function down_select_menu_index() {
     select_menu_index=`expr ${select_menu_index} + 1`

     if [[ ${select_menu_index} > ${select_menu_max_index} ]]; then
          select_menu_index=select_menu_min_index
     fi
}


##############################################################
# ok 기능 시작
##############################################################
declare -a select_ok_list=(
    "[    OK    ]"
    "[  CANCEL  ]"
)

declare -i select_ok_index=0
declare -i select_ok_min_index=0
declare -i select_ok_max_index=1
declare -i select_ok_list_size=2
declare -i select_ok_line=18
declare -i select_ok_col=40
declare -i is_select_ok=0

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

function left_select_ok_index() {
    select_ok_index=`expr ${select_ok_index} - 1`

    if [[ ${select_ok_index} < ${select_ok_min_index} ]]; then
        select_ok_index=select_ok_max_index
    fi
}

function right_select_ok_index() {
    select_ok_index=`expr ${select_ok_index} + 1`

    if [[ ${select_ok_index} > ${select_ok_max_index} ]]; then
        select_ok_index=select_ok_min_index
    fi
}


##############################################################
# 메뉴얼 출력 기능
##############################################################
linux_command_helper_manual=`cat resource/linux_command_helper.txt`
ls_helper_manual=`cat resource/ls_helper.txt`
rm_helper_manual=`cat resource/rm_helper.txt`
user_management_helper_manual=`cat resource/user_management_helper.txt`
go_to_github_repository_manual=`cat resource/go_to_github_repository.txt`
exit_linux_command_helper_manual=`cat resource/exit_linux_command_helper.txt`

declare -a manual_list=(
    "${linux_command_helper_manual}"
    "${ls_helper_manual}"
    "$rm_helper_manual"
    "${user_management_helper_manual}"
    "${go_to_github_repository_manual}"
    "${exit_linux_command_helper_manual}"
)

declare -i manual_list_size=6
declare -i manual_line=25
declare -i manual_col=0

function draw_manual() {
    move_cursor ${manual_line} ${manual_col}

    set_text_color "string" "white"
    set_text_color "background" "black"

    for((index=0;index<${manual_list_size};index++))
     do
        if [ ${index} == ${select_menu_index} ]; then
            echo "${manual_list[index]}"
        fi
    done

    set_text_color "background" "black"
}



##############################################################
# 전체 루프 상태 업데이트
##############################################################
is_break_loop="no"

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


##############################################################
# 전체 스크립트 실행 부분 시작
##############################################################
function linux_command_helper() {
    visible_cursor "off"
    set_text_color "string" "white"

    clear_terminal
    draw_main_title
    draw_select_menu
    draw_ok
    draw_manual

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
        draw_manual
    done

    clear_terminal
    visible_cursor "on"
    set_text_color "string" "white"
    set_text_color "background" "black"
}

linux_command_helper