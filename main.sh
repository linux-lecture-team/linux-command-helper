#!/bin/bash


. "test.sh"

#아직 커서 이동 부분을 구현하지 못해서 구현 후 저장된 커서의 위치에 따라서 결과를 출력할 함수 (미완성)

function print_result
{
    if [cursor = ??]; then
        ls -a
    elif [cursor = ??]; then
        ls -l
    elif [cursor = ??]; then
        ls -F
    elif [cursor = ??]; then
        ls -r
    elif [cursor = ??]; then
        ls -t
    elif [cursor = ??]; then
        ls -S
    fi
}

#커서 이동 후에 엔터 치면 결과 출력하고, 계속 실행 할 것인지에 대한 물음 출력
#Y 또는 y를 입력시 main.sh 파일을 다시 실행시켜 처음부터 재실행, N 또는 n 입력시 종료
read -p "Do you want to continue running the program? [Y/N]" result

if [ ${result} == 'Y' ] || [ ${result} == 'y' ]; then
    . main.sh
    #이 경우 원하시면 저의 파일이 아닌 맨 처음 파일 실행되는 부분부터 실행하도록 파일을 불러오셔도 괜찮습니다 ! 
elif [ ${result} == 'N' ] || [ ${result} == 'n' ]; then
    echo "Exit the program."
fi


#ls 이후에 두 개의 명령을 원할 경우 그 부분을 어떻게 구현할지는 아직 구상중
#ex) ls -al