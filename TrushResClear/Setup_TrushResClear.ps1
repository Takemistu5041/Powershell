#Set-ExecutionPolicy -Scope Process RemoteSigned

#   �o�O�H���p�i�ςȃG���[��$error�ɓ����Ă��܂��j
function __Invoke-ReadLineForEditorServices {""}

#
#   �I�����[���߂��ƌ����ݒ�  Setup-TrushResClear.ps1�@
#
#   Copyright 2021 By T.Tanaka
#
#
#   �f�X�N�g�b�v�Ɂu�A�gAP�ċN���v�̃V���[�g�J�b�g���쐬
#   ���ʃf�[�^�t�@�C���̏����Y�ꔻ�莞�Ԃ�1��(1440)�ɐݒ�
#   �S�~������ɂ��āA�Â��uDELFILE�v���폜����o�b�`(TrashResClear.Bat)�����O�C�����Ɏ��s����^�X�N���쐬
#
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


#   �u�A�gAP�ċN���v�V���[�g�J�b�g�̍쐬

$WsShell = New-Object -ComObject WScript.Shell
$SCName = [Environment]::GetFolderPath('Desktop') + "\�A�gAP�ċN��.lnk"
$CreateSC = $true

if (Test-Path($SCName)){
    #   �㏑���m�F
    $OverWrite = [System.Windows.Forms.MessageBox]::Show("�A�gAP�ċN���̃V���[�g�J�b�g�����ɑ��݂��܂��B`r`n�㏑�����܂����H","�㏑���m�F",[System.Windows.Forms.MessageBoxButtons]::YesNo)

    if($OverWrite -eq "NO"){
        $CreateSC = $false
    }
}
if($CreateSC){
    #   �f�X�N�g�b�v�V���[�g�J�b�g�쐬
    $Shortcut = $WsShell.CreateShortcut($SCName)
    $Shortcut.TargetPath = "C:\Program Files\OQS\OQSComApp\tools\OQSComAppRestart.bat"
    $Shortcut.IconLocation = "C:\Program Files\OQS\OQSComApp\tools\OQSComAppRestart.bat"
    $Shortcut.WindowStyle = 4 #3 =Maximized 7=Minimized 4=Normal
    $Shortcut.WorkingDirectory = "C:\Program Files\OQS\OQSComApp\tools"
    $Shortcut.Save()
     
}


#   �G���[�N���A
$error.Clear()

#   ���ʃf�[�^�t�@�C���̏����Y�ꔻ�莞�Ԃ�1��(1440)�ɐݒ�

$TargetFilePath = 'C:\ProgramData\OQS\OQSComApp\config'
$TargetFileName = 'UserDefinition.property'

#   �t�@�C���`�F�b�N
if ((Test-Path ($TargetFilePath + '\' + $TargetFileName)) -eq $false){

    [System.Windows.Forms.MessageBox]::Show("$TargetFileName �����݂��܂���", "�G���[")
    exit;

}else{
    #   ResponseFileStayTime�@��1��(1440)�ɐݒ�

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

    #[System.Windows.Forms.MessageBox]::Show("�����Y��ݒ肪�������܂���", "TrushResClear(�I������)")

}
else
{
    [System.Windows.Forms.MessageBox]::Show("�����Y��ݒ�Ɏ��s���܂���`r`n�G���[���m�F���Ă�������", "�G���[")
    Write-Host $error
}


#   �G���[�N���A
$error.Clear()

#   �u�S�~������Ɂv�^�X�N�̍쐬

$TargetTaskName ='�S�~�������'
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
    $Action = New-ScheduledTaskAction -Execute 'C:\CMS\TrushResClear\TrushResClear.bat'  -WorkingDirectory 'c:\cms\TrushResClear'

    $Trigger = New-ScheduledTaskTrigger -AtLogOn
        $Trigger.delay = 'PT30S'

    #$Setting = New-ScheduledTaskSettingsSet 

    $TaskPrincipal= New-ScheduledTaskPrincipal -UserID $RunUser -RunLevel Limited 

    #   �^�X�N�o�^
    Register-ScheduledTask -TaskPath \ -TaskName $TargetTaskName -Action $Action -Trigger $Trigger -Principal $TaskPrincipal -Force

}

if($Error.count -eq 0){

    [System.Windows.Forms.MessageBox]::Show("�ݒ肪�������܂���", "�߂��ƌ����ݒ�(�I������)")

}
else
{
    [System.Windows.Forms.MessageBox]::Show("�G���[���m�F���Ă�������", "�G���[")
    Write-Host $error
}
