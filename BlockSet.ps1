#
#   GoogoeChromeのブロックリスト追加(※未完成)
#
#   BlockSet.ps1
#
#   Copyright 2021 By T.Tanaka
#

#   管理者権限
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

#   設定ファイル確認
$BlockListFile = ".\BlockList2.txt"

if((test-path $BlockListFile) -eq $false){

    [System.Windows.forms.MessageBox]::Show("設定ファイル($BlockListFile)が見つかりませんでした")
    Exit

}