#!/bin/bash

######################################################################################################################################

########################################################
#
# 스크립트 구현에 필요한 각종 보조 스크립트
#
########################################################

#######################################
# 텍스트 파일이 존재하지 않으면 생성시키는 스크립트
# Globals:
#   None
# Arguments:
#   $1 텍스트 파일명
# Outputs:
#   None
#######################################

function check_and_creat_txt {
    [ -s ~/$1 ] || touch $1
}

#######################################
# 텍스트 파일의 내용을 전부 지우는 스크립트
# Globals:
#   None
# Arguments:
#   $1 텍스트 파일명
# Outputs:
#   None
#######################################

function clear_txt {
    cat /dev/null > $1
}

#######################################
# 터머널의 텍스트를 초기화하는 스크립트
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################

function clear_terminal {
    echo -n `clear`
}

#######################################
# 터머널 커서의 보이기/숨기기 설정을 수행합니다.
# Globals:
#   None
# Arguments:
#   $1 보이기/숨기기를 설정할 옵션입니다.
# Outputs:
#   None
#######################################
function visible_cursor {
    option=$1

    if [ ${option} == "on" ]; then
        tput cnorm
    elif [ ${option} == "off" ]; then
        tput civis
    fi
}

#######################################
# 터미널의 커서를 옮기는 스크립트
# Globals:
#   None
# Arguments:
#   $1 cur_row
#   $2 cur_col
# Outputs:
#   None
#######################################

function move_cursor {
    tput cup $1 $2
}

######################################################################################################################################

########################################################
#
# 유저 및 그룹 관리하는 함수를 구현한 스크립트
#
########################################################

#######################################
# 사용자 관련 정보 조회 관련 스크립트
# Globals:
#   None
# Arguments:
#   $1 사용자 이름
# Outputs:
#   각 함수의 이름 참조
#######################################

function get_user_comment {
    echo `grep -a /bin/bash /etc/passwd | grep -w $1  | cut -d ":"  -f 5`
}

#기본 그룹 조회 (사용 인자: $1=사용자 이름) - 완성
function get_user_primary_group {
    echo `groups $1 | cut -d":" -f 2 | cut -d" " -f 2`
}

#사용 쉘 조회 (사용 인자: $1=사용자 이름 ,반환: 쉘 이름) - 완성
function get_user_shell {
    echo `grep -a /bin/bash /etc/passwd | grep -w $1  | cut -d ":"  -f 7`
}

#######################################
# 사용자 추가 또는 삭제 관련 스크립트
# Globals:
#   None
# Arguments:
#   $1 사용자 이름
# Outputs:
#   None
#######################################

function add_user {
    useradd -N -d /home/"$1" -s /bin/bash "$1"
    #기본 그룹(user:100) 설정
    usermod -G 100 $1
}

function del_user {
    userdel -r $1
}

#######################################
# 사용자 정보 변경 관련 스크립트
# Globals:
#   None
# Arguments:
#   $1 사용자 이름
#   $2 변경할 정보의 내용(코멘트, 그룹이름)
# Outputs:
#   None
#######################################

function edit_user_comment {
    usermod -c $2 $1
}

function edit_user_primary_group {
    usermod -g $2 $1
}

#######################################
# 그룹 추가 또는 삭제 관련 스크립트
# Globals:
#   None
# Arguments:
#   $1 그룹 이름
# Outputs:
#   None
#######################################

function add_group {
    groupadd $1
}

function del_group {
    groupdel $1
}

#######################################
# 그룹 정보 변경 관련 스크립트
# Globals:
#   None
# Arguments:
#   $1 그룹 이름
#   $2 (추가 또는 제거할)사용자 목록
# Outputs:
#   None
#######################################

function add_group_member {
    for param in "$@"
    do
        if [ $param = $1 ]
        then
            continue
        fi
        usermod -G $1 -a $param
    done
}

function del_group_member {
    for param in "$@"
    do
        if [ $param = $1 ]
        then
            continue
        fi
        gpasswd -d $param $1
    done
}

######################################################################################################################################

########################################################
#
#   스크립트 실행에 필요한 텍스트 파일을 만드는 스크립트
#
#   제작하는 텍스트 파일 목록
# user_DB.txt: 유저-그룹 목록을 저장한 파일
# main_menu.txt: 메인 메뉴 텍스트를 저장한 파일
# user_menu.txt: 유저 관리 메뉴 텍스트를 저장한 파일
# group_menu.txt: 그룹 관리 메뉴 텍스트를 저장한 파일
# 
########################################################

