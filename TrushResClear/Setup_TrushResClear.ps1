#Set-ExecutionPolicy -Scope Process RemoteSigned

#   バグ？回避用（変なエラーが$errorに入ってしまう）
function __Invoke-ReadLineForEditorServices {""}

#
#   オン資端末めいと向け設定  Setup-TrushResClear.ps1　
#
#   Copyright 2021 By T.Tanaka
#
#
#   デスクトップに「連携AP再起動」のショートカットを作成
#   結果データファイルの消し忘れ判定時間を1日(1440)に設定
#   ゴミ箱を空にして、古い「DELFILE」を削除するバッチ(TrashResClear.Bat)をログイン時に実行するタスクを作成
#
#

#   管理者権限
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    #Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    Start-Process powershell.exe " -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs

    exit
}

#   フォーム用宣言
Add-Type -Assembly System.Windows.Forms

#   エラークリア
$error.Clear()


#   「連携AP再起動」ショートカットの作成

$WsShell = New-Object -ComObject WScript.Shell
$SCName = [Environment]::GetFolderPath('Desktop') + "\連携AP再起動.lnk"
$CreateSC = $true

if (Test-Path($SCName)){
    #   上書き確認
    $OverWrite = [System.Windows.Forms.MessageBox]::Show("連携AP再起動のショートカットが既に存在します。`r`n上書きしますか？","上書き確認",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($OverWrite -eq "NO"){
        $CreateSC = $false
    }
}
if($CreateSC){
    #   デスクトップショートカット作成
    $Shortcut = $WsShell.CreateShortcut($SCName)
    $Shortcut.TargetPath = "C:\Program Files\OQS\OQSComApp\tools\OQSComAppRestart.bat"
    $Shortcut.IconLocation = "C:\Program Files\OQS\OQSComApp\tools\OQSComAppRestart.bat"
    $Shortcut.WindowStyle = 4 #3 =Maximized 7=Minimized 4=Normal
    $Shortcut.WorkingDirectory = "C:\Program Files\OQS\OQSComApp\tools"
    $Shortcut.Save()
     
}


#   エラークリア
$error.Clear()

#   結果データファイルの消し忘れ判定時間を1日(1440)に設定

$TargetFilePath = 'C:\ProgramData\OQS\OQSComApp\config'
$TargetFileName = 'UserDefinition.property'

#   ファイルチェック
if ((Test-Path ($TargetFilePath + '\' + $TargetFileName)) -eq $false){

    [System.Windows.Forms.MessageBox]::Show("$TargetFileName が存在しません", "エラー")
    exit;

}else{
    #   ResponseFileStayTime　を1日(1440)に設定

    $UserDefinitionProperty = Get-Content -Encoding Default ($TargetFilePath + '\' + $TargetFileName)

    foreach($Str_Target in $UserDefinitionProperty){
        switch -Wildcard ($Str_Target){
            "ResponseFileStayTime*"{
                $UserDefinitionProperty[$UserDefinitionProperty.IndexOf($Str_Target)] = "ResponseFileStayTime=1440"
                break;
            }
        }
    }

    Set-Content ($TargetFilePath + '\' + $TargetFileName) $UserDefinitionProperty -Encoding Default

}

if($Error.count -eq 0){

    #[System.Windows.Forms.MessageBox]::Show("消し忘れ設定が完了しました", "TrushResClear(オン資側)")

}
else
{
    [System.Windows.Forms.MessageBox]::Show("消し忘れ設定に失敗しました`r`nエラーを確認してください", "エラー")
    Write-Host $error
}


#   エラークリア
$error.Clear()

#   「ゴミ箱を空に」タスクの作成

$TargetTaskName ='ゴミ箱を空に'
$RunUser = HOSTNAME
$RunUser += '\' + $env:USERNAME

$CreateTask = $true

#   タスク取得(NetUse2-ONS)

if ((Get-ScheduledTask | where TaskName -like "$TargetTaskName*" | select *) -ne $null){
  
    #   上書き確認
    $OverWrite = [System.Windows.Forms.MessageBox]::Show("同名のタスクが既に存在します。`r`n上書きしますか？","上書き確認",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($OverWrite -eq "NO"){
        $CreateSC = $false
    }
}
if ($CreateTask){
    #   タスク作成
    $Action = New-ScheduledTaskAction -Execute 'C:\CMS\TrushResClear\TrushResClear.bat'  -WorkingDirectory 'c:\cms\TrushResClear'

    $Trigger = New-ScheduledTaskTrigger -AtLogOn
        $Trigger.delay = 'PT30S'

    #$Setting = New-ScheduledTaskSettingsSet 

    $TaskPrincipal= New-ScheduledTaskPrincipal -UserID $RunUser -RunLevel Limited 

    #   タスク登録
    Register-ScheduledTask -TaskPath \ -TaskName $TargetTaskName -Action $Action -Trigger $Trigger -Principal $TaskPrincipal -Force

}

if($Error.count -eq 0){

    [System.Windows.Forms.MessageBox]::Show("設定が完了しました", "めいと向け設定(オン資側)")

}
else
{
    [System.Windows.Forms.MessageBox]::Show("エラーを確認してください", "エラー")
    Write-Host $error
}
