#
#   TeamViewer  設定チェック
#
#   Copyright 2021 By T.Tanaka
#
#   2022/2/18   ファイアウォール有効/無効のチェックを追加
#

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


write-output "--"
Write-Output "TeamViewerの設定を確認します。"

#
#   TV確認
#

$TVFilepath64 = "C:\Program Files\TeamViewer\TeamViewer.exe"
$TVFilePath32 = "C:\Program Files (x86)\TeamViewer\TeamViewer.exe"

$Fix = $False

if(-not (Test-Path($TVFilepath64))){
    if(-not (Test-Path($TVFilePath32))){
        Read-Host "TeamViewerがインストールされていません。`r`n何かキーを押してください。"
        exit
    }else{
        Write-Output $TVFilePath32
        $TV32 = $true
    }
}else{
    Write-Output $TVFilePath64
    $TV32 = $false
}

#   設定確認

if ($TV32){
    $TVRegPath = "HKLM:\SOFTWARE\WOW6432Node\TeamViewer"
}else{
    $TVRegPath = "HKLM:\SOFTWARE\TeamViewer"
}

if(-not (test-path($TVRegPath))){

    Write-Output ($TVRegPath + "が見つかりません。【エラー】")

}else{

    $TVReg = Get-ItemProperty($TVRegPath)

    #   ID
    $TVID = $TVReg.ClientID
    Write-Output ("TeamViewer-ID:" + $TVID)

    #   プロキシ設定

    Write-Output "・TeamViewerのプロキシ設定を確認します。"

    if($null -eq $TVReg.Proxy_Type){
        Set-ItemProperty -Path $TVRegPath -Name Proxy_Type -value 0
        Write-Output "`t「設定の自動検出」です。修正しました。【Fix】"
        $Fix = $true
    }else{
        if($TVReg.Proxy_Type -ne 0){
            Set-ItemProperty -Path $TVRegPath -Name Proxy_Type -value 0
            if($null -eq $TVReg.Proxy_IP ){
                Remove-ItemProperty -path $TVRegPath -Name Proxy_IP
            }
            Write-Output "`t「手動プロキシ」です。修正しました。【Fix】"
            $Fix = $true
        }else{
            Write-Output "`t「プロキシなし」です。"
        }
    }

    #   受信LAN接続

    Write-Output "・TeamViewerの受信LAN接続を確認します。"

    if($null -eq $TVReg.General_DirectLAN){
        #   非アクティブ化
        Set-ItemProperty -Path $TVRegPath -Name General_DirectLAN -value 1
        Write-Output "`t「非アクティブ化」です。修正しました。【Fix】"
        $Fix = $true
    }else{
        if($null -ne $TVReg.LanOnly){
            #   同意のみ
            Set-ItemProperty -Path $TVRegPath -Name General_DirectLAN -value 1
            Remove-ItemProperty -path $TVRegPath -Name LanOnly
            Write-Output "`t「同意のみ」です。修正しました。【Fix】"
            $Fix = $true
        }else{
            Write-Output "`t「同意」です。"
        }
    }

    #   受信LAN接続

    Write-Output "・パスワードのセキュリティレベルを確認します。"

    $SPS = $false   #   SecurityPasswordStrength
    if($null -eq $TVReg.Security_PasswordStrength){
        $SPS = $true
        Write-Output "`t「8文字」です。修正しました。【Fix】"
        $fix = $true
    }else{
        switch($TVReg.Security_PasswordStrength){
            1{
                $SPS = $true
                Write-Output "`t「6文字」です。修正しました。【Fix】"
                $fix = $true
            }
            
            2{
                $SPS = $true
                Write-Output "`t「10文字」です。修正しました。【Fix】"
                $Fix = $true
            }

            Default{
                Write-Output "`t「ランダムパスワードなし」です。"
            }
        }
    }

    if($SPS){
        Set-ItemProperty -Path $TVRegPath -Name Security_PasswordStrength -value 3
    }

    #   TVのシャットダウンを無効にする

    Write-Output "・詳細オプションを確認します。"

    if($null -eq $TVReg.Security_Disableshutdown){
        Set-ItemProperty -Path $TVRegPath -Name Security_Disableshutdown -value 1
        Write-Output "`t「TVのシャットダウンを無効にする」がオフです。修正しました。【Fix】"
        $Fix = $true
    }else{
        if($TVReg.Security_Disableshutdown -eq 0){
            Set-ItemProperty -Path $TVRegPath -Name Security_Disableshutdown -value 1
            Write-Output "`t「TVのシャットダウンを無効にする」がオフです。修正しました。【Fix】"
            $Fix = $true
        }else{
            Write-Output "`t「TVのシャットダウンを無効にする」はオンです。"
        }
    }
    
    #   TVのオプションの変更は管理者権限が必要

    if($null -eq $TVReg.Security_Adminrights){
        Set-ItemProperty -Path $TVRegPath -Name Security_Adminrights -value 1
        Write-Output "`t「TeamViewerのオプションの変更は管理者権限が必要」がオフです。修正しました。【Fix】"
        $Fix = $true
    }else{
        Write-Output "`t「TeamViewerのオプションの変更は管理者権限が必要」はオンです。"
    }

    #   パスワードオプション
    if($null -eq $TVReg.OptionsPasswordAES){
        if($null -eq $TVReg.OptionsPasswordHash){
            Write-Output "`t「パスワードオプション」が設定されていません。設定して下さい。【エラー】"
        }else{
            Write-Output "`t「パスワードオプション」は設定されています。"
        }
    }else{
        Write-Output "`t「パスワードオプション」は設定されています。"
    }

}