#######################################
# /etc/passwd에서 필요한 정보만 추출하는 스크립트
# Globals:
#   _User_list 사용자 리스트
#   _UID_list 사용자의 UID 리스트
#   _GID_list 그룹의 GID 리스트
#   _Group_list 그룹 리스트
# Arguments:
#   None
# Outputs:
#   None
#######################################

function creat_user_var {
    # 유저 목록 변수 생성
    _User_list=`grep -a /bin/bash /etc/passwd | cut -d ":"  -f 1`

    # UID 목록 변수 생성
    _UID_list=`grep -a /bin/bash /etc/passwd | cut -d ":"  -f 3`

    #GID 목록을 변수 생성
    _GID_list=`grep -a /bin/bash /etc/passwd | cut -d ":"  -f 4`

    # 그룹 목록 변수 생성
    touch group.txt
    for(( i=1 ; i <= `echo "$_GID_list" | wc -l | cut -d ' ' -f1` ; i++)); do
        GID_tem=`echo "$_GID_list" | head -n $i | tail -1`
        #GID에 해당하는 그룹명을 가져오는 스크립트
        echo `getent group $GID_tem | cut -d: -f1` >> group.txt
    done
    _Group_list=`cat group.txt`
    rm group.txt
}

#######################################
#  creat_user_var에서 만든 리스트를 기반으로 user_DB.txt를 생성하는 스크립트
# Globals:
#   _User_list 사용자 리스트
#   _UID_list 사용자의 UID 리스트
#   _GID_list 그룹의 GID 리스트
#   _Group_list 그룹 리스트
# Arguments:
#   None
# Outputs:
#   user_DB.txt를 생성
#######################################

function create_user_DB {
    check_and_creat_txt user_DB.txt
    clear_txt user_DB.txt

    for(( i=1 ; i <= `echo "$_User_list" | wc -l | cut -d ' ' -f1` ; i++)); do
        local unit=""
        unit+=`echo "$_User_list" | head -n $i | tail -1`
        unit+=':'
        unit+=`echo "$_UID_list" | head -n $i | tail -1`
        unit+=':'
        unit+=`echo "$_Group_list" | head -n $i | tail -1`
        unit+=':'
        unit+=`echo "$_GID_list" | head -n $i | tail -1`
        echo $unit | cat >> user_DB.txt
    done
}

#######################################
#  user_DB.txt를 기반으로 메인 메뉴 텍스트 파일 생성하는 스크립트
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   main_menu.txt를 생성
#######################################

function create_main_menu {
    check_and_creat_txt main_menu.txt
    clear_txt main_menu.txt

    echo "┌──User───────────┬──UID───┬──Group──────────┬──GID───┐" >> main_menu.txt
    for(( n=1 ; n <= `wc -l user_DB.txt | cut -d ' ' -f1` ; n++ )); do
        local col_user
        local col_uid
        local col_group
        local col_gid

        echo -n "│ " >> main_menu.txt
        col_user=`head -n $n user_DB.txt | tail -1 | cut -d ":"  -f 1 `
        #탭의 길이 안에서만 출력, 넘어가는 부분은 출력하지 않음
        echo -n ${col_user:0:16} >> main_menu.txt
        #탭의 길이에서 문자열이 차지하는 길이를 뺀 나머지 부분을 공백으로 채움
        for (( i=0 ; i < `expr 16 - ${#col_user}` ; i++ )); do
            echo -n " " >> main_menu.txt
        done

        echo -n "│ " >> main_menu.txt
        col_uid=`head -n $n user_DB.txt | tail -1 | cut -d ":"  -f 2 `
        echo -n ${col_uid:0:7} >> main_menu.txt
        for (( i=0 ; i < `expr 7 - ${#col_uid}` ; i++ )); do
            echo -n " " >> main_menu.txt
        done

        echo -n "│ " >> main_menu.txt
        col_group=`head -n $n user_DB.txt | tail -1 | cut -d ":"  -f 3 `
        echo -n ${col_group:0:16} >> main_menu.txt
        for (( i=0 ; i < `expr 16 - ${#col_group}` ; i++ )); do
            echo -n " " >> main_menu.txt
        done

        echo -n "│ " >> main_menu.txt
        col_gid=`head -n $n user_DB.txt | tail -1 | cut -d ":"  -f 4 `
        echo -n ${col_gid:0:7} >> main_menu.txt
        for (( i=0 ; i < `expr 7 - ${#col_gid}` ; i++ )); do
            echo -n " " >> main_menu.txt
        done

        echo "│" >> main_menu.txt
    done
    echo "├─────────────────┴────────┼─────────────────┴────────┤" >> main_menu.txt
    echo "│ Add User                 │ Add Gruop                │" >> main_menu.txt
    echo "└──────────────────────────┴──────────────────────────┘" >> main_menu.txt
}

