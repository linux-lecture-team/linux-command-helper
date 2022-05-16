#！/bin/bash

# fileName=$1
# now=`date +%Y%y%d`
# dir=$(/data/$now)
# read  -p "Are you sure you want to delete this file or directory $1 ? yes|no :" input
# if [ $input == "yes" ] || [ $input == "y" ]; then

#      # Define DIR and mkdir DIR

#      if [ ! -d $dir ]; then
#         mkdir /data/$now
#     fi

#     # Rsync Synchronizes files and directories to be deleted

#      rsync -aR $1/ /data/$now/$1/
#      rm -rf $1

# elif [ $input == "no" ] || [ $input == "n" ]; then

#      # Exit with No

#      exit 0
# else

#      # Prompt if you select another input character

#      echo "Can only enter yes or no"
#      exit 0
# fi

function check_remove_target() {
     echo "nothing check_remove_target"
}

function clear_terminal() {
     echo -en `clear`
}

function safe_remove_file() {
     echo "nothing safe_remove_file"
}

function safe_remove_folder() {
     echo "nothing safe_remove_folder"
}

function run_safe_rm() {
     clear_terminal

     remove_target=$(check_remove_target)

     if [ "${remove_target}" == "file" ]; then
          safe_remove_file
     elif [ "${remove_target}" == "folder" ]; then
          safe_remove_folder
     else
          echo "not support remove target..."
     fi
}

run_safe_rm
