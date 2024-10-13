#
#   DelPol.ps1
#
#

$TargetFilePath = "$Env:systemroot\system32\GroupPolicy\User","$Env:systemroot\system32\GroupPolicy\Machine"
$TargetFileName = "Registry.pol"

foreach($CheckPath in $TargetFilePath){

    Write-Output ($CheckPath + "のポリシーファイルを確認します。")

        #   ファイルチェック
    if ((Test-Path ($TargetFilePath[[array]::indexof($TargetFilePath,$CheckPath)] + '\' + $TargetFileName)) -eq $false){

        write-output ($TargetFilePath[[array]::indexof($TargetFilePath,$CheckPath)] + '\' + $TargetFileName + "が存在しません。")

    }else{

        #   ファイルを削除

        Write-Output ($CheckPath + "のポリシーファイルを削除します。")
        Remove-Item  ($TargetFilePath[[array]::indexof($TargetFilePath,$CheckPath)] + '\' + $TargetFileName)

    }
}

Read-Host 終了しました。画面を閉じるには何かキーを押してください…
exit
