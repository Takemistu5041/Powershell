#
#   WindowsDefender 設定チェック
#
#   Copyright2021 By T.Tanaka
#

#   2023/12/05  除外プロセス追加「C:\JWinPrg\RPXStartV21.exe」「\\HMC-SVR\ph_seedas\JwinPrg\RPX_V21.exe」他
#   2023/11/29  除外プロセス追加(Pharma　Defender誤検出対応　「RPX_V21.exe」「JWM0101.exe」)
#   2022/10/20  除外プロセス追加(Pharma-SEED AS 対応)

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
$User = whoami.exe

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


#   PUA

write-output "--"
Write-Output "Defender設定(PUA)を確認します。"
$MPP = Get-MpPreference
if ($MPP.puaprotection -ne $true){
	set-mppreference -puaprotection enabled
	Write-Output "PUAが無効です。修正しました。【Fix】"
}else{
	Write-Output "PUAは有効です。"
}

#   サンプルの自動送信

write-output "--"
Write-Output "サンプルの自動送信を確認します。"
if ($MPP.SubmitSamplesConsent -eq 1){
	set-mppreference -SubmitSamplesConsent 0
	Write-Output "サンプルの自動送信がオンです。修正しました。【Fix】"
}else{
	Write-Output "サンプルの自動送信はオフです。"
}

#   Defender除外設定

write-output "--"
Write-Output "Defenderの除外設定を確認します。"
Write-Output "【現在の除外設定】"
write-output $MPP.ExclusionPath
write-output "--"
write-output $MPP.ExclusionProcess

$AddExclusionPath = "C:\Autex","C:\HiStory","C:\pagefile.sys","C:\Windows\System32\rundll32.exe","C:\Windows\System32\spoolsv.exe","C:\Program Files\Microsoft SQL Server","C:\Program Files(X86)\Microsoft SQL Server","C:\ProgramData\Hi-Bridge","C:\Dctnet","C:\Program Files\Ndw","C:\DocumentsAndUpdates","C:\DLUpdaterWorkFolder","D:\DocumentsAndUpdates","C:\BtrnApp","C:\JWinPrg","C:\HMCS","D:\PH_SEEDAS","D:\PH_SEEDAS\JWinPrg","K:\","K:\JWinPrg"
#$AddExclusionProcess = "D:\PH_SEEDAS\JWinPrg\JWPdfGet01.exe","K:\JWinPrg\JWPdfGet01.exe","JWPdfGet01.exe"
#2022/10/20 除外プロセス追加
$AddExclusionProcess = "D:\PH_SEEDAS\JWinPrg\JWPdfGet01.exe","K:\JWinPrg\JWPdfGet01.exe","JWPdfGet01.exe","D:\PH_SEEDAS\JWinPrg\JVIMFTPA.exe","D:\PH_SEEDAS\JWinPrg\JVIMFTPB.exe","K:\JWinPrg\JVIMFTPA.exe","K:\JWinPrg\JVIMFTPB.exe","JVIMFTPA.exe","JVIMFTPB.exe","D:\PH_SEEDAS\JWinPrg\JWM0101.exe","K:\JWinPrg\JWM0101.exe","JWM0101.exe","D:\PH_SEEDAS\JWinPrg\RPX_V21.exe","K:\JWinPrg\RPX_V21.exe","RPX_V21.exe","C:\JWinPrg\RPXStartV21.exe","\\HMC-SVR\ph_seedas\JwinPrg\RPX_V21.exe","\\HMC01\ph_seedas\JwinPrg\RPX_V21.exe","C:\JWinPrg\RPX_V21.exe"