#######################################
#  사용자 관리 메뉴 틀 텍스트 파일 생성하는 스크립트
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   user_menu.txt를 생성
#######################################

function create_user_menu {
    check_and_creat_txt user_menu.txt
    clear_txt user_menu.txt

    echo "┌──UserInfo───────────────────────────────────────────┐" >> user_menu.txt
    echo "│ User:                                               │" >> user_menu.txt
    echo "│ Comment:                                            │" >> user_menu.txt
    echo "│ Shell:                                              │" >> user_menu.txt
    echo "│ Primary group:                                      │" >> user_menu.txt
    echo "└─────────────────────────────────────────────────────┘" >> user_menu.txt
    echo "┌──UserOption─────────────────────────────────────────┐" >> user_menu.txt
    echo "│ Edit comment               Edit group               │" >> user_menu.txt
    echo "│ Remove user                Return manu              │" >> user_menu.txt
    echo "└─────────────────────────────────────────────────────┘" >> user_menu.txt
    echo "  Input:" >> user_menu.txt
}

#######################################
#  그룹 관리 메뉴 틀 텍스트 파일 생성하는 스크립트
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   group_menu.txt를 생성
#######################################

function create_group_menu {
    check_and_creat_txt group_menu.txt
    clear_txt group_menu.txt

    echo "┌──MemberList─────────────────────────────────────────┐" >> group_menu.txt
    echo "│                                                     │" >> group_menu.txt
    echo "│                                                     │" >> group_menu.txt
    echo "│                                                     │" >> group_menu.txt
    echo "│                                                     │" >> group_menu.txt
    echo "└─────────────────────────────────────────────────────┘" >> group_menu.txt
    echo "┌──GroupOption────────────────────────────────────────┐" >> group_menu.txt
    echo "│ Add member                 Remove member            │" >> group_menu.txt
    echo "│ Remove group               Return manu              │" >> group_menu.txt
    echo "└─────────────────────────────────────────────────────┘" >> group_menu.txt
    echo "  Input:" >> group_menu.txt
}

#######################################
#  입력 창 텍스트 파일을 생성하는 스크립트
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   input_menu.txt를 생성
#######################################

function creat_input_menu {
    check_and_creat_txt Input.txt
    clear_txt Input.txt

    echo "  Input:                                                             " >> Input.txt
}

######################################################################################################################################

##################################################
#
#   방향키 입력 스크립트
#
##################################################

#######################################
#  방향키와 엔터키를 입력받는 스크립트
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   입력받은 키의 문자열을 반환
#######################################

function input_enter_and_arrow_key() {
    escape_char=$(printf "\u1b")
    read -rsn1 key

    if [[ $key == $escape_char ]]; then
        read -rsn2 key
    fi

    case $key in
        '[A') echo "up" ;;
        '[B') echo "down" ;;
        '[D') echo "left" ;;
        '[C') echo "right" ;;
        '') echo "enter" ;;
        *) >&2 echo -n "" ;;
    esac
}

######################################################################################################################################

##################################################
#
#   커서 이동 관련 스크립트
#
# 동작 순서
#1,이동 전 커서 위치 저장
#2,이동 후 커서 위치 계산 후 저장
#3, 1,2과정에서 얻은 위치 정보를 move_cursor에 전달
#
##################################################

#######################################
#  '>' 기호 입출력 관련 스크립트
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################

function put_arrow {
    echo -n ">"
}

function del_arrow {
    echo -n " "
}

