#
#   ONS_Reconfig_Encrypt（オン資端末　暗号化再設定）
#
#   Copyright 2023 By T.Tanaka
#
#
#   2023/3/1    初版
#               encrypt.conf    "EPS","OQSmutic","OQSmuhvq","OQSmuonq","OQSsihvq","OQSsionq","OQSsihvd","OQSsiurl","OQSsiinq","OQSsiupd","PMHsimsm"
#                               で始まる行は暗号化にかかわらず「n」
#
#               encrypt_face.conf   "prescription","publicmedicalhub" で始まる行は暗号化にかかわらず「n」
#
#
#   

#   ログインユーザチェック

$User = whoami.exe

$Check_User = $User.split("\")

if((($Check_User[$Check_User.count -1]).ToUpper()) -ne "OQSCOMAPP"){
    Read-Host "OQSComAppアカウントでログインして下さい。`r`n何かキーを押してください。"
    exit
}


#   管理者権限チェック
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    #Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    Start-Process powershell.exe " -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs;

    exit
}


#
#   【関数】    Send-keys
#
function Send-Keys
{
    [CmdletBinding()]
    [Alias("sdky")]
    Param
    (
        # キーストローク
        # アプリケーションに送りたいキーストローク内容を指定します。
        # キーストロークの記述方法は下記のWebページを参照。
        # https://msdn.microsoft.com/ja-jp/library/cc364423.aspx
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]
        $KeyStroke,

        # プロセス名
        # キーストロークを送りたいアプリケーションのプロセス名を指定します。
        # 複数ある場合は、PIDが一番低いプロセスを対象とする。
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProcessName,

        # 待機時間
        # コマンドを実行する前の待機時間をミリ秒単位で指定します。
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
        [int]
        $Wait = 0
    )

    Process
    {
        $Process = Get-Process | Where-Object {$_.Name -eq $ProcessName} | Sort-Object -Property CPU -Descending | Select-Object -First 1
        Write-Verbose $Process", KeyStroke = "$KeyStroke", Wait = "$Wait" ms."
        Start-Sleep -Milliseconds $Wait
        if ($null -ne $Process)
        {
            [Microsoft.VisualBasic.Interaction]::AppActivate($Process.ID)
        }
        [System.Windows.Forms.SendKeys]::SendWait($KeyStroke)
    }
}

#
#   【関数】ローカルユーザが存在するか
#
function IsLocalUserAccunt( $UserID ){
    $hostname = hostname
    [ADSI]$Computer = "WinNT://$hostname,computer"
    $Users = $Computer.psbase.children | Where-Object {$_.psBase.schemaClassName -eq "User"} | Select-Object -expand Name
    return ($Users -contains $UserID)
}
#
#   【関数】ローカルユーザがグループのメンバーになっているか
#
function IsMemberLocalAccunt( $UserID, $GroupName ){
    $hostname = hostname
    [ADSI]$Computer = "WinNT://$hostname,computer"
    $Group = $Computer.GetObject("group", $GroupName)
    $User = $Computer.GetObject("user", $UserID)
    return $Group.IsMember($User.ADsPath)
}

#   フォーム用宣言
Add-Type -Assembly System.Windows.Forms

#
#   選択肢の作成
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
$ExclusionParameter = "prescription","publicmedicalhub","EPS","OQSmutic","OQSmuhvq","OQSmuonq","OQSsihvq","OQSsionq","OQSsihvd","OQSsiurl","OQSsiinq","OQSsiupd","PMHsimsm"
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

if($null -ne $SetChr){
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
                    #   $ExclusionParameterで始まる行は「n」にする　(電子処方箋他)
                    foreach($Str_ChkExclusion in $ExclusionParameter){
                        if($Chk_Encrypt[0].Startswith($Str_ChkExclusion)){
                            $Chk_Encrypt[1] = "n"
                            break 
                        }
                        else{
                            $Chk_Encrypt[1] = $SetChr
                        }
                    }
                    if($UserDefinitionProperty.Count -ne 1){
                        $UserDefinitionProperty[[array]::indexof($UserDefinitionProperty,$Str_Target)]=$Chk_Encrypt -join ("=")
                    }else{
                        $UserDefinitionProperty = $Chk_Encrypt -join ("=")
                    }     
                }else{
                    if("" -ne $Chk_Encrypt){
                        write-output ($TargetFileName[[array]::indexof($TargetSettingName,$CheckTSN)] + "の読み込み異常です。【エラー】")
                    }
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


#
#   途中終了用
#
Read-Host 終了しました。画面を閉じるには何かキーを押してください…
exit


