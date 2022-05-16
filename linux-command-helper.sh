#!/bin/bash

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
    title=`cat resource/title.txt`
    echo "${title}"
}

# 스크립트를 실행합니다.
linux_command_helper