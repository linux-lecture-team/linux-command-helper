#!/bin/bash

rm_helper_main_title=`cat resource/rm_helper_main_title.txt`

echo "${rm_helper_main_title}"

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