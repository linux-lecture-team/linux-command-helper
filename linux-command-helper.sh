#!/bin/bash

#######################################
# 전체 터미널에 표시된 텍스트를 비웁니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function clear_terminal() {
     echo -en `clear`
}


#######################################
# 터미널의 커서를 이동시킵니다.
# Globals:
#   None
# Arguments:
#   $1 커서를 이동시킬 라인입니다.
#   $2 커서를 이동시킨 라인의 열입니다.
# Outputs:
#   None
#######################################
function move_cursor() {
     line=$1
     col=$2
     tput cup ${line} ${col}
}


#######################################
# 터미널의 커서를 숨깁니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function hide_cursor() {
     tput civis
}


#######################################
# 터미널의 커서를 보이도록 설정합니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function show_cursor() {
     tput cnorm
}


#######################################
# 터미널의 텍스트 색상을 변경합니다.
# Globals:
#   None
# Arguments:
#   $1 텍스트 색상입니다. 
# Outputs:
#   None
# References:
#   지원 되는 색상은 다음 7가지 (black, red, green, yellow, blue, magenta, cyan, white) 입니다.
#######################################
function set_terminal_text_color() {
     color_type=$1

     case ${color_type} in
     $"black")
     tput setaf 0
     ;;
     $"red")
     tput setaf 1
     ;;
     $"green")
     tput setaf 2
     ;;
     $"yellow")
     tput setaf 3
     ;;
     $"blue")
     tput setaf 4
     ;;
     $"magenta")
     tput setaf 5
     ;;
     $"cyan")
     tput setaf 6
     ;;
     $"white")
     tput setaf 7
     ;;
     *)
     echo "not support color type"
     ;;
     esac
}


#######################################
# 전체 스크립트를 실행합니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function linux_command_helper() {
    clear_terminal

    move_cursor 10 0
    title=`cat resource/title.txt`
    echo "${title}"
}

# 스크립트를 실행합니다.
linux_command_helper