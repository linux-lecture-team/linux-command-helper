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
    echo `grep /bin/bash /etc/passwd | grep $1  | cut -d ":"  -f 5`
}

#비밀번호 권장 비밀번호 변경일까지 남은 일 수 (사용 인자: $1=사용자 이름 ,반환: 남은 일 수) - 완성
function passwd_day_check {
    echo `grep $1 /etc/shadow | cut -d ":"  -f 5`
}

#사용 쉘 조회 (사용 인자: $1=사용자 이름 ,반환: 쉘 이름) - 완성
function user_shell_check {
    echo `grep /bin/bash /etc/passwd | grep $1  | cut -d ":"  -f 7`
}


###############################################
#사용자 추가, 제거
###############################################

#사용자 추가 (사용 인자: $1=사용자 이름) - 완성
function user_add {
    useradd -d /home/"$1" -s /bin/bash "$1"
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

#사용자 비밀번호 변경 (사용 인자: $1=사용자 이름) - 완성
function user_passwd_edit {
    passwd -f $1
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

#사용자 관리 테스트 명령어
#input="gamepain"
#comment_check $input
#passwd_day_check $input
#user_shell_check $input
#input="gamepain2"
#user_add $input
#user_comment_edit $input check
#comment_check $input
#user_del $input
#input="gamepain"
#user_passwd_edit $input

#그룹테스트 명령어
#group_add newG
#group_member_add newG gamepain gamepain2 gamepain3 gamepain4 gamepain5
#grep newG /etc/group | cat
#group_member_del newG gamepain gamepain2 gamepain3 gamepain4 gamepain5
#grep newG /etc/group | cat
#group_del newG


