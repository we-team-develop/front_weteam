@echo off
echo .
echo ====== ������ �߰� ��... (git submodule add) ======
git submodule add -f https://github.com/we-team-develop/front_weteam_submodule front_weteam_submodule
echo .
echo ====== ������ �ʱ�ȭ ��... (git submodule init) ======
git submodule init
echo .
echo ====== ���� ��� �ֽ�ȭ ��... (git submodule update) ======
git submodule update --remote
echo .
echo ====== ������ �����ϴ� ��... (robocopy) ======
robocopy .\front_weteam_submodule\ .\ /E /IS
