#!/bin/bash


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

#유저 관리 메뉴 텍스트 파일을 생성
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

#그룹 관리 메뉴 텍스트 파일을 생성
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

create_user_DB

create_main_menu
#출력 테스트
#cat main_menu.txt

create_user_menu
#출력 테스트
#cat user_menu.txt

create_group_menu
#출력 테스트
#cat group_menu.txt

creat_input_menu