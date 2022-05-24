#!/bin/bash

###############################################
#
#유저 목록을 관리하는 함수를 구현한 스크립트 입니다.
#
###############################################

###############################################
#자세한 정보 조회
###############################################

#코멘트 조회 (사용 인자: $1=사용자 이름 ,반환: 코멘트) - 완성
function comment_check {
    echo `grep /bin/bash /etc/passwd | grep -w $1  | cut -d ":"  -f 5`
}

#기본 그룹 조회 (사용 인자: $1=사용자 이름) - 완성
function primary_group_check {
    echo `groups $1 | cut -d":" -f 2 | cut -d" " -f 2`
}

#사용 쉘 조회 (사용 인자: $1=사용자 이름 ,반환: 쉘 이름) - 완성
function user_shell_check {
    echo `grep /bin/bash /etc/passwd | grep -w $1  | cut -d ":"  -f 7`
}


###############################################
#사용자 추가, 제거
###############################################

#사용자 추가 (사용 인자: $1=사용자 이름) - 완성
function user_add {
    useradd -N -d /home/"$1" -s /bin/bash "$1"
    #기본 그룹 설정
    usermod -G 100 $1
}

#사용자 제거 (사용 인자: $1=사용자 이름) - 완성
function user_del {
    userdel -r $1
}


###############################################
#사용자 정보 변경
###############################################

#사용자 코멘트 변경 (사용 인자: $1=사용자 이름 $2=입력할 코멘트) - 완성
function user_comment_edit {
    usermod -c $2 $1
}

#유저 기본 기룹 변경 (사용 인자: $1=사용자 이름 $2=그룹이름 ) - 완성
function user_group_edit {
    usermod -g $2 $1
}

###############################################
#그룹 추가, 제거
###############################################

#그룹 추가 (사용 인자: $1=그룹 이름) - 완성
function group_add {
    groupadd $1
}

#그룹 제거 (사용 인자: $1=그룹 이름) - 완성
function group_del {
    groupdel $1
}

###############################################
#그룹 관리
#
#이슈: 사용자의 그룹은 주 그룹과 나머지 그룹으로 구성됨
#그룹을 추가시 주 그룹의 변경 여부
#
###############################################

#그룹 멤버 추가 (사용 인자: $1=그룹 이름 $2...=추가할 사용자 목록) - 완성
function group_member_add {
    for param in "$@"
    do
        if [ $param = $1 ]
        then
            continue
        fi
        usermod -G $1 -a $param
    done
}

#그룹 멤버 제거 (사용 인자: $1=그룹 이름 $2...=제거할 사용자 목록) - 완성
function group_member_del {
    for param in "$@"
    do
        if [ $param = $1 ]
        then
            continue
        fi
        gpasswd -d $param $1
    done
}

#############################################################
#
#   화면 출력에 필요한 텍스트 파일을 만드는 스크립트입니다.
#
# 제작하는 텍스트 파일 목록
#user_DB.txt: 유저 목록을 저장한 파일
#main_menu.txt: 메인 메뉴 텍스트를 저장한 파일
#user_menu.txt: 유저 관리 메뉴 텍스트를 저장한 파일
#group_menu.txt: 그룹 관리 메뉴 텍스트를 저장한 파일
# 
#############################################################

function creat_user_var {
    # 유저 목록 변수
    user=`grep /bin/bash /etc/passwd | cut -d ":"  -f 1`
    # 변수출력 테스트
    #echo -n "user: "
    #echo $user

    # UID 목록 변수
    _UID=`grep /bin/bash /etc/passwd | cut -d ":"  -f 3`
    # 변수출력 테스트
    #echo -n "UID: "
    #echo $_UID

    #GID 목록을 변수
    _GID=`grep /bin/bash /etc/passwd | cut -d ":"  -f 4`
    # 변수출력 테스트
    #echo -n "GID: "
    #echo $_GID

    # 그룹 목록 변수
    touch group.txt
    for(( i=1 ; i <= `echo "$_GID" | wc -l | cut -d ' ' -f1` ; i++)); do
    GID_tem=`echo "$_GID" | head -n $i | tail -1`
    echo `getent group $GID_tem | cut -d: -f1` >> group.txt
    done
    group=`cat group.txt`
    rm group.txt
    # 변수출력 테스트
    #echo -n "group: "
    #echo $group
}

