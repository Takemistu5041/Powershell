#Set-ExecutionPolicy -Scope Process RemoteSigned

#
#   めいと用NWドライブ設定  Setup-NetUse2.ps1　
#
#   Copyright 2021 By T.Tanaka
#
#   ユーザ権限でネットワークドライブを作成
#
#   ユーザ権限：スタートアップにショートカットを作成
#   (管理者権限：タスクを管理者権限で実行)->中止
#   実行するのは同じスクリプト(VBS)なのでドライブやIPアドレスの設定は一つでOKです。
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


#   ショートカットの作成(StartUp)

$WsShell = New-Object -ComObject WScript.Shell
$SCName = [Environment]::GetFolderPath('Startup') + "\Netuse2_ONS.lnk"
$CreateSC = $true

if (Test-Path($SCName)){
    #   上書き確認
    $OverWrite = [System.Windows.Forms.MessageBox]::Show("(Startup)`r`nショートカットが既に存在します。`r`n上書きしますか？","上書き確認",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($OverWrite -eq "NO"){
        $CreateSC = $false
    }
}
if($CreateSC){
    #   スタートアップショートカット作成
    $Shortcut = $WsShell.CreateShortcut($SCName)
    $Shortcut.TargetPath = "C:\CMS\Netuse2_ONS\Netuse2_ONS.bat"
    $Shortcut.IconLocation = "C:\CMS\Netuse2_ONS\Netuse2_ONS.bat"
    $Shortcut.WindowStyle = 7 #3 =Maximized 7=Minimized 4=Normal
    $Shortcut.WorkingDirectory = "C:\CMS\Netuse2_ONS"
    $Shortcut.Save()
     
}

#   ショートカットの作成(Desktop-User)

$WsShell2 = New-Object -ComObject WScript.Shell
$SCName2 = [Environment]::GetFolderPath('Desktop') + "\オン資端末再接続.lnk"
$CreateSC2 = $true

if (Test-Path($SCName2)){
    #   上書き確認
    $OverWrite2 = [System.Windows.Forms.MessageBox]::Show("(Desktop_User)`r`nショートカットが既に存在します。`r`n上書きしますか？","上書き確認",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($OverWrite2 -eq "NO"){
        $CreateSC2 = $false
    }
}
if($CreateSC2){
    #   デスクトップショートカット作成(User)
    $Shortcut2 = $WsShell.CreateShortcut($SCName2)
    $Shortcut2.TargetPath = "C:\CMS\Netuse2_ONS\Netuse2_ONS.bat"
    $Shortcut2.IconLocation = "C:\CMS\Netuse2_ONS\Netuse2_ONS.ico"
    $Shortcut2.WindowStyle = 7 #3 =Maximized 7=Minimized 4=Normal
    $Shortcut2.WorkingDirectory = "C:\CMS\Netuse2_ONS"
    $Shortcut2.Save()
     
}

#   ショートカットの作成(Desktop-Admin)

$WsShell2 = New-Object -ComObject WScript.Shell
$SCName2 = [Environment]::GetFolderPath('Desktop') + "\オン資端末再接続(Admin).lnk"
$CreateSC2 = $true

if (Test-Path($SCName2)){
    #   上書き確認
    $OverWrite2 = [System.Windows.Forms.MessageBox]::Show("(Desktop_Admin)`r`nショートカットが既に存在します。`r`n上書きしますか？","上書き確認",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($OverWrite2 -eq "NO"){
        $CreateSC2 = $false
    }
}
if($CreateSC2){
    #   デスクトップショートカット作成(Admin)
    $Shortcut2 = $WsShell.CreateShortcut($SCName2)
    $Shortcut2.TargetPath = "C:\CMS\Netuse2_ONS\Netuse2_ONS_UAC.bat"
    $Shortcut2.IconLocation = "C:\CMS\Netuse2_ONS\Netuse2_ONS.ico"
    $Shortcut2.WindowStyle = 7 #3 =Maximized 7=Minimized 4=Normal
    $Shortcut2.WorkingDirectory = "C:\CMS\Netuse2_ONS"
    $Shortcut2.Save()
     
}

#   タスクの作成

#$TargetTaskName ='NetUse2_ONS'
#$RunUser = HOSTNAME
#$RunUser += '\' + $env:USERNAME

#$CreateTask = $true

#   タスク取得(NetUse2-ONS)

#if ((Get-ScheduledTask | where TaskName -like "$TargetTaskName*" | select *) -ne $null){
  
    #   上書き確認
#    $OverWrite = [System.Windows.Forms.MessageBox]::Show("同名のタスクが既に存在します。`r`n上書きしますか？","上書き確認",[System.Windows.Forms.MessageBoxButtons]::YesNo)

#    if($OverWrite -eq "NO"){
#        $CreateSC = $false
#    }
#}
#if ($CreateTask){
    #   タスク作成
#    $Action = New-ScheduledTaskAction -Execute 'cscript' -Argument '//nologo netuse2_ONS.vbs' -WorkingDirectory 'C:\CMS\Netuse2_ONS'

#    $Trigger = New-ScheduledTaskTrigger -AtLogOn
#        $Trigger.delay = 'PT5M'

    #$Setting = New-ScheduledTaskSettingsSet 

#    $TaskPrincipal= New-ScheduledTaskPrincipal -UserID $RunUser -RunLevel Highest 

    #   タスク登録
#    Register-ScheduledTask -TaskPath \ -TaskName $TargetTaskName -Action $Action -Trigger $Trigger -Principal $TaskPrincipal -Force

#}

if($Error.count -eq 0){

    [System.Windows.Forms.MessageBox]::Show("設定が完了しました", "NetUse2_ONS(めいと側)")

}
else
{
    [System.Windows.Forms.MessageBox]::Show("エラーを確認してください", "エラー")
    Write-Host $error
}
