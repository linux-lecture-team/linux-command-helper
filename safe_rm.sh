#！/bin/bash

function clear_terminal() {
     echo -en `clear`
}

function move_cursor() {
     line=$1
     col=$2
     tput cup ${line} ${col}
}

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

function check_remove_target() {
     
     question_for_user="삭제할 대상을 입력해주세요."

     remove_file_message="파일 삭제"
     remove_folder_message="폴더 삭제"
}

function safe_remove_file() {
     echo "nothing safe_remove_file"
}

function safe_remove_folder() {
     echo "nothing safe_remove_folder"
}

function run_safe_rm() {
     clear_terminal

     set_terminal_text_color "green"

     check_remove_target
     remove_target=$?

     if [ "${remove_target}" == "file" ]; then
          safe_remove_file
     elif [ "${remove_target}" == "folder" ]; then
          safe_remove_folder
     else
          echo "not support remove target..."
     fi
}

run_safe_rm
