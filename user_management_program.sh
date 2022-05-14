#!/bin/bash

##################################################
#
#   커서 이동 메커니즘
#
# 동작 순서
#1,이동 전 커서 위치 저장
#2,이동 후 커서 위치 계산 후 저장
#3, 1,2과정에서 얻은 위치 정보를 move_cursor에 전달
#
##################################################

##################################################
#
#   기본 설정 스크립트
#
##################################################

#실행전 텍스트 파일 생성 스크립트 실행
. user_check_renew.sh

#실행전 화면정리
clear

#터미널 커서 감추기
tput civis

#터미널 커서 기본 위치 지정
tput cup 0 0
tput sc

##################################################
#
#   커서 이동에 필요한 가장 기본적인 스크립트
#
##################################################

#방향키 입출력에 필요한 전역변수
ESC=`printf "\033"`;

#키보드 입력(방향키,엔터)를 입력받는
function input_key {
    read -s -n3 INPUT
    echo $INPUT
}

#커서 기호 입력
function put_cursor {
    echo -n ">"
}

#커서 기호 삭제
function del_cursor {
    echo -n " "
}

#커서 이동 ( $1: $pre_col $2: $pre_row $3: $col $4: $row )
function move_cursor {
    tput cup $1 $2
    del_cursor
    tput cup $3 $4
    put_cursor
    tput rc
}

###################################################################################
#
#   모든 메뉴 스크립트 공통사항
#
# 1,커서 위치 정보는 각각의 메뉴 스크립트가 따로 관리한다.
#메인 메뉴에서 관리 메뉴로 넘어갈때 넘어가기 직전의 커서 위치 정보를 저장한다.
#관리 메뉴가 끝나면 저장했던 위치 정보를 불러와서 메인 메뉴의 커서를 배치한다.
#
# 2,커서의 위치 정보는 이동 전 위치와 이동 후 위치를 두가지 상태 모두 기록한다.
#이 정보는 각 스크립트에 지역 변수로 저장해 둔다.
#
# 3,반드시 초기 커서 셋팅을 설정한다.
#스크립트의 가장 첫부분에 추가한다.
#
###################################################################################

###################################################################################
#
#   관리메뉴 실행
#
# 동작
#메인메뉴와 동일하게 커서이동
#
###################################################################################