#######################################
#  '>' 기호 입출력 관련 스크립트
# Globals:
#   None
# Arguments:
#   $1 pre_row
#   $2 pre_col
#   $3 cur_row
#   $4 cur_col
# Outputs:
#   None
#######################################

function move_arrow {
    move_cursor $1 $2
    del_arrow
    move_cursor $3 $4
    put_arrow
}

######################################################################################################################################

###################################################################################
#
#   관리 메뉴 실행 스크립트
#
# 1,커서 위치 정보는 각각의 메뉴 스크립트가 따로 관리한다.
#메인 메뉴에서 관리 메뉴로 넘어갈때 넘어가기 직전의 커서 위치 정보를 저장한다.
#관리 메뉴가 끝나면 저장했던 위치 정보를 불러와서 메인 메뉴의 커서를 배치한다.
#
# 2,커서의 위치 정보는 이동 전 위치와 이동 후 위치를 두가지 상태 모두 기록한다.
#커서의 위치정보를 먼저 갱신한뒤 > 기호를 움직이기 때문에 두가지 상태 모두 기록해야한다.
#
###################################################################################

#######################################
#  유저 메뉴 실행 스크립트
# Globals:
#   None
# Arguments:
#   $1 시작 열
#   $2 관리할 사용자
# Outputs:
#   None
#######################################

function user_menu_control {
    local row_begin=$1
    local user=$2
    #메뉴 종료 변수(1되면 종료함)
    local menu_end=0
    #메뉴 텍스트 출력
    move_cursor $row_begin 0
    create_user_menu
    cat user_menu.txt
    rm user_menu.txt
    #UserInfo 채우기
    move_cursor ` expr $row_begin + 1 ` 8
    echo $user
    move_cursor ` expr $row_begin + 2 ` 11
    get_user_comment $user
    move_cursor ` expr $row_begin + 3 ` 9
    get_user_shell $user
    move_cursor ` expr $row_begin + 4 ` 17
    get_user_primary_group $user
    #커서 범위(행은 범위 내에서 움직이고 열은 두 위치만 가능함)
    local Info_row_len=4
    local row_range_begin=`expr $row_begin + $Info_row_len + 3 `
    local row_range_end=`expr $row_range_begin + 1 `
    local col_pos_left=1
    local col_pos_right=28
    #이전 커서 위치(열,행)
    local pre_col=1
    local pre_row=$row_range_begin
    #현재 커서 위치(열,행)
    local cur_col=1
    local cur_row=$row_range_begin
    #초기 커서 셋팅
    move_cursor $cur_row $cur_col
    put_arrow
    move_cursor $cur_row $cur_col
    visible_cursor off

    ######################################
    #
    #유저 관리 메뉴 커서 이동 함수
    #
    ######################################

    function user_move_up {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #커서의 현재위치가 1행인 경우 메뉴의 마지막 행으로 감
        if [ $cur_row -eq $row_range_begin ]; then
            cur_row=$row_range_end
        #커서의 현재위치가 유저 목록의 1행이 아닌 경우에만 위로 한칸 이동
        elif [ $cur_row -ne $row_range_begin ]; then
            cur_row=$((cur_row-1))
        fi
        move_arrow $pre_row $pre_col $cur_row $cur_col
    }

    function user_move_down {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #커서의 현재위치가 유저 목록의 마지막 행인 경우 메뉴의 시작 행으로감
        if [ $cur_row -eq $row_range_end ]; then
            cur_row=$row_range_begin
        #커서의 현재위치가 유저 목록의 마지막 행이 아닌 경우에만 아래로 한칸 이동
        elif [ $cur_row -ne $row_range_end ]; then
            cur_row=$((cur_row+1))
        fi
        move_arrow $pre_row $pre_col $cur_row $cur_col
    }

    function user_move_right {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #오른쪽 이동은 오른쪽 탭으로 이동
        cur_col=$col_pos_right
        move_arrow $pre_row $pre_col $cur_row $cur_col
    }

    function user_move_left {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #왼쪽 이동은 왼쪽 탭으로 이동
        cur_col=$col_pos_left
        move_arrow $pre_row $pre_col $cur_row $cur_col
    }

    function user_move_enter {
        #Input 공간 정리
        move_cursor $(($row_begin+10)) 0
        creat_input_menu
        cat Input.txt
        rm Input.txt
        move_cursor $(($row_begin+10)) 9
        #입력 받기 전 터미널 커서 보이게 하기
        visible_cursor on
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #왼쪽 탭에 커서가 있는 경우
        if [ $cur_col -eq $col_pos_left ]; then
            #1행에 커서가 있는 경우(Edit comment)
            if [ $cur_row -eq $row_range_begin ]; then
                local input_comment
                read input_comment
                edit_user_comment $user $input_comment
            #2행에 커서가 있는 경우(Remove user)
            elif [ $cur_row -eq $row_range_end ]; then
                del_user $user
                #유저 삭제시 메인 메뉴 목록 초기화
                main_menu_control
            fi
        #오른쪽 탭에 커서가 있는 경우
        elif [ $cur_col -eq $col_pos_right ]; then
            #1행에 커서가 있는 경우(Edit group)
            if [ $cur_row -eq $row_range_begin ]; then
                local input_group
                read input_group
                edit_user_primary_group $user $input_group
                #기본 그룹 변경시 메인 메뉴 목록 초기화
                main_menu_control
            #2행에 커서가 있는 경우(Return manu)
            elif [ $cur_row -eq $row_range_end ]; then
                menu_end=1
            fi
        fi
    }

    ######################################
    #
    #유저 관리 메뉴 동작 코드
    #
    ######################################

    while (($menu_end == 0)); do
        local INPUT=$(input_enter_and_arrow_key)
        if [ "${INPUT}" == "enter" ]; then
            user_move_enter
        elif [ "${INPUT}" == "up" ]; then
            user_move_up
        elif [ "${INPUT}" == "down" ]; then
            user_move_down
        elif [ "${INPUT}" == "right" ]; then
            user_move_right
        elif [ "${INPUT}" == "left" ]; then
            user_move_left
        fi
        #원인은 모르겠지만 커서 동작후 감추기 옵션이 계속 풀림
        #루프를 돌때마다 감추기 옵션 활성화
        visible_cursor off
    done
}

