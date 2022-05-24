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

function linux_command_helper() {
    visible_cursor "off"
    set_text_color "string" "yellow"
    echo "Hello World!"
    visible_cursor "on"
}

linux_command_helper