if (($null -eq $mpp.exclusionpath) -or ($mpp.ExclusionPath.IndexOf($AddExclusionPath[-1]) -lt 0) -or ($mpp.ExclusionProcess.IndexOf($AddExclusionProcess[-1]) -lt 0)){

    write-output "--"
    Write-Output $AddExclusionPath[-1]
    write-output $AddExclusionProcess[-1]
    write-output ("Defenderの除外設定がされていないようです。")
    write-output ("「カルテ君Ⅱ」「Hi-Story」「Hi-SEED/Pharma-SEED」は除外設定が必要です。")
    $answer = $host.ui.PromptForChoice("<WindowsDefenderの除外設定確認>","Defenderの除外設定を追加しますか？",$Choice,1)
    if (-not $answer){
        foreach($AEP in $AddExclusionPath){
            if(($null -eq $MPP.Exclusionpath) -or ($MPP.ExclusionPath.IndexOf($AEP) -lt 0)){
                $MPP.ExclusionPath = $MPP.ExclusionPath + $AEP
                write-output ($AEP + "...Add")
            }else{
                write-output ($AEP + "...already")
            }
        }
        #   除外設定追加
        Set-MpPreference -ExclusionPath $mpp.ExclusionPath 
        Write-Output "Defenderの除外設定を追加しました。【Fix】"

        Write-Output "除外プロセスを確認します。"

        foreach($AEP in $AddExclusionProcess){
            if(($null -eq $MPP.exclusionprocess) -or ($MPP.ExclusionProcess.IndexOf($AEP) -lt 0)){
                $MPP.ExclusionProcess = $MPP.ExclusionProcess + $AEP
                write-output ($AEP + "...Add")
            }else{
                write-output ($AEP + "...already")
            }
        }

        #   除外設定追加
        Set-MpPreference -ExclusionProcess $mpp.ExclusionProcess 
        Write-Output "Defenderの除外設定（プロセス）を追加しました。【Fix】"


    }else{
        Write-Output "Defenderの除外設定は変更されていません。"
    }
}else{
    Write-Output "Defenderの除外設定は設定されているようです。"
}

#
#   タスクスケジューラ確認
#

write-output "--"

#
#   エラークリア
#
$error.Clear()


#   最初に設定済み
#$User = whoami.exe
#   パスワードは入力済み
#$SecPass = Read-Host "$User のパスワード" -AsSecureString

#   パスワードを平文にしておく(Register-Scheduledが平文でないとダメっぽい)
#$BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass);
#$Pass=[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

#   タスク取得

write-output "Windows Defender 更新タスクの設定を確認します。"
$Tasks = (Get-ScheduledTask | Where-Object TaskName -like "Windows Defender Update*" | Select-Object *)

