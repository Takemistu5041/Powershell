#
#   ATLASドライバダウンロード
#
#   Copyright 2023 By T.Tanaka
#


#   ログインユーザチェック

$User = whoami.exe

$Check_User = $User.split("\")

if((($Check_User[$Check_User.count -1]).ToUpper()) -ne "OQSCOMAPP"){
    Read-Host "OQSComAppアカウントでログインして下さい。`r`n何かキーを押してください。"
    exit
}

#   「アトラス」フォルダを確認

write-output "--"
Write-Output "アトラスのドライバをダウンロードします。"

Write-Output "「アトラス」フォルダをチェック"

$TargetFolder ='C:\Logitec INA Solutions\FaceAppInstaller\アトラス'

#   フォルダの存在チェック
if(test-path $TargetFolder){
    Write-Output ("`t" + $TargetFolder + "は存在します。")
}else{
    Write-Output ("`t" + $TargetFolder + "が存在しません、作成します。【Fix】")
    New-Item -path $TargetFolder -ItemType Directory
}

write-output "--"
Write-Output "プロキシをオフにします。"

#   プロキシをオフ
New-ItemProperty -LiteralPath "HKCU:Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -PropertyType "DWord" -Value "0" -force

#Start-Process "gpupdate" "/force" -Wait
Start-Sleep -Milliseconds 10000

write-output "--"
Write-Output "ドライバをダウンロードします。"

#   ダウンロード
[String]$path='C:\Logitec INA Solutions\FaceAppInstaller\アトラス'
[String]$url='https://www.atlas-is.co.jp/img/exc9000install.zip'

# ファイルをダウンロードするためのWebClientオブジェクトを生成
$cli = New-Object System.Net.WebClient
# ファイルリストから順にURLを抽出
# 取り出したURLからファイル名を取り出し、変数$fileにセット
$uri = New-Object System.Uri($url)
$file = Split-Path $uri.AbsolutePath -Leaf
# 指定されたURLからファイルをダウンロードし、同名のファイル名で保存
$cli.DownloadFile($uri, (Join-Path $path $file))

write-output "--"
Write-Output "プロキシをオンに戻します。"
  
#   プロキシをオン
New-ItemProperty -LiteralPath "HKCU:Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -PropertyType "DWord" -Value "1" -force

Read-Host 終了しました。画面を閉じるには何かキーを押してください…
exit