#유저 관리 메뉴 함수( $1: 시작 행 )
function user_menu_control {
    #메뉴 텍스트 출력
    tput cup $1 0
    cat user_menu.txt
    #커서 범위(행은 범위 내에서 움직이고 열은 두 위치만 가능함)
    local Info_col_len=4
    local col_range_start=`expr $1 + $Info_col_len + 3 `
    local col_range_end=`expr $col_range_start + 1 `
    local row_pos1=1
    local row_pos2=28
    #이전 커서 위치(열,행)
    local pre_row=1
    local pre_col=$col_range_start
    #현재 커서 위치(열,행)
    local row=1
    local col=$col_range_start
    #초기 커서 셋팅
    tput cup $col 1
    put_cursor
    tput cup $col_range 1
    tput civis

    ######################################
    #
    #유저 관리 메뉴 커서 이동 함수
    #
    ######################################

    function user_move_up {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #커서의 현재위치가 1행인 경우 메뉴의 마지막 행으로 감
        if [ $col -eq $col_range_start ]; then
            col=$col_range_end
        #커서의 현재위치가 유저 목록의 1행이 아닌 경우에만 위로 한칸 이동
        elif [ $col -ne $col_range_start ]; then
            col=$((col-1))
        fi
        move_cursor $pre_col $pre_row $col $row
    }

    function user_move_down {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #커서의 현재위치가 유저 목록의 마지막 행인 경우 메뉴의 시작 행으로감
        if [ $col -eq $col_range_end ]; then
            col=$col_range_start
        #커서의 현재위치가 유저 목록의 마지막 행이 아닌 경우에만 아래로 한칸 이동
        elif [ $col -ne $col_range_end ]; then
            col=$((col+1))
        fi
        move_cursor $pre_col $pre_row $col $row
    }

    function user_move_right {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #오른쪽 이동은 오른쪽 탭으로 이동
        row=$row_pos2
        move_cursor $pre_col $pre_row $col $row
    }

    function user_move_left {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #왼쪽 이동은 왼쪽 탭으로 이동
        row=$row_pos1
        move_cursor $pre_col $pre_row $col $row
    }

    function user_move_enter {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        echo `expr $col_option + 2`
        #왼쪽 탭에 커서가 있는 경우
        if [ $row -eq $row_pos1 ]; then
            echo enter
        #오른쪽 탭에 커서가 있는 경우
        elif [ $row -eq $row_pos2 ]; then
            echo enter
        fi
    }

    ######################################
    #
    #유저 관리 메뉴 동작 코드
    #(실제로 키보드 입력을 받고 커서를 이동시키는 하는 함수)
    #
    ######################################

    while true; do
        INPUT=$(input_key)
        if [[ $INPUT = "" ]]; then
            user_move_enter
        elif [[ $INPUT = $ESC[A ]]; then
            user_move_up
        elif [[ $INPUT = $ESC[B ]]; then
            user_move_down
        elif [[ $INPUT = $ESC[C ]]; then
            user_move_right
        elif [[ $INPUT = $ESC[D ]]; then
            user_move_left
        fi
        #원인은 모르겠지만 커서 동작후 감추기 옵션이 계속 풀림
        #루프를 돌때마다 감추기 옵션 활성화
        tput civis
    done
}

#그룹 관리 메뉴 함수( $1: 시작 행 )
function group_menu_control {
    #메뉴 텍스트 출력
    tput cup $1 0
    cat group_menu.txt
    #커서 범위(행은 범위 내에서 움직이고 열은 두 위치만 가능함)
    local Info_col_len=4
    local col_range_start=`expr $1 + $Info_col_len + 3 `
    local col_range_end=`expr $col_range_start + 1 `
    local row_pos1=1
    local row_pos2=28
    #이전 커서 위치(열,행)
    local pre_row=1
    local pre_col=$col_range_start
    #현재 커서 위치(열,행)
    local row=1
    local col=$col_range_start
    #초기 커서 셋팅
    tput cup $col 1
    put_cursor
    tput cup $col_range 1
    tput civis

    ######################################
    #
    #그룹 관리 메뉴 커서 이동 함수
    #
    ######################################

    function group_move_up {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #커서의 현재위치가 1행인 경우 메뉴의 마지막 행으로 감
        if [ $col -eq $col_range_start ]; then
            col=$col_range_end
        #커서의 현재위치가 유저 목록의 1행이 아닌 경우에만 위로 한칸 이동
        elif [ $col -ne $col_range_start ]; then
            col=$((col-1))
        fi
        move_cursor $pre_col $pre_row $col $row
    }

    function group_move_down {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #커서의 현재위치가 유저 목록의 마지막 행인 경우 메뉴의 시작 행으로감
        if [ $col -eq $col_range_end ]; then
            col=$col_range_start
        #커서의 현재위치가 유저 목록의 마지막 행이 아닌 경우에만 아래로 한칸 이동
        elif [ $col -ne $col_range_end ]; then
            col=$((col+1))
        fi
        move_cursor $pre_col $pre_row $col $row
    }

    function group_move_right {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #오른쪽 이동은 오른쪽 탭으로 이동
        row=$row_pos2
        move_cursor $pre_col $pre_row $col $row
    }

    function group_move_left {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #왼쪽 이동은 왼쪽 탭으로 이동
        row=$row_pos1
        move_cursor $pre_col $pre_row $col $row
    }

    function group_move_enter {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        echo `expr $col_option + 2`
        #왼쪽 탭에 커서가 있는 경우
        if [ $row -eq $row_pos1 ]; then
            echo enter
        #오른쪽 탭에 커서가 있는 경우
        elif [ $row -eq $row_pos2 ]; then
            echo enter
        fi
    }

    ######################################
    #
    #그룹 관리 메뉴 동작 코드
    #(실제로 키보드 입력을 받고 커서를 이동시키는 하는 함수)
    #
    ######################################

    while true; do
        INPUT=$(input_key)
        if [[ $INPUT = "" ]]; then
            group_move_enter
        elif [[ $INPUT = $ESC[A ]]; then
            group_move_up
        elif [[ $INPUT = $ESC[B ]]; then
            group_move_down
        elif [[ $INPUT = $ESC[C ]]; then
            group_move_right
        elif [[ $INPUT = $ESC[D ]]; then
            group_move_left
        fi
        #원인은 모르겠지만 커서 동작후 감추기 옵션이 계속 풀림
        #루프를 돌때마다 감추기 옵션 활성화
        tput civis
    done
}

###################################################################################
#
#   메인 메뉴 스크립트
#
# 주의 사항 
#엔터키 입력시 가져가야할 정보: 유저나 그룹이름 -> user_DB.txt 정보 가져가면됨
#엔터키 입력시 미리 저장해야할 정보: 관리메뉴가 가기 직전의 커서위치 정보
#(기존 row,col 정보 써도 될듯)
#
# 동작
#관리메뉴 실행 스크립트가 실행되야함
#관리메뉴 종료가 되면 관리메뉴 실행 직전의 상태의 커서로 돌아와야함
#
###################################################################################

function main_menu_control {
    #메인 메뉴로 돌아올 때는 화면초기화
    clear
    cat main_menu.txt
    #초기 커서 셋팅
    tput cup 1 1
    put_cursor
    tput cup 1 1
    tput civis
    #커서 범위(행은 범위 내에서 움직이고 열은 두 위치만 가능함)
    local col_range_start=1
    local col_range_end=`wc -l user_DB.txt | cut -d ' ' -f1`
    local row_pos1=1
    local row_pos2=28
    #이전 커서 위치(열,행)
    local pre_row=1
    local pre_col=1
    #현재 커서 위치(열,행)
    local row=1
    local col=1
    #메인메뉴 하단 옵션 위치
    local col_option=`expr $col_range_end + 2`

    ######################################
    #
    #메인 메뉴 커서 이동 함수
    #
    ######################################

    function main_move_up {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #커서의 현재위치가 1행인 경우 옵션 행으로 감
        if [ $col -eq $col_range_start ]; then
            col=$col_option
        #커서의 현재위치가 옵션인 경우 유저 목록의 마지막 행으로 감
        elif [ $col -eq $col_option ]; then
            col=$col_range_end
        #커서의 현재위치가 유저 목록의 1행이 아닌 경우에만 위로 한칸 이동
        elif [ $col -ne $col_range_start ]; then
            col=$((col-1))
        fi
        move_cursor $pre_col $pre_row $col $row
    }

    function main_move_down {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #커서의 현재위치가 유저 목록의 마지막 행인 경우 옵션 행으로감
        if [ $col -eq $col_range_end ]; then
            col=$col_option
        #커서의 현재위치가 옵션인 경우 유저 목록의 1행으로 감
        elif [ $col -eq $col_option ]; then
            col=$col_range_start
        #커서의 현재위치가 유저 목록의 마지막 행이 아닌 경우에만 아래로 한칸 이동
        elif [ $col -ne $col_range_end ]; then
            col=$((col+1))
        fi
        move_cursor $pre_col $pre_row $col $row
    }

    function main_move_right {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #오른쪽 이동은 그룹탭으로 이동
        row=$row_pos2
        move_cursor $pre_col $pre_row $col $row
    }

    function main_move_left {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #왼쪽 이동은 유저탭으로 이동
        row=$row_pos1
        move_cursor $pre_col $pre_row $col $row
    }

    function main_move_enter {
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #커서가 옵션 행에 있는 경우
        if [ $col -eq $col_option ]; then
            if [ $row -eq $row_pos1 ]; then
            #유저 추가 부분(구현 예정)
            echo Adduser
            elif [ $row -eq $row_pos2 ]; then
            #그룹 추가 부분(구현 예정)
            echo Addgroup
            fi
        else
            #유저 탭에 커서가 있는 경우
            if [ $row -eq $row_pos1 ]; then
                user_menu_control `expr $col_option + 2`
            #그룹 탭에 커서가 있는 경우
            elif [ $row -eq $row_pos2 ]; then
                group_menu_control `expr $col_option + 2`
            fi
        fi
    }

    ######################################
    #
    #메인 메뉴 동작 코드
    #(실제로 키보드 입력을 받고 커서를 이동시키는 하는 함수)
    #
    ######################################

    while true; do
        INPUT=$(input_key)
        if [[ $INPUT = "" ]]; then
            main_move_enter
        elif [[ $INPUT = $ESC[A ]]; then
            main_move_up
        elif [[ $INPUT = $ESC[B ]]; then
            main_move_down
        elif [[ $INPUT = $ESC[C ]]; then
            main_move_right
        elif [[ $INPUT = $ESC[D ]]; then
            main_move_left
        fi
        #원인은 모르겠지만 커서 동작후 감추기 옵션이 계속 풀림
        #루프를 돌때마다 감추기 옵션 활성화
        tput civis
    done
}

###################################################################################
#
#   관리메뉴 실행
#
# 동작
#메인메뉴와 동일하게 커서이동
#옵션 선택후 커맨드 창으로 넘어감
#
###################################################################################


###################################################################################
#
#   구현에 문제가 되는 부분 정리
#
#
#
#
#
###################################################################################


main_menu_control