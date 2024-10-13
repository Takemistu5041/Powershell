#Set-ExecutionPolicy -Scope Process RemoteSigned

#
#   タスク更新  ReconfigTask.ps1
#
#
#   Copyright 2021 By T.Tanaka
#

#   管理者権限
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    #Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    Start-Process powershell.exe " -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs

    exit
}


#
#   エラークリア
#
$error.Clear()

$DelFile_Fix = $false

# 
#   ユーザ名・パスワード
#

$User = whoami.exe
$SecPass = Read-Host "$User のパスワード" -AsSecureString

$BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecPass);
$Pass=[System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
#$Pass

#   タスク取得(OQS*)

$Tasks = (Get-ScheduledTask | where TaskName -like "OQS*" | select *)

foreach($TargetTask in $Tasks){



    #   Actions取得
    #$Action = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Actions
    $Action = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Actions

    #   Trigger取得
    #$Trigger = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Triggers
    $Trigger = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers

    #   Settings取得
    #$Setting = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Settings
    $Setting = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Settings

    #   Principal(SecurityOption)取得
    #$TaskPrincipal = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Principal

    switch($TargetTask.TaskName){
        "OQS_exec_distroappstart"
        {
            if ($Trigger.delay -ne "PT30S"){
                #write-host $Trigger
                #$NTrigger = New-ScheduledTaskTrigger -AtStartup -RepetitionInterval (New-TimeSpan -Hours 1) -RepetitionDuration ([System.TimeSpan]::MaxValue)
                $NTrigger = New-ScheduledTaskTrigger -AtStartup 
                #$NTrigger = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers
                $NTrigger.Delay = "PT30S"
                write-host "OQS_exec_distroappstart is no delay...Fix"
            }
            ;break
        }

        "OQS_exec_comappdelfile_running"
        {
            if ($Trigger.delay -ne "PT1M"){
                #write-host $Trigger
                $NTrigger = New-ScheduledTaskTrigger -AtStartup
                #$NTrigger = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers
                $NTrigger.Delay = "PT1M"
                write-host "OQS_exec_comappdelfile_running is no delay...Fix"
                $DelFile_Fix = $true
            }
            ;break   
        }
        default
        {
            $NTrigger = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers
            ;break
        }
    }



    #   タスク更新
    Register-ScheduledTask -TaskPath \ -TaskName $TargetTask.TaskName -Action $Action -Trigger $NTrigger -Settings $Setting -User $User -Password $Pass -Force


    if (($TargetTask.TaskName -eq "OQS_exec_distroappstart") -and ($DelFile_Fix -eq $true) ){
        $Schedule = (Get-ScheduledTask -TaskName $TargetTask.TaskName).Triggers
        $Schedule.Repetition.Interval = "PT1H"
        #$Schedule.Repetition.Duration = ([System.TimeSpan]::MaxValue)
        Set-ScheduledTask -Taskname $TargetTask.TaskName -Trigger $Schedule -User $User -Password $Pass
        write-host "OQS_exec_distroappstart Interval->PT1H Set."
    }


    if($Error.count -ne 0){
        Write-host "OQSComAppのパスワードが違います。再度実行してください。"
        exit 1
    }


}

    #   タスク取得(定刻に再起動)

$Tasks = (Get-ScheduledTask | where TaskName -eq "定刻に再起動" | select *)

foreach($TargetTask in $Tasks){

    #   Action取得
    $Action =(Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Actions

    #   Triger取得
    $Trigger =(Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Triggers

    #   Settings取得
    $Setting =(Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Settings

    #   Principal取得
    #$TascPrincipal = (Get-ScheduledTask | where TaskName -eq $TargetTask.TaskName).Principal
    #   -passwordで書き込めばセキュリティオプションは「ユーザがログオンしているかどうかにかかわらず…」になるっぽい

    #   タスク更新
    Register-ScheduledTask -TaskPath \ -TaskName $TargetTask.TaskName -Action $Action -Trigger $Trigger -Settings $Setting -User $User -Password $Pass -Force

}

#
#   終了
#
write-host "完了しました"
if($error -ne $null){
    write-host "エラーが発生しています。内容を確認してください。"
}
Read-Host "何かキーを押してください。"
