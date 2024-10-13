#Set-ExecutionPolicy -Scope Process RemoteSigned

#   バグ？回避用（変なエラーが$errorに入ってしまう）
function __Invoke-ReadLineForEditorServices {""}

#
#   ダウンロードフォルダ内のPDFファイル削除(オン資端末)  Setup-DeletePDF.ps1　
#
#   Copyright 2023 By T.Tanaka
#
#   ログイン時にダウンロードフォルダ内のPDFファイルを削除するタスク(DeletePDF)を作成
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

#   「DeletePDF」タスクの作成

$TargetTaskName ='DeletePDF'
$RunUser = HOSTNAME
$RunUser += '\' + $env:USERNAME

$CreateTask = $true

#   タスク取得

if ((Get-ScheduledTask | where TaskName -like "$TargetTaskName*" | select *) -ne $null){
  
    #   上書き確認
    $OverWrite = [System.Windows.Forms.MessageBox]::Show("同名のタスクが既に存在します。`r`n上書きしますか？","上書き確認",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($OverWrite -eq "NO"){
        $CreateSC = $false
    }
}
if ($CreateTask){
    #   タスク作成
    $Action = New-ScheduledTaskAction -Execute "powershell" -Argument "remove-item $env:Userprofile\downloads\*.pdf"  

    $Trigger = New-ScheduledTaskTrigger -AtLogOn
        $Trigger.delay = 'PT30S'

    #$Setting = New-ScheduledTaskSettingsSet 

    $TaskPrincipal= New-ScheduledTaskPrincipal -UserID $RunUser -RunLevel Limited 

    #   タスク登録
    Register-ScheduledTask -TaskPath \ -TaskName $TargetTaskName -Action $Action -Trigger $Trigger -Principal $TaskPrincipal -Force

}

if($Error.count -eq 0){

    [System.Windows.Forms.MessageBox]::Show("設定が完了しました", "PDFファイル削除(オン資端末)")

}
else
{
    [System.Windows.Forms.MessageBox]::Show("エラーを確認してください", "エラー")
    Write-Host $error
}
