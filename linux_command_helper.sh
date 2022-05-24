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
# 프로젝트 공통 기능 끝
##############################################################


linux_command_helper_main_title=`cat resource/main_title.txt`

function linux_command_helper() {
    visible_cursor "off"
    set_text_color "string" "yellow"
    echo "${linux_command_helper_main_title}"

    while true;
    do
        detect_input_key=$(input_enter_and_arrow_key)

        if [[ "${detect_input_key}" != "" ]]; then
            if [ "${detect_input_key}" == "up" ]; then
                echo "insert up"
            fi

            if [ "${detect_input_key}" == "down" ]; then
                echo "insert down"
            fi

            if [ "${detect_input_key}" == "left" ]; then
                echo "insert left"
            fi

            if [ "${detect_input_key}" == "right" ]; then
                echo "insert right"
            fi           

            if [ "${detect_input_key}" == "enter" ]; then
                echo "inter enter"
            fi
        fi
    done

    visible_cursor "on"
}

linux_command_helper