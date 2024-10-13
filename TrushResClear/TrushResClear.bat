@echo off
rem ゴミ箱を空に、C:\OQS\Resフォルダのdel*.txtで1w以上前のものは削除
echo ゴミ箱を空にします
powershell clear-recyclebin -force
echo resフォルダの古いファイルを削除します
forfiles /p C:\OQS\res /m del*.txt /d -7 /C "cmd /c del @file"
rem forfiles /p C:\OQS\res /m del*.txt /d -7
@timeout 5
