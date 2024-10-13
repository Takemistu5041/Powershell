#Set-ExecutionPolicy -Scope Process RemoteSigned

#
#   資格情報確認+暗号化設定  SetCredential2.ps1　
#
#   Copyright 2021 By T.Tanaka
#

#   管理者権限チェック
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    #Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    Start-Process powershell.exe " -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs;

    exit
}

#
#   択肢の作成
#
$typename = "System.Management.Automation.Host.ChoiceDescription"
$yes = new-object $typename("&Yes","はい")
$no  = new-object $typename("&No","いいえ")
$ORCA = new-object $typename("&ORCA/その他","ORCAその他")
$FUJI = new-object $typename("&Fuji(Hi-SEED/Pharma-SEED)","富士製品")
$Encrypt = new-object $typename("&Encrypt(暗号化する)","暗号化する")
$NoEncrypt = new-object $typename("&NoEncrypt(暗号化しない)","暗号化しない")
$Skip = new-object $typename("&Skip(変更しない)","変更しない")

#
#   選択肢コレクションの作成
#
$assembly= $yes.getType().AssemblyQualifiedName
$Choice = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice.add($yes)
$Choice.add($no)

$Choice2 = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice2.add($ORCA)
$Choice2.add($FUJI)

$Choice3 = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice3.add($Encrypt)
$Choice3.add($NoEncrypt)
$Choice3.add($Skip)


#
#   パスワード入力/チェック
#

do {
    $SecPass = Read-Host "OQSComApp/ONSRenkei のパスワード" -AsSecureString
    $SecPass2 = Read-Host "パスワード確認入力" -AsSecureString
    if ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass)) -ne [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass2))) {
        Write-Output "パスワードが異なります"        
    }
} while ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass)) -ne [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass2)))

#
#   パスワードポリシーチェック
#

$PassWordPolicyChcek = $false

$BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass)
$Pass=[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

write-output "--"
Write-Output "パスワードポリシーを確認します。"

#   文字数(16文字以上)
if ($Pass.Length -gt 15){
    Write-Output ("`t文字数：" + $pass.Length + "・・・OK")
    $PassWordPolicyChcek += 0x1
}else {
    Write-Output ("`t文字数：" + $pass.Length + "・・・【NG】")
}

#   英大文字
if($pass -cmatch "\p{Lu}+"){
    Write-Output ("`t英大文字：" + $Matches.Values + "・・・OK")
    $PassWordPolicyChcek += 0x2
}else{
    Write-Output ("`t英大文字：なし・・・【NG】") 
}
#   英小文字
if($pass -cmatch "\p{Ll}+"){
    Write-Output ("`t英小文字：" + $Matches.Values + "・・・OK")
    $PassWordPolicyChcek += 0x4
}else{
    Write-Output ("`t英小文字：なし・・・【NG】") 
}

#   数字
if($pass -cmatch "\p{Nd}+"){
    Write-Output ("`t数字：" + $Matches.Values + "・・・OK")
    $PassWordPolicyChcek += 0x8
}else{
    Write-Output ("`t数字：なし・・・【NG】") 
}

#   記号
if($pass -cmatch "\W+"){
    Write-Output ("`t記号：" + $Matches.Values + "・・・OK")
    $PassWordPolicyChcek += 0x10
}else{
    Write-Output ("`t記号：なし・・・【NG】") 
}

if ($PassWordPolicyChcek -ne 31) {
    Write-Output "パスワードがポリシーを満たしていません。"
    Read-Host 終了します。画面を閉じるには何かキーを押してください…
    Exit
}


#
#	資格情報確認
#
write-output "--"
Write-Output "資格情報を確認します。"


#   レセコン選択

$ReceModel = $host.ui.PromptForChoice("<レセコン機種選択>","レセコンを選んで下さい",$Choice2,0)
if($ReceModel -eq $false){
    #   ORCA、それ以外
    Write-Output "「ORCA、それ以外」を選択しました。"
    $CryptPass = "ONSacrosmcM3"
}else{
    #   富士製品(Hi-SEED、Pharma-SEED)
    Write-Output "「富士製品(Hi-SEED、Pharma-SEED)」を選択しました。"
    $CryptPass = "ons17220010"
}

#   OQS_CRYPT_PASS
$Result = cmdkey /list:oqs_crypt_pass
if(($Result -contains '* NONE *') -or ($Result -contains '* なし *')){
    #   資格情報なし、追加
    write-host "「OQS_CRYPT_PASS」が存在しません、作成します【Fix】"
    cmdkey /generic:OQS_CRYPT_PASS /user:OQS_Admin /pass:$CryptPass
}else{
    $Answer = $host.ui.PromptForChoice("「OQS_CRYPT_PASS」は存在します。","上書きしますか？",$Choice,1)
    if(-not $Answer){
        write-host "「OQS_CRYPT_PASS」を上書きします。"
        cmdkey /generic:OQS_CRYPT_PASS /user:OQS_Admin /pass:$CryptPass
    }else{
        write-host "「OQS_CRYPT_PASS」はそのままです。"
    }
}

#   OQS_LOGIN_KEY
$Result = cmdkey /list:oqs_login_key
if(($Result -contains '* NONE *') -or ($Result -contains '* なし *')){
    #   資格情報なし、追加
    write-host "「OQS_LOGIN_KEY」が存在しません、作成します【Fix】"
    cmdkey /generic:OQS_LOGIN_KEY /user:R0
}
else{
    write-host "「OQS_LOGIN_KEY」 は存在します。"
}

#   OQS_MEDICAL_INSTITUTION_CODE
$Result = cmdkey /list:oqs_medical_institution_code
if(($Result -contains '* NONE *') -or ($Result -contains '* なし *')){
    #   資格情報なし、追加
    write-host "「OQS_MEDICAL_INSTITUTION_CODE」が存在しません、作成します【Fix】"   
    cmdkey /generic:OQS_MEDICAL_INSTITUTION_CODE /user:OQS_Admin
}
else{
    write-host "「OQS_MEDICAL_INSTITUTION_CODE」は存在します。"
}

#   OQS_NAS_LOGIN_KEY
$Result = cmdkey /list:oqs_nas_login_key
if(($Result -contains '* NONE *') -or ($Result -contains '* なし *')){
    #   資格情報なし、追加
    write-host "「OQS_NAS_LOGIN_KEY」が存在しません、作成します【Fix】"
    cmdkey /generic:OQS_NAS_LOGIN_KEY /user:ONSRenkei /pass:$Pass
}else{
    $Answer = $host.ui.PromptForChoice("「OQS_NAS_LOGIN_KEY」は存在します。","上書きしますか？",$Choice,1)
    if(-not $Answer){
        write-host "「OQS_NAS_LOGIN_KEY」を上書きします。"
        cmdkey /generic:OQS_NAS_LOGIN_KEY /user:ONSRenkei /pass:$Pass
    }else{
        write-host "「OQS_NAS_LOGIN_KEY」はそのままです。"
    }
}

#
#   暗号化識別ファイルの設定
#

$TargetFilePath = "C:\ProgramData\OQS\OQSComApp\config"
$TargetFileName = "encrypt.conf","encrypt_face.conf"
$TargetSettingName = "連携AP","顔認証DLL"
$EncryptMode = $false,$false

write-output "--"
Write-Output "暗号化識別ファイルの設定を確認します。"

foreach($CheckTSN in $TargetSettingName){

    Write-Output ($CheckTSN + "の暗号化識別ファイルを確認します。")

        #   ファイルチェック
    if ((Test-Path ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)])) -eq $false){

        write-output ($TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)] + "が存在しません。【エラー】")

    }else{

        #   設定を確認
        $UserDefinitionProperty = Get-Content -Encoding Default ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)])

        if($UserDefinitionProperty.Count -ne 1){
            $CheckEncrypt = $UserDefinitionProperty[0] -split("=")
        }else{
            $CheckEncrypt = $UserDefinitionProperty -split("=")
        }
        if(($CheckEncrypt[1] -eq "e") -or ($CheckEncrypt[1] -eq "E")) {
            #   暗号化
            $EncryptMode[[array]::indexof($TargetSettingName,$CheckTSN)] = "暗号化設定"
        }else{
            #   非暗号化
            $EncryptMode[[array]::indexof($TargetSettingName,$CheckTSN)] = "暗号化設定されていません"
        }
        Write-Output ($CheckTSN + "：" + $EncryptMode[[array]::indexof($TargetSettingName,$CheckTSN)])
    }
}

