# linux-command-helper
- 광운대학교 2022학년도 1학기 리눅스 활용 실습 강의에서 진행하는 프로젝트입니다.
<br><br>


## Project Description
- `linux-command-helper` 프로젝트는 리눅스 명령어를 터미널에서 쉽게 사용할 수 있도록 도와주는 프로젝트입니다.
<br><br>


## Project Goal
- `linux-command-helper` 프로젝트의 목표는 다음과 같습니다.  

| 번호 |  목표  |
|---|---|
| 1) | 사용 편의성을 고려한 UI 디자인을 구현합니다. |
| 2) | 리눅스 명령어에 대해서 잘 모르는 사용자도 쉽게 사용할 수 있도록 구현합니다. |
| 3) | 프로젝트를 통해 리눅스 플랫폼에 익숙해집니다. |
| 4) | 구현하고자 하는 리눅스 명령어의 이해도를 높입니다. |
| 5) | 리눅스 셸 스크립트의 이해도를 높입니다. |

<br><br>


## Project Development
- 프로젝트 개발은 아래와 같습니다.

| 멤버 | 담당 업무 |
|---|---|
| `정민우 2019203070` | user_management_helper 기능 구현 |
| `최지원 2019203087` | 통합 클라이언트 구현, 플랫폼 테스트 |
| `유항천 2019203096` | rm_helper 기능 구현 |
| `김수훈 2019204026` | ls_helper 기능 구현 |

<br><br>


## Platform
- `linux-command-helper` 프로젝트는 다음 플랫폼에서 테스트 완료되었습니다.

| 테스트 플랫폼 | 테스트 여부 |
|---|---|
| `WSL2` | O |
| `Ubuntu 20.04 LTS` | O |

<br><br>


## How To Use It
- 터미널에서 다음과 같이 수행합니다.
```
$ git clone https://github.com/linux-lecture-team/linux-command-helper
Cloning into 'linux-command-helper'...
remote: Enumerating objects: 413, done.
remote: Counting objects: 100% (33/33), done.
remote: Compressing objects: 100% (15/15), done.
remote: Total 413 (delta 21), reused 22 (delta 18), pack-reused 380
Receiving objects: 100% (413/413), 75.02 KiB | 441.00 KiB/s, done.
Resolving deltas: 100% (216/216), done.
$ cd linux-command-helper
$ sh linux_command_helper.sh
```