#######################################
#  그룹 메뉴 실행 스크립트
# Globals:
#   None
# Arguments:
#   $1 시작 열
#   $2 관리할 그룹GID
# Outputs:
#   None
#######################################

function group_menu_control {
    local row_begin=$1
    local group_gid=$2
    #메뉴 종료 변수(1되면 종료함)
    local menu_end=0
    #메뉴 텍스트 출력
    move_cursor $row_begin 0
    create_group_menu
    cat group_menu.txt
    rm group_menu.txt
    #MemberList 채우기
    local member_list=`grep -w $group_gid /etc/group | cut -d ":"  -f 4`
    member_list+=","
    move_cursor ` expr $row_begin + 1 ` 2
    echo `echo $member_list | cut -d "," -f 1`
    move_cursor ` expr $row_begin + 1 ` 29
    echo `echo $member_list | cut -d "," -f 2`
    move_cursor ` expr $row_begin + 2 ` 2
    echo `echo $member_list | cut -d "," -f 3`
    move_cursor ` expr $row_begin + 2 ` 29
    echo `echo $member_list | cut -d "," -f 4`
    move_cursor ` expr $row_begin + 3 ` 2
    echo `echo $member_list | cut -d "," -f 5`
    move_cursor ` expr $row_begin + 3 ` 29
    echo `echo $member_list | cut -d "," -f 6`
    move_cursor ` expr $row_begin + 4 ` 2
    echo `echo $member_list | cut -d "," -f 7`
    move_cursor ` expr $row_begin + 4 ` 29
    echo `echo $member_list | cut -d "," -f 8`
    #커서 범위(행은 범위 내에서 움직이고 열은 두 위치만 가능함)
    local Info_row_len=4
    local row_range_begin=`expr $row_begin + $Info_row_len + 3 `
    local row_range_end=`expr $row_range_begin + 1 `
    local col_pos_left=1
    local col_pos_right=28
    #이전 커서 위치(열,행)
    local pre_col=1
    local pre_row=$row_range_begin
    #현재 커서 위치(열,행)
    local cur_col=1
    local cur_row=$row_range_begin
    #초기 커서 셋팅
    move_cursor $cur_row $cur_col
    put_arrow
    move_cursor $cur_row $cur_col
    visible_cursor off

    ######################################
    #
    #그룹 관리 메뉴 커서 이동 함수
    #
    ######################################

    function group_move_up {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #커서의 현재위치가 1행인 경우 메뉴의 마지막 행으로 감
        if [ $cur_row -eq $row_range_begin ]; then
            cur_row=$row_range_end
        #커서의 현재위치가 유저 목록의 1행이 아닌 경우에만 위로 한칸 이동
        elif [ $cur_row -ne $row_range_begin ]; then
            cur_row=$((cur_row-1))
        fi
        move_arrow $pre_row $pre_col $cur_row $cur_col
    }

    function group_move_down {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #커서의 현재위치가 유저 목록의 마지막 행인 경우 메뉴의 시작 행으로감
        if [ $cur_row -eq $row_range_end ]; then
            cur_row=$row_range_begin
        #커서의 현재위치가 유저 목록의 마지막 행이 아닌 경우에만 아래로 한칸 이동
        elif [ $cur_row -ne $row_range_end ]; then
            cur_row=$((cur_row+1))
        fi
        move_arrow $pre_row $pre_col $cur_row $cur_col
    }

    function group_move_right {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #오른쪽 이동은 오른쪽 탭으로 이동
        cur_col=$col_pos_right
        move_arrow $pre_row $pre_col $cur_row $cur_col
    }

    function group_move_left {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #왼쪽 이동은 왼쪽 탭으로 이동
        cur_col=$col_pos_left
        move_arrow $pre_row $pre_col $cur_row $cur_col
    }

    function group_move_enter {
        #Input 공간 정리
        move_cursor $(($row_begin+10)) 0
       creat_input_menu
        cat Input.txt
        rm Input.txt
        move_cursor $(($row_begin+10)) 9
        #입력 받기 전 터미널 커서 보이게 하기
        visible_cursor on
        #$group_gid가 gid라 이를 그룹명으로 저장
        local group=`getent group $group_gid | cut -d: -f1`
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #왼쪽 탭에 커서가 있는 경우
        if [ $cur_col -eq $col_pos_left ]; then
            #1행에 커서가 있는 경우(Add member)
            if [ $cur_row -eq $row_range_begin ]; then
                local input_member_arr
                read input_member_arr
                add_group_member $group `echo $input_member_arr`
            #2행에 커서가 있는 경우(Remove group)
            elif [ $cur_row -eq $row_range_end ]; then
                local input_group
                read input_group
                del_group $input_group
            fi
        #오른쪽 탭에 커서가 있는 경우
        elif [ $cur_col -eq $col_pos_right ]; then
            #1행에 커서가 있는 경우(Remove member)
            if [ $cur_row -eq $row_range_begin ]; then
                local input_member_arr
                read input_member_arr
                del_group_member $group `echo $input_member_arr`
            #2행에 커서가 있는 경우(Return manu)
            elif [ $cur_row -eq $row_range_end ]; then
                menu_end=1
            fi
        fi
    }

    ######################################
    #
    #그룹 관리 메뉴 동작 코드
    #
    ######################################

    while (($menu_end == 0)); do
        local INPUT=$(input_enter_and_arrow_key)
        if [ "${INPUT}" == "enter" ]; then
            group_move_enter
        elif [ "${INPUT}" == "up" ]; then
            group_move_up
        elif [ "${INPUT}" == "down" ]; then
            group_move_down
        elif [ "${INPUT}" == "right" ]; then
            group_move_right
        elif [ "${INPUT}" == "left" ]; then
            group_move_left
        fi
        #원인은 모르겠지만 커서 동작후 감추기 옵션이 계속 풀림
        #루프를 돌때마다 감추기 옵션 활성화
        visible_cursor off
    done
}

