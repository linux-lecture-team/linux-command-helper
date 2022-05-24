#!/bin/bash

ls_helper_main_title=`cat resource/ls_helper_title.txt`


#커서 기호 입력
function put_cursor {
    echo -n " >"
}

#커서 기호 삭제
function del_cursor {
    echo -n "  "
}

#커서 이동 ( $1: $pre_col $2: $pre_row $3: $col $4: $row )
function move_arrow_cursor {
    tput cup $1 $2
    del_cursor
    tput cup $3 $4
    put_cursor
    tput rc
}

#메뉴 출력 함수
function print_ls_menu {
    echo "${ls_helper_main_title}"
}

#명령어 출력결과가 출력되는 부분을 치우는 함수(다 정리되지 않는 다면 반복 횟수를 늘리면 됩니다.)
function clear_output {
    for(( i=0;i<15;i++)); do
        echo "                                                                                                                                                          "
    done
}

#커서 이동 함수
function ls_helper {
    

    #ls메뉴 텍스트 출력
    print_ls_menu
    #커서 범위(행은 범위 내에서 움직이고 열은 두 위치만 가능함)
    local opt_num=6 #옵션 갯수
    local col_range_start=6
    local col_range_end=16
    #이전 커서 위치(열,행)
    local pre_row=1
    local pre_col=$col_range_start
    #현재 커서 위치(열,행)
    local row=1
    local col=$col_range_start
    #초기 커서 셋팅
    tput cup $col 1
    put_cursor
    tput cup $col 1
    tput civis

    ######################################
    #
    # 관리 메뉴 커서 이동 함수
    #
    ######################################

    function ls_move_up {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #커서의 현재위치가 1행인 경우 메뉴의 마지막 행으로 감
        if [ $col -eq $col_range_start ]; then
            col=$col_range_end
        #커서의 현재위치가 유저 목록의 1행이 아닌 경우에만 위로 두칸 이동
        elif [ $col -ne $col_range_start ]; then
            col=$((col-2))
        fi
        move_arrow_cursor $pre_col $pre_row $col $row
    }

    function ls_move_down {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #커서의 현재위치가 메뉴의 마지막 행인 경우 메뉴의 시작 행으로감
        if [ $col -eq $col_range_end ]; then
            col=$col_range_start
        #커서의 현재위치가 메뉴의 마지막 행이 아닌 경우에만 아래로 두칸 이동
        elif [ $col -ne $col_range_end ]; then
            col=$((col+2))
        fi
        move_arrow_cursor $pre_col $pre_row $col $row
    }

    #($1 2: 상위 스크립트 1 2번 인자)
    function ls_move_enter {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #출력창 정리
        tput cup 20 1
        clear_output
        tput cup 20 1
        if [ $col = 6 ]; then
            ls -a
        elif [ $col = 8 ]; then
            ls -l
        elif [ $col = 10 ]; then
            ls -F
        elif [ $col = 12 ]; then
            ls -r
        elif [ $col = 14 ]; then
            ls -t
        elif [ $col = 16 ]; then
            ls -S
        fi
    }

    ######################################
    #
    #ls 관리 메뉴 동작 코드
    #(실제로 키보드 입력을 받고 커서를 이동시키는 하는 함수)
    #
    ######################################

    while true;
    do
        detect_input_key=$(input_enter_and_arrow_key)

        if [ "${detect_input_key}" == "up" ]; then
            ls_move_up
        elif [ "${detect_input_key}" == "down" ]; then
            ls_move_down
        elif [ "${detect_input_key}" == "enter" ]; then
            ls_move_enter
        fi

        visible_cursor "off"

        # INPUT=$(input_key)
        # if [[ $INPUT = "" ]]; then
        #     ls_move_enter
        # elif [[ $INPUT = $ESC[A ]]; then
        #     ls_move_up
        # elif [[ $INPUT = $ESC[B ]]; then
        #     ls_move_down
        # fi
    
        # tput civis
    done
}

ls_helper