$Answer = $host.ui.PromptForChoice("<暗号化設定確認>","暗号化を設定しますか？",$Choice3,2)

switch($Answer){
    0 {
        #   暗号化する
        Write-Output "暗号化識別ファイルを設定します（暗号化オン）"
        $SetChr = "e"
    }
    1 {
        #   暗号化しない
        Write-Output "暗号化識別ファイルを設定します（暗号化オフ）"
        $SetChr = "n"
    }
    default{
        #   スキップ（変更しない）
        Write-Output "暗号化識別ファイルを変更しません（スキップ）"
        $SetChr = $null
    }
}

if($SetChr -ne $null){
    foreach($CheckTSN in $TargetSettingName){

        #   ファイルチェック
        if ((Test-Path ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)])) -eq $false){
            write-output ($TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)] + "が存在しません。【エラー】")
        }else{
            #   ファイル読み込み
            $UserDefinitionProperty = Get-Content -Encoding Default ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)])
    
            foreach($Str_Target in $UserDefinitionProperty){
                $Chk_Encrypt = $Str_Target -split("=")
                if ($Chk_Encrypt.count -eq 2){
                    $Chk_Encrypt[1] = $SetChr
                    if($UserDefinitionProperty.Count -ne 1){
                        $UserDefinitionProperty[[array]::indexof($UserDefinitionProperty,$Str_Target)]=$Chk_Encrypt -join ("=")
                    }else{
                        $UserDefinitionProperty = $Chk_Encrypt -join ("=")
                    }     
                }else{
                    write-output ($TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)] + "の読み込み異常です。【エラー】")
                }
            }
            #   ファイル書き出し
            Set-Content ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)]) $UserDefinitionProperty -Encoding Default
    
            if(-not $Answer){
                #   暗号化する
                Write-Output ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)] + "を暗号化オンに設定しました。")
            }else{
                #   暗号化しない
                Write-Output ($TargetFilePath + '\' + $TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)] + "を暗号化オフに設定しました。")
            }
            
        }    
    }

    write-output "--"
    Write-Output "連携アプリケーションを再起動します。"

    $OQSComAppToolFolder = "C:\Program Files\OQS\OQSComApp\tools"
    $OQSComAppToolFile = $OQSComAppToolFolder + "\OQSComAppRestart.bat"

    if(test-path $OQSComAppToolFolder){
    
        Start-Process -filepath ($OQSComAppToolFile) -Wait

        Write-Output "連携アプリケーションを再起動しました。"

    }else{

        write-output "連携アプリケーション(OQSComApp)がインストールされていません。【エラー】"

    }

}


Read-Host 終了しました。画面を閉じるには何かキーを押してください…
exit


