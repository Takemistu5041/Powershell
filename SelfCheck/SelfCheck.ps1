#
#   SelfCheck
#
#   Copyright2021 By T.Tanaka
#

#   管理者権限チェック
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    #Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    Start-Process powershell.exe " -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs;

    exit
}

#
#   選択肢の作成
#
$typename = "System.Management.Automation.Host.ChoiceDescription"
$yes = new-object $typename("&Yes","はい")
$no  = new-object $typename("&No","いいえ")

#
#   選択肢コレクションの作成
#
$assembly= $yes.getType().AssemblyQualifiedName
$Choice = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice.add($yes)
$Choice.add($no)


#   ログインユーザ名取得
#$User = whoami.exe

#$Check_User = $User.split("\")
#$LoginUser = $Check_User[$Check_User.count -1].ToUpper()


#
#   パスワード入力/チェック
#

#do {
#    $SecPass = Read-Host "$LoginUser のパスワード" -AsSecureString
#    $SecPass2 = Read-Host "パスワード確認入力" -AsSecureString
#    if ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass)) -ne [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass2))) {
#        Write-Output "パスワードが異なります"        
#    }
#} while ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass)) -ne [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass2)))


#
#   Chrome周りチェック
#

Write-Output ("--")
Write-Output ("【Chromeの設定を確認します。】")

$CheckChoromePath = $PSScriptRoot + "\Check_Chrome.ps1"

#   ファイルチェック
if ((Test-Path ($CheckChoromePath)) -eq $false){
    write-output ($CheckChoromePath + "が存在しません。【エラー】")
}else{
    Start-Process powershell.exe -ArgumentList $CheckChoromePath , "-Child 1" -NoNewWindow -Wait
}



#
#   Defenderチェック
#

Write-Output ("--")
Write-Output ("【Defenderの設定を確認します。】")

$CheckDFPath = $PSScriptRoot + "\Check_Defender.ps1"

#   ファイルチェック
if ((Test-Path ($CheckDFPath)) -eq $false){
    write-output ($CheckDFPath + "が存在しません。【エラー】")
}else{
    Start-Process powershell.exe -ArgumentList $CheckDFPath , "-Child 1" -NoNewWindow -Wait
}

#
#   TeamViewerチェック
#

Write-Output ("--")
Write-Output ("【TeamViewerの設定を確認します。】")

$CheckTVPath = $PSScriptRoot + "\Check_TeamViewer.ps1"

#   ファイルチェック
if ((Test-Path ($CheckTVPath)) -eq $false){
    write-output ($CheckTVPath + "が存在しません。【エラー】")
}else{
    Start-Process powershell.exe -ArgumentList $CheckTVPath , "-Child 1" -NoNewWindow -Wait
}

#
#   メモ帳チェック
#

Write-Output ("--")
Write-Output ("【メモ帳の設定を変更します。】")

$CheckTVPath = $PSScriptRoot + "\SetupNotepadOpenNewWindow.ps1"

#   ファイルチェック
if ((Test-Path ($CheckTVPath)) -eq $false){
    write-output ($CheckTVPath + "が存在しません。【エラー】")
}else{
    Start-Process powershell.exe -ArgumentList $CheckTVPath , "-Child 1" -NoNewWindow -Wait
}


#   処理終了

write-output "--"
Write-Output "【処理は終了しました。】"
Read-Host 画面を閉じるには何かキーを押してください…

exit
