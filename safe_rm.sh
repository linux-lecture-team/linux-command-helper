#！/bin/bash

# function clear_terminal() {
#      echo -en `clear`
# }

# function move_cursor() {
#      line=$1
#      col=$2
#      tput cup ${line} ${col}
# }

# function hide_cursor() {
#      tput civis
# }

# function show_cursor() {
#      tput cnorm
# }

# function set_terminal_text_color() {
#      color_type=$1

#      case ${color_type} in
#      $"black")
#      tput setaf 0
#      ;;
#      $"red")
#      tput setaf 1
#      ;;
#      $"green")
#      tput setaf 2
#      ;;
#      $"yellow")
#      tput setaf 3
#      ;;
#      $"blue")
#      tput setaf 4
#      ;;
#      $"magenta")
#      tput setaf 5
#      ;;
#      $"cyan")
#      tput setaf 6
#      ;;
#      $"white")
#      tput setaf 7
#      ;;
#      *)
#      echo "not support color type"
#      ;;
#      esac
# }

# function set_terminal_text_background_color() {
#      color_type=$1

#      case ${color_type} in
#      $"black")
#      tput setab 0
#      ;;
#      $"red")
#      tput setab 1
#      ;;
#      $"green")
#      tput setab 2
#      ;;
#      $"yellow")
#      tput setab 3
#      ;;
#      $"blue")
#      tput setab 4
#      ;;
#      $"magenta")
#      tput setab 5
#      ;;
#      $"cyan")
#      tput setab 6
#      ;;
#      $"white")
#      tput setab 7
#      ;;
#      *)
#      echo "not support color type"
#      ;;
#      esac
# }

# function check_remove_target() {
     
#      question_for_user="삭제할 대상을 입력해주세요."

#      remove_file_message="파일 삭제"
#      remove_folder_message="폴더 삭제"
# }

# function safe_remove_file() {
#      echo "nothing safe_remove_file"
# }

# function safe_remove_folder() {
#      echo "nothing safe_remove_folder"
# }

# function run_safe_rm() {
#      clear_terminal

#      set_terminal_text_background_color "magenta"
#      set_terminal_text_color "black"

#      check_remove_target
#      remove_target=$?

#      if [ "${remove_target}" == "file" ]; then
#           safe_remove_file
#      elif [ "${remove_target}" == "folder" ]; then
#           safe_remove_folder
#      else
#           echo "not support remove target..."
#      fi
# }

# run_safe_rm

fileName=$1
now=`date +%Y%y%d`
save_path="data/${now}"
read  -p "Are you sure you want to delete this file or directory $1 ? yes|no :" input
if [ $input == "yes" ] || [ $input == "y" ]; then

     # Define DIR and mkdir DIR
     
     if [ ! -d ${save_path} ]; then
        mkdir -p "${save_path}"
     fi
    
     # Rsync Synchronizes files and directories to be deleted
    
     rsync -aR $1/ "${save_path}/$1"
     rm -rf $1
    
elif [ $input == "no" ] || [ $input == "n" ]; then

     # Exit with No
     
     exit 0
else

     # Prompt if you select another input character
     
     echo "Can only enter yes or no"
     exit 0
fi