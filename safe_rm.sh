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


function safe_rm {
     remove_file_name=$1

     if [ "${remove_file_name}" == "" ]; then
          echo "please input "
     fi

}

safe_rm $1
