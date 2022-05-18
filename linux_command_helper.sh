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
     echo "not support color type in set_terminal_text_color"
     ;;
     esac
}


#######################################
# 터미널의 텍스트 백그라운드 색상을 변경합니다.
# Globals:
#   None
# Arguments:
#   $1 텍스트 색상입니다. 
# Outputs:
#   None
# References:
#   지원 되는 색상은 다음 7가지 (black, red, green, yellow, blue, magenta, cyan, white) 입니다.
#######################################
function set_terminal_text_background_color() {
     color_type=$1

     case ${color_type} in
     $"black")
     tput setab 0
     ;;
     $"red")
     tput setab 1
     ;;
     $"green")
     tput setab 2
     ;;
     $"yellow")
     tput setab 3
     ;;
     $"blue")
     tput setab 4
     ;;
     $"magenta")
     tput setab 5
     ;;
     $"cyan")
     tput setab 6
     ;;
     $"white")
     tput setab 7
     ;;
     *)
     echo "not support color type in set_terminal_text_background_color"
     ;;
     esac
}


#######################################
# 키 입력을 처리합니다.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   입력 받은 키 값을 반환합니다.
#######################################
function input_key() {
     read -s -n3 key
     echo ${key}
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
     hide_cursor

     ESC=`printf "\033"`;

     while true;
     do
          INPUT=$(input_key);

          if [[ $INPUT = "" ]];
          then break;
          fi

          if [[ $INPUT = $ESC[A ]]; then 
          move_cursor 5 1
          set_terminal_text_background_color "red"
          echo "1. aaa"
          elif [[ $INPUT = $ESC[B ]]; then
          move_cursor 6 1
          set_terminal_text_background_color "red"
          echo "2. bbb"
          fi

     done

     set_terminal_text_background_color "black"
}

# 스크립트를 실행합니다.
linux_command_helper