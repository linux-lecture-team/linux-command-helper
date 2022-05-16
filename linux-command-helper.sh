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

    title=`cat resource/title.txt`
    echo "${title}"
}

# 스크립트를 실행합니다.
linux_command_helper