#######################################
#  메인 메뉴 실행 스크립트
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################

function main_menu_control {
    #user_DB.txt 갱신
    creat_user_var
    create_user_DB
    #메뉴 종료 변수(1되면 종료함)
    local menu_end=0
    #메인 메뉴로 돌아올 때는 화면초기화
    clear_terminal
    create_main_menu
    cat main_menu.txt
    rm main_menu.txt
    #커서 범위(행은 범위 내에서 움직이고 열은 두 위치만 가능함)
    local row_range_begin=1
    local row_range_end=`wc -l user_DB.txt | cut -d ' ' -f1`
    local col_pos_left=1
    local col_pos_right=28
    #이전 커서 위치(열,행)
    local pre_col=1
    local pre_row=1
    #현재 커서 위치(열,행)
    local cur_col=1
    local cur_row=1
    #메인메뉴 하단 옵션 위치
    local row_option=`expr $row_range_end + 2`
    #초기 커서 셋팅
    move_cursor $cur_row $cur_col
    put_arrow
    move_cursor $cur_row $cur_col
    visible_cursor off

    ######################################
    #
    #메인 메뉴 커서 이동 함수
    #
    ######################################

    function main_move_up {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #커서의 현재위치가 1행인 경우 옵션 행으로 감
        if [ $cur_row -eq $row_range_begin ]; then
            cur_row=$row_option
        #커서의 현재위치가 옵션인 경우 유저 목록의 마지막 행으로 감
        elif [ $cur_row -eq $row_option ]; then
            cur_row=$row_range_end
        #커서의 현재위치가 유저 목록의 1행이 아닌 경우에만 위로 한칸 이동
        elif [ $cur_row -ne $row_range_begin ]; then
            cur_row=$((cur_row-1))
        fi
        move_arrow $pre_row $pre_col $cur_row $cur_col
    }

    function main_move_down {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #커서의 현재위치가 유저 목록의 마지막 행인 경우 옵션 행으로감
        if [ $cur_row -eq $row_range_end ]; then
            cur_row=$row_option
        #커서의 현재위치가 옵션인 경우 유저 목록의 1행으로 감
        elif [ $cur_row -eq $row_option ]; then
            cur_row=$row_range_begin
        #커서의 현재위치가 유저 목록의 마지막 행이 아닌 경우에만 아래로 한칸 이동
        elif [ $cur_row -ne $row_range_end ]; then
            cur_row=$((cur_row+1))
        fi
        move_arrow $pre_row $pre_col $cur_row $cur_col
    }

    function main_move_right {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #오른쪽 이동은 그룹탭으로 이동
        cur_col=$col_pos_right
        move_arrow $pre_row $pre_col $cur_row $cur_col
    }

    function main_move_left {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #왼쪽 이동은 유저탭으로 이동
        cur_col=$col_pos_left
        move_arrow $pre_row $pre_col $cur_row $cur_col
    }

    function main_move_enter {
        #이전 커서 위치 정보 저장
        pre_col=$cur_col
        pre_row=$cur_row
        #커서가 옵션 행에 있는 경우
        if [ $cur_row -eq $row_option ]; then
            #Input 공간 정리
            move_cursor `expr $row_option + 2` 0
            creat_input_menu
            cat Input.txt
            rm Input.txt
            move_cursor `expr $row_option + 2` 9
            #입력 받기 전 터미널 커서 보이게 하기
            visible_cursor on
            if [ $cur_col -eq $col_pos_left ]; then
                #유저 추가 부분
                local input_user
                read input_user
                add_user $input_user
            elif [ $cur_col -eq $col_pos_right ]; then
                #그룹 추가 부분
                local input_user
                read input_user
                add_group $input_user
            fi
            #추가사항 반영하여 갱신
            main_menu_control
        else
            #유저 탭에 커서가 있는 경우
            if [ $cur_col -eq $col_pos_left ]; then
                user_menu_control `expr $row_option + 3` `head -n $cur_row user_DB.txt | tail -1 | cut -d ":"  -f 1 `
            #그룹 탭에 커서가 있는 경우
            elif [ $cur_col -eq $col_pos_right ]; then
                group_menu_control `expr $row_option + 3` `head -n $cur_row user_DB.txt | tail -1 | cut -d ":"  -f 4 `
            fi
        fi
    }

    ######################################
    #
    #메인 메뉴 동작 코드
    #
    ######################################

    while (($menu_end == 0)); do
        local INPUT=$(input_enter_and_arrow_key)
        if [ "${INPUT}" == "enter" ]; then
            main_move_enter
        elif [ "${INPUT}" == "up" ]; then
            main_move_up
        elif [ "${INPUT}" == "down" ]; then
            main_move_down
        elif [ "${INPUT}" == "right" ]; then
            main_move_right
        elif [ "${INPUT}" == "left" ]; then
            main_move_left
        fi
        #원인은 모르겠지만 커서 동작후 감추기 옵션이 계속 풀림
        #루프를 돌때마다 감추기 옵션 활성화
        visible_cursor off
    done
}

#스크립트 실행
main_menu_control