if($tasks.count -ne 0){
    foreach($TargetTask in $Tasks){

        #
        #   初期化
        #
        $TaskText = $null
        $Action = $null
        #$Trigger = $null
        #$Setting = $null
        #$Schedule = $null
        $TaskFix = $false

        #   説明を確認
        if($TargetTask.Description -ne "Windows Defender 定義ファイル更新"){
            write-output "説明が「Windows Defender 定義ファイル更新」ではありません。【Fix】"
            $TaskFix = $true
        }

        #   Actions取得
        #$Action = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Actions
        $Action = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Actions
    
        #   Action確認

        if($action.execute -ne """C:\Program Files\Windows Defender\MpCmdRun.exe"""){
            Write-Output ("プログラム/スクリプト：" + $action.Execute)
            write-output "「プログラム/スクリプト」が異なります。【Fix】"
            $TaskFix = $true
        }

        if($action.Arguments -ne "-Signatureupdate"){
            Write-Output ("引数：" + $action.Arguments)
            write-output "「引数」が異なります。【Fix】"
            $TaskFix = $true
        }

        #   Trigger取得
        #$Trigger = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Triggers
        #$Trigger = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers
        $NTrigger = $null
        
        #   トリガー判定のためにエクスポートする
        $TaskText = Export-ScheduledTask -taskname $TargetTask.TaskName
        if($TaskText.IndexOf("LogonTrigger") -lt 0){
            #   「ログオン時」ではない
            write-output "トリガーが「ログオン時」ではありません。【Fix】"
            $TaskFix = $true
        }

        if($TaskText.indexof("<RunLevel>HighestAvailable</RunLevel>") -lt 0){
            #   「最上位の特権で実行する」ではない
            write-output "「最上位の特権で実行する」がチェックされていません。【Fix】"
            $TaskFix = $true
        }

        #   Settings取得
        #$Setting = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Settings
        #$Setting = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Settings
    
        #   Principal(SecurityOption)取得
        #$TaskPrincipal = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Principal
    
        
        if($TaskFix){
            #   タスク更新       -RunLevel highest   最上位の特権で実行する

            $Action = New-ScheduledTaskAction -execute """C:\Program Files\Windows Defender\MpCmdRun.exe""" -Argument "-Signatureupdate"
            $NTrigger = New-ScheduledTaskTrigger -AtLogOn 

            Register-ScheduledTask -TaskPath \ -TaskName $TargetTask.TaskName -Action $Action -Trigger $NTrigger -Description "Windows Defender 定義ファイル更新" -User $User -RunLevel Highest -Force
            Write-Output ("「" + $TargetTask.TaskName + "」を更新しました。")
        }else{
            write-output ("「" + $TargetTask.TaskName + "」は正しく設定されています。" )
        }
    }
    
}else{
    #   ない場合は作成する？
    write-output ("対象となるタスクが見つかりません。")

    write-output ("「ぶんぎょうめいと」「Hi-SEED/Pharma-SEED」等WindowsUpdateを停止している場合は更新タスク設定が必要です。")

    $answer = $host.ui.PromptForChoice("<WindowsDefender更新タスク作成確認>","Defender更新タスクを作成しますか？",$Choice,1)
    if (-not $answer){
        #   タスク作成
        $Action = New-ScheduledTaskAction -execute """C:\Program Files\Windows Defender\MpCmdRun.exe""" -Argument "-Signatureupdate"
        $NTrigger = New-ScheduledTaskTrigger -AtLogOn 

        Register-ScheduledTask -TaskPath \ -TaskName "Windows Defender Update" -Action $Action -Trigger $NTrigger -Description "Windows Defender 定義ファイル更新" -User $User -RunLevel Highest -Force
        Write-Output ("「WindowsDefender更新タスク」を作成しました。")
}


}
write-output "Defender更新タスクを確認しました。"

#
#   メンテナンス時刻の確認   
#
write-output "--"
Write-Output "メンテナンス時刻を確認します。"

$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance"

if(test-path($RegPath)){
    $ChkReg = Get-ItemProperty -path $RegPath
    if($null -eq $ChkReg.'Activation Boundary'){
        Write-Output ("`t自動メンテナンス時刻は、デフォルト値です。")
        Write-Output ("`t自動メンテナンス時刻を「14:00」に設定します。【Fix】")
        Set-ItemProperty -path $RegPath -name 'Activation Boundary' -value '2001-01-01T14:00:00'
    }else{
        Write-Output ("`t自動メンテナンス時刻は、" + (get-date($ChkReg.'Activation Boundary') -Format "HH:mm") + "です。")
    }
    if (($null -eq $ChkReg.WakeUp) -or ($ChkReg.WakeUp -eq 0)){
        Write-Output ("`t「スケジュールされたメンテナンスによるコンピュータのスリープを解除する」がオフです。【Fix】")
        Set-ItemProperty -path $RegPath -name WakeUp -value 1
    }else{
        Write-Output ("`t「スケジュールされたメンテナンスによるコンピュータのスリープを解除する」はオンです。")
    }
}else{
    Write-Output ("レジストリエントリ" + $RegPath + "がありません。【エラー】")
}


#   処理終了

if(-not $Child){
    write-output "--"
    Write-Output "処理は終了しました。"
    Read-Host 画面を閉じるには何かキーを押してください…
}

exit