#(User:UID:group:GID)을 한 단위로 DB를 만드는 함수
function create_user_DB {
    [ -s ~/user_DB.txt ] || touch user_DB.txt
    #텍스트 파일 초기화(항목을 하나하나 추가하는 형식으로 작성하기 때문에 초기화 작업이 필요)
    cat /dev/null > user_DB.txt

    for(( i=1 ; i <= `echo "$user" | wc -l | cut -d ' ' -f1` ; i++)); do
        local unit=""
        unit+=`echo "$user" | head -n $i | tail -1`
        unit+=':'
        unit+=`echo "$_UID" | head -n $i | tail -1`
        unit+=':'
        unit+=`echo "$group" | head -n $i | tail -1`
        unit+=':'
        unit+=`echo "$_GID" | head -n $i | tail -1`
        echo $unit | cat >> user_DB.txt
    done
}

#user_DB.txt를 기반으로 메인 메뉴 텍스트 파일 생성
function create_main_menu {
    [ -s ~/main_menu.txt ] || touch main_menu.txt

    #텍스트 파일 초기화(항목을 하나하나 추가하는 형식으로 작성하기 때문에 초기화 작업이 필요)
    cat /dev/null > main_menu.txt

    echo "┌──User───────────┬──UID───┬──Group──────────┬──GID───┐" >> main_menu.txt

    for(( n=1 ; n <= `wc -l user_DB.txt | cut -d ' ' -f1` ; n++ )); do
        local loc_user
        local loc_uid
        local loc_group
        local loc_gid

        echo -n "│ " >> main_menu.txt
        loc_user=`head -n $n user_DB.txt | tail -1 | cut -d ":"  -f 1 `
        #탭의 길이 안에서만 출력, 넘어가는 부분은 출력하지 않음
        echo -n ${loc_user:0:16} >> main_menu.txt
        #탭의 길이에서 문자열이 차지하는 길이를 뺀 나머지 부분을 공백으로 채움
        for (( i=0 ; i < `expr 16 - ${#loc_user}` ; i++ )); do
            echo -n " " >> main_menu.txt
        done

        echo -n "│ " >> main_menu.txt
        loc_uid=`head -n $n user_DB.txt | tail -1 | cut -d ":"  -f 2 `
        echo -n ${loc_uid:0:7} >> main_menu.txt
        for (( i=0 ; i < `expr 7 - ${#loc_uid}` ; i++ )); do
            echo -n " " >> main_menu.txt
        done

        echo -n "│ " >> main_menu.txt
        loc_group=`head -n $n user_DB.txt | tail -1 | cut -d ":"  -f 3 `
        echo -n ${loc_group:0:16} >> main_menu.txt
        for (( i=0 ; i < `expr 16 - ${#loc_group}` ; i++ )); do
            echo -n " " >> main_menu.txt
        done

        echo -n "│ " >> main_menu.txt
        loc_gid=`head -n $n user_DB.txt | tail -1 | cut -d ":"  -f 4 `
        echo -n ${loc_gid:0:7} >> main_menu.txt
        for (( i=0 ; i < `expr 7 - ${#loc_gid}` ; i++ )); do
            echo -n " " >> main_menu.txt
        done

        echo "│" >> main_menu.txt
    done
    echo "├─────────────────┴────────┼─────────────────┴────────┤" >> main_menu.txt
    echo "│ Add User                 │ Add Gruop                │" >> main_menu.txt
    echo "└──────────────────────────┴──────────────────────────┘" >> main_menu.txt
}

