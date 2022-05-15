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
function run() {
    title=`cat resource/title.txt`
    echo "${title}"
}

# 스크립트를 실행합니다.
run