#   TV再起動

if($Fix){
    Write-Output "--"
    Write-Output "パラメータが修正されています。"
    $Answer = $host.ui.PromptForChoice("<TeamViewer再起動確認>","TeamViewerを再起動してよろしいですか？",$Choice,1)
    if(-not $Answer){
        #  TV再起動
        Restart-Service -name 'TeamViewer' -Force
    }else {
        Write-Output "変更は再起動されるまで反映されません。"
    }
}


#
#   FW設定確認
#

write-output "--"
write-output "Windowsファイアウォールの設定を確認します。"
$Check_FWSetting = Get-NetFirewallProfile

foreach($CHK_FW in $Check_FWSetting){
    Write-Output ("「" + $CHK_FW.Name + "」の設定を確認")

    if(-not $CHK_FW.Enabled){
        write-output "`tファイアウォールが無効です。【Fix】"
        #   有効化
        Set-NetFirewallProfile -Profile $CHK_FW.Name -Enabled True
        
    }else{
        write-output "`tファイアウォールは有効です。"
    }

}

#
#   TeamViewerのFW設定を確認
#

write-output "--"
write-output "ファイアウォールの許可設定を確認します。"

#   エラークリア
$error.Clear()

$Target_FW_Name = "Teamviewer"

foreach ($FWName in $Target_FW_Name) {
    Write-Output ("「" + $FWName + "」のファイアウオール設定を確認")
    $FWRules = (Get-NetFirewallRule | Where-Object DisplayName -like ($FWName + "*") | Select-Object *)
    foreach($TargetRule in $FWRules){
        #   有効チェック
        if ((($TargetRule.enabled -eq "False") -and ($TargetRule.Profile -ne "Domain"))) {
            Write-Output ("`t" + $TargetRule.DisplayName + "(" + $TargetRule.Profile + ")がオフです。【Fix】")
            Set-NetFirewallRule -displayname $TargetRule.displayname -enabled True
        }
    
        #   Private/Publicチェック
        #   TeamViewerで、PrivateやPublicだったら、Public,Privateに変更してしまう
        if (($FWName -eq "TeamViewer") -and (($TargetRule.Profile -eq "Private") -or ($TargetRule.Profile -eq "Public"))){
            Write-Output ("`t" + $TargetRule.DisplayName + "(" + $TargetRule.Profile + ")を「Private, Public」に修正します。【Fix】")
            Set-NetFirewallRule -displayname $TargetRule.displayname -profile Private, Public
        }
    }
}

if($error -ne $null){
    Write-Output "ＦＷ設定でエラーが発生しています。内容を確認してください。"
}


#   処理終了

if(-not $Child){
    write-output "--"
    Write-Output "処理は終了しました。"
    Read-Host 画面を閉じるには何かキーを押してください…
}

exit