#유저 관리 메뉴 텍스트 파일을 생성 ( 1$: 조회할 사용자 )
function create_user_menu {
    [ -s ~/user_menu.txt ] || touch user_menu.txt

    #텍스트 파일 초기화(항목을 하나하나 추가하는 형식으로 작성하기 때문에 초기화 작업이 필요)
    cat /dev/null > user_menu.txt

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

#그룹 관리 메뉴 텍스트 파일을 생성 ( 1$: 조회할 그룹 )
function create_group_menu {
    [ -s ~/group_menu.txt ] || touch group_menu.txt

    #텍스트 파일 초기화(항목을 하나하나 추가하는 형식으로 작성하기 때문에 초기화 작업이 필요)
    cat /dev/null > group_menu.txt

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

#입력창 텍스트 파일을 생성
function creat_input_menu {
    [ -s ~/Input.txt ] || touch Input.txt

    #텍스트 파일 초기화(항목을 하나하나 추가하는 형식으로 작성하기 때문에 초기화 작업이 필요)
    cat /dev/null > Input.txt

    echo "  Input:                                                             " >> Input.txt
}

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

#유저 관리 메뉴 함수( $1: 시작 행 $2: 관리할 사용자)
function user_menu_control {
    #메뉴 종료 변수(1되면 종료함)
    local u_end=0
    #메뉴 텍스트 출력
    tput cup $1 0
    create_user_menu
    cat user_menu.txt
    rm user_menu.txt
    #UserInfo 채우기
    tput cup ` expr $1 + 1 ` 8
    echo $2
    tput cup ` expr $1 + 2 ` 11
    comment_check $2
    tput cup ` expr $1 + 3 ` 9
    user_shell_check $2
    tput cup ` expr $1 + 4 ` 17
    primary_group_check $2
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
    tput cup $col 1
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

    #($1 2: 상위 스크립트 1 2번 인자)
    function user_move_enter {
        #Input 공간 정리
        tput cup $(($1+10)) 0
        creat_input_menu
        cat Input.txt
        rm Input.txt
        tput cup $(($1+10)) 9
        tput cnorm
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #왼쪽 탭에 커서가 있는 경우
        if [ $row -eq $row_pos1 ]; then
            #1행에 커서가 있는 경우(Edit comment)
            if [ $col -eq $col_range_start ]; then
                read comment
                user_comment_edit $2 $comment
            #2행에 커서가 있는 경우(Remove user)
            elif [ $col -eq $col_range_end ]; then
                user_del $2
                #유저 삭제시 메인 메뉴 목록 초기화
                main_menu_control
            fi
        #오른쪽 탭에 커서가 있는 경우
        elif [ $row -eq $row_pos2 ]; then
            #1행에 커서가 있는 경우(Edit group)
            if [ $col -eq $col_range_start ]; then
                read group_name
                user_group_edit $2 $group_name
                #기본 그룹 변경시 메인 메뉴 목록 초기화
                main_menu_control
            #2행에 커서가 있는 경우(Return manu)
            elif [ $col -eq $col_range_end ]; then
                u_end=1
            fi
        fi
    }

    ######################################
    #
    #유저 관리 메뉴 동작 코드
    #(실제로 키보드 입력을 받고 커서를 이동시키는 하는 함수)
    #
    ######################################

    while (($u_end == 0)); do
        INPUT=$(input_key)
        if [[ $INPUT = "" ]]; then
            user_move_enter $1 $2
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

#그룹 관리 메뉴 함수( $1: 시작 행 $2: 관리할 그룹GID )
function group_menu_control {
    #메뉴 종료 변수(1되면 종료함)
    local g_end=0
    #메뉴 텍스트 출력
    tput cup $1 0
    create_group_menu
    cat group_menu.txt
    rm group_menu.txt
    #MemberList 채우기
    local member_list=`grep -w $2 /etc/group | cut -d ":"  -f 4`
    member_list+=","
    tput cup ` expr $1 + 1 ` 2
    echo `echo $member_list | cut -d "," -f 1`
    tput cup ` expr $1 + 1 ` 29
    echo `echo $member_list | cut -d "," -f 2`
    tput cup ` expr $1 + 2 ` 2
    echo `echo $member_list | cut -d "," -f 3`
    tput cup ` expr $1 + 2 ` 29
    echo `echo $member_list | cut -d "," -f 4`
    tput cup ` expr $1 + 3 ` 2
    echo `echo $member_list | cut -d "," -f 5`
    tput cup ` expr $1 + 3 ` 29
    echo `echo $member_list | cut -d "," -f 6`
    tput cup ` expr $1 + 4 ` 2
    echo `echo $member_list | cut -d "," -f 7`
    tput cup ` expr $1 + 4 ` 29
    echo `echo $member_list | cut -d "," -f 8`
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
    tput cup $col 1
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

    #($1 2: 상위 스크립트 1 2번 인자)
    function group_move_enter {
        #Input 공간 정리
        tput cup $(($1+10)) 0
       creat_input_menu
        cat Input.txt
        rm Input.txt
        tput cup $(($1+10)) 9
        tput cnorm
        #$2가 gid라 이를 그룹명으로 저장
        local group=`getent group $2 | cut -d: -f1`
        #이전 커서 위치 정보 저장
        pre_row=$row
        pre_col=$col
        #왼쪽 탭에 커서가 있는 경우
        if [ $row -eq $row_pos1 ]; then
            #1행에 커서가 있는 경우(Add member)
            if [ $col -eq $col_range_start ]; then
                local member_arr
                read member_arr
                group_member_add $group `echo $member_arr`
            #2행에 커서가 있는 경우(Remove group)
            elif [ $col -eq $col_range_end ]; then
                group_del $group
            fi
        #오른쪽 탭에 커서가 있는 경우
        elif [ $row -eq $row_pos2 ]; then
            #1행에 커서가 있는 경우(Remove member)
            if [ $col -eq $col_range_start ]; then
                local member_arr
                read member_arr
                group_member_del $group `echo $member_arr`
            #2행에 커서가 있는 경우(Return manu)
            elif [ $col -eq $col_range_end ]; then
                g_end=1
            fi
        fi
    }

    ######################################
    #
    #그룹 관리 메뉴 동작 코드
    #(실제로 키보드 입력을 받고 커서를 이동시키는 하는 함수)
    #
    ######################################

    while (($g_end == 0)); do
        INPUT=$(input_key)
        if [[ $INPUT = "" ]]; then
            group_move_enter $1 $2
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
    creat_user_var
    create_user_DB
    
    #메인 메뉴로 돌아올 때는 화면초기화
    clear
    create_main_menu
    cat main_menu.txt
    rm main_menu.txt
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
            #Input 공간 정리
            tput cup `expr $col_option + 2` 0
            creat_input_menu
            cat Input.txt
            rm Input.txt
            tput cup `expr $col_option + 2` 9
            tput cnorm
            if [ $row -eq $row_pos1 ]; then
                #유저 추가 부분
                local u_name
                read u_name
                user_add $u_name
            elif [ $row -eq $row_pos2 ]; then
                #그룹 추가 부분
                local g_name
                read g_name
                group_add $g_name
            fi
            #추가사항 반영하여 갱신
            main_menu_control
        else
            #유저 탭에 커서가 있는 경우
            if [ $row -eq $row_pos1 ]; then
                user_menu_control `expr $col_option + 3` `head -n $col user_DB.txt | tail -1 | cut -d ":"  -f 1 `
            #그룹 탭에 커서가 있는 경우
            elif [ $row -eq $row_pos2 ]; then
                group_menu_control `expr $col_option + 3` `head -n $col user_DB.txt | tail -1 | cut -d ":"  -f 4 `
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
#   구현에 문제가 되는 부분 또는 버그 정리
#
#그룹 삭제 기능이 사용자의 대표 그룹은 삭제 불가능 때문에 사실상 제대로 작동안함
#
###################################################################################


main_menu_control
