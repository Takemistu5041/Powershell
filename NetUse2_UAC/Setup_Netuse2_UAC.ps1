#Set-ExecutionPolicy -Scope Process RemoteSigned

#
#   �߂��ƗpNW�h���C�u�ݒ�  Setup_NetUse2_UAC.ps1�@
#
#   Copyright 2021 By T.Tanaka
#
#   ���[�U�����ƊǗ��Ҍ����Ńl�b�g���[�N�h���C�u���쐬
#
#   ���[�U�����F�X�^�[�g�A�b�v�ɃV���[�g�J�b�g���쐬
#   �Ǘ��Ҍ����F�^�X�N���Ǘ��Ҍ����Ŏ��s
#   ���s����͓̂����X�N���v�g(VBS)�Ȃ̂Ńh���C�u��IP�A�h���X�̐ݒ�͈��OK�ł��B
#
#	��UAC�Ł@�^�X�N�ŊǗ��Ҍ����ł͂Ȃ��A�X�N���v�g���ŊǗ��Ҍ����ݒ�(UAC��ʂ��o�܂�)
#

#   �Ǘ��Ҍ���
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    #Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    Start-Process powershell.exe " -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs

    exit
}

#   �t�H�[���p�錾
Add-Type -Assembly System.Windows.Forms

#   �G���[�N���A
$error.Clear()


#   �V���[�g�J�b�g(StartUp)  �̍쐬

$WsShell = New-Object -ComObject WScript.Shell
$SCName = [Environment]::GetFolderPath('Startup') + "\Netuse2_ONS.lnk"
$CreateSC = $true

if (Test-Path($SCName)){
    #   �㏑���m�F
    $OverWrite = [System.Windows.Forms.MessageBox]::Show("(StartUp)`r`n�V���[�g�J�b�g�����ɑ��݂��܂��B`r`n�㏑�����܂����H","�㏑���m�F",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($OverWrite -eq "NO"){
        $CreateSC = $false
    }
}
if($CreateSC){
    #   �X�^�[�g�A�b�v�V���[�g�J�b�g�쐬
    $Shortcut = $WsShell.CreateShortcut($SCName)
    $Shortcut.TargetPath = "C:\CMS\Netuse2_ONS\Netuse2_ONS.bat"
    $Shortcut.IconLocation = "C:\CMS\Netuse2_ONS\Netuse2_ONS.bat"
    $Shortcut.WindowStyle = 7 #3 =Maximized 7=Minimized 4=Normal
    $Shortcut.WorkingDirectory = "C:\CMS\Netuse2_ONS"
    $Shortcut.Save()
     
}


#   �V���[�g�J�b�g�̍쐬(Desktop-User)

$WsShell2 = New-Object -ComObject WScript.Shell
$SCName2 = [Environment]::GetFolderPath('Desktop') + "\�I�����[���Đڑ�.lnk"
$CreateSC2 = $true

if (Test-Path($SCName2)){
    #   �㏑���m�F
    $OverWrite2 = [System.Windows.Forms.MessageBox]::Show("(Desktop_User)`r`n�V���[�g�J�b�g�����ɑ��݂��܂��B`r`n�㏑�����܂����H","�㏑���m�F",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($OverWrite2 -eq "NO"){
        $CreateSC2 = $false
    }
}
if($CreateSC2){
    #   �f�X�N�g�b�v�V���[�g�J�b�g�쐬(User)
    $Shortcut2 = $WsShell.CreateShortcut($SCName2)
    $Shortcut2.TargetPath = "C:\CMS\Netuse2_ONS\Netuse2_ONS.bat"
    $Shortcut2.IconLocation = "C:\CMS\Netuse2_ONS\Netuse2_ONS.ico"
    $Shortcut2.WindowStyle = 7 #3 =Maximized 7=Minimized 4=Normal
    $Shortcut2.WorkingDirectory = "C:\CMS\Netuse2_ONS"
    $Shortcut2.Save()
     
}

#   �V���[�g�J�b�g�̍쐬(Desktop-Admin)

$WsShell2 = New-Object -ComObject WScript.Shell
$SCName2 = [Environment]::GetFolderPath('Desktop') + "\�I�����[���Đڑ�(Admin).lnk"
$CreateSC2 = $true

if (Test-Path($SCName2)){
    #   �㏑���m�F
    $OverWrite2 = [System.Windows.Forms.MessageBox]::Show("(Desktop_Admin)`r`n�V���[�g�J�b�g�����ɑ��݂��܂��B`r`n�㏑�����܂����H","�㏑���m�F",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($OverWrite2 -eq "NO"){
        $CreateSC2 = $false
    }
}
if($CreateSC2){
    #   �f�X�N�g�b�v�V���[�g�J�b�g�쐬(Admin)
    $Shortcut2 = $WsShell.CreateShortcut($SCName2)
    $Shortcut2.TargetPath = "C:\CMS\Netuse2_ONS\Netuse2_UAC.bat"
    $Shortcut2.IconLocation = "C:\CMS\Netuse2_ONS\Netuse2_ONS.ico"
    $Shortcut2.WindowStyle = 7 #3 =Maximized 7=Minimized 4=Normal
    $Shortcut2.WorkingDirectory = "C:\CMS\Netuse2_ONS"
    $Shortcut2.Save()
     
}

#   �^�X�N�̍쐬

$TargetTaskName ='NetUse2_ONS'
$RunUser = HOSTNAME
$RunUser += '\' + $env:USERNAME

$CreateTask = $true

#   �^�X�N�擾(NetUse2-ONS)

if ((Get-ScheduledTask | where TaskName -like "$TargetTaskName*" | select *) -ne $null){
  
    #   �㏑���m�F
    $OverWrite = [System.Windows.Forms.MessageBox]::Show("�����̃^�X�N�����ɑ��݂��܂��B`r`n�㏑�����܂����H","�㏑���m�F",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($OverWrite -eq "NO"){
        $CreateSC = $false
    }
}
if ($CreateTask){
    #   �^�X�N�쐬
    $Action = New-ScheduledTaskAction -Execute 'cscript' -Argument '//nologo netuse2_UAC.vbs' -WorkingDirectory 'C:\CMS\Netuse2_ONS'

    $Trigger = New-ScheduledTaskTrigger -AtLogOn
        $Trigger.delay = 'PT1M'

    #$Setting = New-ScheduledTaskSettingsSet 

    #$TaskPrincipal= New-ScheduledTaskPrincipal -UserID $RunUser -RunLevel Highest 
    $TaskPrincipal= New-ScheduledTaskPrincipal -UserID $RunUser 

    #   �^�X�N�o�^
    Register-ScheduledTask -TaskPath \ -TaskName $TargetTaskName -Action $Action -Trigger $Trigger -Principal $TaskPrincipal -Force

}

if($Error.count -eq 0){

    [System.Windows.Forms.MessageBox]::Show("�ݒ肪�������܂���", "NetUse2_ONS(�߂��Ƒ�)")

}
else
{
    [System.Windows.Forms.MessageBox]::Show("�G���[���m�F���Ă�������", "�G���[")
    Write-Host $error
}
