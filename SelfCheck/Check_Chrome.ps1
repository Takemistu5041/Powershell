#
#   Chrome周り 設定チェック
#
#   Copyright2021 By T.Tanaka
#

#   2022/11/30  Defender拡張機能サポート終了の為インストールではなく削除するように
#   2022/10/18  Appdataもインストールフォルダとしてチェックを追加

#   引数
Param( [bool]$Child = $False)

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
#   デフォルトブラウザ確認
#

write-output "--"

$Chrome32 = $False
$Chrome_Path = ""
$Chrome_Path32 ="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
$Chrome_Path64 ="C:\Program Files\Google\Chrome\Application\chrome.exe"
$Chrome_PathUser = $env:USERPROFILE + "\AppData\Local\Google\Chrome\Application\chrome.exe"

#   Chromeのインストール確認

if(-not (Test-Path($Chrome_Path64))){
    if(-not (Test-Path($Chrome_Path32))){
        if(-not (Test-Path($Chrome_PathUser))){
            Read-Host "Chromeがインストールされていません。`r`n何かキーを押してください。"
            exit
        }else{
            write-output $Chrome_PathUser
            $Chrome_Path = $Chrome_PathUser
        }
    }else{
        Write-Output $Chrome_Path32
        $Chrome_Path = $Chrome_Path32
        $Chrome32 = $true
    }
}else{
    Write-Output $Chrome_Path64
    $Chrome_Path = $Chrome_Path64
}

#   デフォルトブラウザ


$RegCheck = Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Associations\URLAssociations\http\UserChoice" -Name ProgId
$ProgID = $RegCheck.Progid
        
Write-Output "デフォルトブラウザを確認します。"

if(-not($ProgID.StartsWith("ChromeHTML"))){
    Write-Output ("`tデフォルトブラウザはChromeではありません。(" + $ProgID +")【要確認】")

    $Answer = $host.ui.PromptForChoice("<デフォルトブラウザ変更確認>","デフォルトブラウザをChromeに変更しますか？",$Choice,1)
    if(-not $Answer){

        #   Chrome起動確認(起動していると大量のウィンドウが開いてしまうため)
        do{
            if((Get-Process | Where-Object ProcessName -match "chrome").count -eq 0){
                break;
            }else{
                write-output "--"
                Write-Output "【Chromeが起動されています。】"
                Read-Host Chromeを閉じて何かキーを押してください…
            }
        }while($true)

        do{
            Write-Output "`tChromeを起動します。デフォルトブラウザに設定してChromeを閉じて下さい。"
                Start-Process -FilePath $Chrome_Path -ArgumentList 'https://support.google.com/chrome/answer/95417?hl=ja' -wait

            #   再チェック
            $RegCheck = Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Shell\Associations\URLAssociations\http\UserChoice" -Name ProgId
            $ProgID = $RegCheck.Progid
        }while ($ProgID -ne "ChromeHTML")
    }
} 

Write-Output ("`tデフォルトブラウザは「" + $ProgID + "」です。" )


#
#   通知ブロック設定
#

write-output "--"

$RegKey = "HKLM:\SOFTWARE\Policies\Google\Chrome\NotificationsBlockedForUrls"

do{
    Write-Output "通知ブロック設定を確認します。"

    if(-not (test-path($RegKey))){
        Write-Output "`t通知ブロックが設定されていません。【エラー】"

        $BST = Get-ChildItem -path $PSScriptRoot -file | Where-Object name -match 'browser_setting_Tools'

        if($BST.count -eq 0){
            Write-Output "`t通知ブロック設定ツールが見つかりません。手動で起動・設定して下さい。【エラー】"
            break;
        }else{
            Write-Output "`t通知ブロック設定ツールを起動します。"
            Start-Process -FilePath ($PSScriptRoot + "\" + $BST.Name) -wait
        }
    }

}while(-not(Test-Path($RegKey)))

if(test-path($RegKey)){
    Write-Output "`t通知ブロックが設定されています。"
}


#
#   拡張機能
#

write-output "--"

$RegKey = "HKCU:\SOFTWARE\Google\Chrome\PreferenceMACs\Default\extensions.settings"

do{
    Write-Output "ブラウザ拡張機能を確認します。（誤検出される場合はChromeを再起動してみて下さい。)"

    $ChkReg = Get-ItemProperty -path $RegKey

    if($ChkReg -match "bkbeeeffjjeopflfhgeknacdieedcoml"){
        Write-Output "`tMicrosoft Defender Browser Protection がインストールされています。【エラー】"
        Write-Output "`tChromeを起動します。Defender拡張機能をアンインストールしてChromeを閉じて下さい。"
        Write-Output "`t削除できない場合はそのままChromeを閉じて下さい。"

        if($Chrome32){
            Start-Process -FilePath $Chrome_Path32 -ArgumentList 'https://chrome.google.com/webstore/detail/microsoft-defender-browse/bkbeeeffjjeopflfhgeknacdieedcoml/related?hl=ja' -wait
        }else{
            Start-Process -FilePath $Chrome_Path64 -ArgumentList 'https://chrome.google.com/webstore/detail/microsoft-defender-browse/bkbeeeffjjeopflfhgeknacdieedcoml/related?hl=ja' -wait
        }
    }

    #
    #   レジストリで登録されていた場合
    #
    write-output "--"
    Write-Output "レジストリ設定を確認します。"
    
    $RegPath = "HKLM:\SOFTWARE\Policies\Google\Chrome"
    $TargetID = 'bkbeeeffjjeopflfhgeknacdieedcoml'
    $RegCheckParameter = '{"bkbeeeffjjeopflfhgeknacdieedcoml": {"installation_mode": "normal_installed","update_url":"https://clients2.google.com/service/update2/crx"}}'
    
    if(test-path($RegPath)){
        $ChkReg = Get-ItemProperty -path $RegPath
        if($null -eq $ChkReg.ExtensionSettings){
            Write-Output ("レジストリエントリ(ExtensionSettings) が見つかりません。")
        }else{
            if ( ($ChkReg.ExtensionSettings -match $TargetID)){
                Write-Output ("`t「ExtensionSettings」を修正します。【Fix】")
                if(($ChkReg.ExtensionSettings -match ($RegCheckParameter + ","))){
                    $FixValue = $ChkReg.ExtensionSettings -replace $RegCheckParameter + ",",""
                }else{
                    $FixValue = $ChkReg.ExtensionSettings -replace $RegCheckParameter ,""
                }
                Set-ItemProperty -path $RegPath -name ExtensionSettings -value $FixValue
            }else{
                Write-Output ("`t「ExtensionSettings」には設定されていません。")
            }
        }
    }else{
        Write-Output ("レジストリエントリ" + $RegPath + "がありません。") 
    }
    

}while ($ChkReg -match "bkbeeeffjjeopflfhgeknacdieedcoml")

Write-Output "`tMicrosoft Defender Browser Protection はインストールされていません。"

#   処理終了

if(-not $Child){
    write-output "--"
    Write-Output "処理は終了しました。"
    Read-Host 画面を閉じるには何かキーを押してください…
}

exit
