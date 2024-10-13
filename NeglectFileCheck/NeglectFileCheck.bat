@echo off
rem forfiles版
rem UNCパスは使えないっぽい(Pushdで移動してからforfilesを実行する)
rem \\172.20.0.83\文書管理
echo C:\work\共有起点\文書管理
powershell clear-recyclebin -force
echo\

rem forfilesだと最終更新日でチェック
rem forfiles /p C:\work\共有起点\文書管理 /s /m *.* /d -7 /C "cmd /c del @file"
forfiles /p C:\work\共有起点\文書管理 /s /m *.* /d -7 /C "cmd /c echo @file"

@timeout 5

pause

