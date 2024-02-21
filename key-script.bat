@echo off
echo .
echo ====== 서브모듈 추가 중... (git submodule add) ======
git submodule add -f https://github.com/we-team-develop/front_weteam_submodule front_weteam_submodule
echo .
echo ====== 서브모듈 초기화 중... (git submodule init) ======
git submodule init
echo .
echo ====== 서브 모듈 최신화 중... (git submodule update) ======
git submodule update --remote
echo .
echo ====== 파일을 적용하는 중... (robocopy) ======
robocopy .\front_weteam_submodule\ .\ /E /IS
