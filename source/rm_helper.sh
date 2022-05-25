#!/bin/bash

# rm_helper의 메인 타이틀입니다.
rm_helper_main_title=`cat resource/rm_helper_main_title.txt`

# 삭제할 파일 혹은 디렉토리입니다.
remove_file_or_directory=""

# 삭제할 파일 혹은 디렉토리 입력 받는 부분의 라인입니다.
declare -i remove_file_or_directory_line=10

# 삭제할 파일 혹은 디렉토리 입력 받는 부분의 열입니다.
declare -i remove_file_or_directory_col=2

# 삭제할 파일 혹은 디렉토리의 백업 경로입니다.
remove_backup_path=""

# 백업 경로 입력 받는 부분의 라인입니다.
declare -i remove_backup_path_line=`expr ${remove_file_or_directory_line} + 2`

# 백업 경로 입력 받는 부분의 열입니다.
declare -i remove_backup_path_col=remove_file_or_directory_col

function draw_rm_helper_main_title() {
     move_cursor 0 0
     echo "${rm_helper_main_title}"
}

function input_remove_file_or_directory() {
     move_cursor ${remove_file_or_directory_line} ${remove_file_or_directory_col}
     echo "Input Remove File or Directory"
     move_cursor `expr ${remove_file_or_directory_line} + 1` ${remove_file_or_directory_col}
     echo -n "> "
     read remove_file_or_directory
}

function input_backup_directory() {
     move_cursor ${remove_backup_path_line} ${remove_backup_path_col}
     echo "Input Backup Path"
     move_cursor `expr ${remove_backup_path_line} + 1` ${remove_backup_path_col}
     echo -n "> "
     read remove_backup_path
}

function rm_helper() {
     visible_cursor "off"

     draw_rm_helper_main_title
     visible_cursor "on"

     input_remove_file_or_directory
     input_backup_directory
}

rm_helper

# function rm_helper() {
#      now=$(date +%Y%m%d)

#      #Judge file capitalization
#      f_size=$(du -sk $dir | awk '{print $1}')

#      #Determining the disk size
#      disk_szie=$(df -k| grep -vi filesystem | awk '{print $4}'|sort -n|tail -n1)

#      #Where is the largest directory
#      big_filesystem=$(df -k|grep -vi filesystem | sort -n -k4 | tail -n1 | awk '{print $NF}')

#      #Determine the file size and disk size comparison
#      if [ $f_size -lt $disk_szie ]; then
          
#           # Enter the options to begin the deletion
#           read  -p "Are you sure you want to delete this file or directory $1 ? yes|no :" input

#      if [ $input == "yes" ] || [ $input == "y" ]; then
#           # Check whether the directory exists
#           if [ ! -d $big_filesystem/data/$now ]; then
#                # No new directory exists
#                mkdir -p $big_filesystem/data/$now
                    
#           fi
#           rsync -aR $1 $big_filesystem/$now/
#           rm -rf $1
               
#      #Check whether no is entered
#      elif [ $input == "no" ] || [ $input == "n"]; then
#           exit 0
#      else
#           # Prompt if you select another input character
#           echo "You can enter only yes or no"  
#      fi
     
#      else
#           # Check whether the disk space is insufficient
#           echo "There is not enough space for backup on this disk: $1."
#           read -p "You want to delete it"$1"？ yes|no ：" input
#           if [ $input == "yes" ] || [ $input == "n" ]; then
#                # body
#                echo "$1Will be deleted in 3 seconds, there will be no backup"
#                for i in `seq 1 5`; do echo -ne "."; sleep 1; done
#                rm -rf $1

#           elif [ $input == "no" ] || [ $input == "n" ]; then
#                echo "The album will never remove $1."
#                exit 0
#           else
#                # Prompt if you select another input character
#                echo "You can enter only yes or no"  
#           fi
          
#      fi
#      #Check whether the file exists
#      if [ -d "/data/" ];then

#      echo "Source folder ID not exists"

#      else

#      echo "The folder does not exist now"

#      fi
# }