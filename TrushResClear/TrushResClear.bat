@echo off
rem �S�~������ɁAC:\OQS\Res�t�H���_��del*.txt��1w�ȏ�O�̂��͍̂폜
echo �S�~������ɂ��܂�
powershell clear-recyclebin -force
echo res�t�H���_�̌Â��t�@�C�����폜���܂�
forfiles /p C:\OQS\res /m del*.txt /d -7 /C "cmd /c del @file"
rem forfiles /p C:\OQS\res /m del*.txt /d -7
@timeout 5
