@echo off
cls
openfiles > NUL 2>&1 


echo �uPCNAME999�v�𐳂���PC���ɕύX�@(��)�@�R�c�N���j�b�N�@YAMAONS01

pause


echo �f�X�N�g�b�v�ɃA�C�R����\��������

echo �R���s���[�^�@
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f
echo.
rem echo ���[�U�[�̃t�@�C��
rem reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {59031a47-3f72-44a7-89c5-5595fe6b30ee} /t REG_DWORD /d 0 /f
echo.
echo �l�b�g���[�N
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t REG_DWORD /d 0 /f
echo.
echo ���ݔ�
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {645FF040-5081-101B-9F08-00AA002F954E} /t REG_DWORD /d 0 /f
echo.
echo �R���g���[���p�l��
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d 0 /f
echo.
echo �v�����^�[
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{2227a280-3aea-1069-a2de-08002b30309d}" /f 
echo.
echo.

echo �����|�C���g��L���ɂ��āA�e�ʂ�C�h���C�u��5%�Őݒ肵�܂��B
powershell -command "Enable-ComputerRestore -Drive C:"
vssadmin resize shadowstorage /for=C: /on=C: /maxsize=5%%
echo.
echo.

echo �t�H���_�I�v�V�����ݒ�
echo �G�N�X�v���[���[�ŊJ���@PC
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t "REG_DWORD" /d "1" /f
echo.
echo �ŋߎg�����t�@�C���@�N�C�b�N�A�N�Z�X����
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t "REG_DWORD" /d "0" /f
echo.
echo �悭�g���t�H���_�@�N�C�b�N�A�N�Z�X����
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t "REG_DWORD" /d "0" /f 
echo.
echo ���ׂẴt�H���_�[��\��
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NavPaneShowAllFolders" /t REG_DWORD /d "1" /f
echo.
echo �B���t�@�C���A�B���t�H���_�[�A����щB���h���C�u��\������
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f
echo.
echo �o�^����Ă���g���q�͕\�����Ȃ�
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f
echo.
echo �ی삳�ꂽ�I�y���[�V���� �V�X�e�� �t�@�C����\�����Ȃ�
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d "0" /f
echo.
echo.

echo �d���Ǘ�

echo "�d���{�^�����������Ƃ��̓��� �o�b�e���[�@�V���b�g�_�E��"
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\7648EFA3-DD9C-4E3E-B566-50F929386280" /v DCSettingIndex /t REG_DWORD /d 3 /f
echo.
echo "�d���{�^�����������Ƃ��̓��� �d���@�V���b�g�_�E��"
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\7648EFA3-DD9C-4E3E-B566-50F929386280" /v ACSettingIndex /t REG_DWORD /d 3 /f
echo.
echo "�X���[�v�{�^�����������Ƃ��̓��� �o�b�e���[�@�������Ȃ�"
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\96996BC0-AD50-47EC-923B-6F41874DD9EB" /v  DCSettingIndex /t REG_DWORD /d 0 /f
echo.
echo "�X���[�v�{�^�����������Ƃ��̓��� �d���@�������Ȃ�"
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\96996BC0-AD50-47EC-923B-6F41874DD9EB" /v  ACSettingIndex /t REG_DWORD /d 0 /f
echo.
echo "�����X�^�[�g�A�b�v�@����"
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f
echo.
echo "�X���[�v�@����"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v ShowSleepOption /t REG_DWORD /d 0 /f
echo.
echo.

echo �n�[�h�f�B�X�N
echo ���̎��Ԃ��o�ߌ�n�[�h�f�B�X�N�̓d����؂�@�Ȃ�
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0
echo.

echo �f�X�N�g�b�v�w�i�̐ݒ�
echo �X���C�h �V���[�@�ꎞ��~
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 001
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 001
echo.


echo �X���[�v
echo ���̎��Ԃ��o�ߌ�X���[�v���Ȃ�
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
echo.
echo �V�X�e�����l�X���[�v�̃^�C���A�E�g �\��������
powercfg -attributes SUB_SLEEP 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 -ATTRIB_HIDE
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0
echo.
echo �n�C�u���b�h �X���[�v��������@�I�t
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 000
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 000
echo.
echo ���̎��Ԃ��o�ߌ�x�~��Ԃɂ���@�I�t
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
echo.
echo �X���[�v�����^�C�}�[�̋��@����
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 000
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 000
echo.

echo �d���{�^���ƃJ�o�[
echo �J�o�[������Ƃ��̑���@�Ȃɂ����Ȃ�
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000
echo.
echo �d���{�^���̑���@�V���b�g�_�E��
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003
echo.
echo �X���[�v�{�^���̑���@�Ȃɂ����Ȃ�
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000
echo.

echo PCI Express
echo �����N��Ԃ̓d���Ǘ��@�I�t
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 000
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 000
echo.

echo �v���Z�b�T�̓d���Ǘ�
echo �ŏ��̃v���Z�b�T�̏�Ԃ́@100%
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 100
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 100
echo.
echo �V�X�e���̗�p�|���V�[�@�A�N�e�B�u�i�v���Z�b�T���x�𗎂Ƃ��O�Ƀt�@�����x���グ��j
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 001
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 001
echo.
echo �ő�̃v���Z�b�T�̏�ԁ@100%
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100
echo.

echo �f�B�X�v���C
echo ���̎��Ԃ��o�ߌ�f�B�X�v���C�̓d����؂�Ȃ�
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
echo.
echo.


echo Windows�Œʏ�g���v�����^���Ǘ�����@����
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v LegacyDefaultPrinterMode /t REG_DWORD /d 1 /f
echo.

echo �Z�[�t���[�h�� F8�N�� �œ����悤�ɂ���
bcdedit /set {default} bootmenupolicy legacy
echo.
echo.


echo Firewall VPN��Ping��Ԃ�
echo �h���C�����Ƀv���C�x�[�g���ǉ�
netsh advfirewall firewall set rule name="�t�@�C���ƃv�����^�[�̋��L (�G�R�[�v�� - ICMPv4 ��M)" profile=domain new enable=yes profile=domain,private remoteip=any
echo.
echo �v���C�x�[�g�A�p�u���b�N�����p�u���b�N�݂̂ɕύX
netsh advfirewall firewall set rule name="�t�@�C���ƃv�����^�[�̋��L (�G�R�[�v�� - ICMPv4 ��M)" profile=private,public new enable=no profile=public
echo.
echo IE�̃z�[���y�[�W��Google�ɐݒ�
reg add "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "https://www.google.co.jp" /f
rem reg delete "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /v "Secondary Start Pages" /f
echo.
echo.
echo �f�o�C�X�̈Í������I�t�ɕύX
powershell -command "manage-bde -off C:"
echo.
echo. 
echo �l�b�g���[�N�ɐڑ�����Ă���f�o�C�X�̎����Z�b�g�A�b�v�𖳌��ɂ���
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private" /v AutoSetup /t REG_DWORD /d 0 /f
echo.
echo.

echo �^�X�N�o�[
echo �g�^�X�N�o�[�̃{�^���h���^�X�N �o�[�ɓ��肫��Ȃ��ꍇ�Ɍ���
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarGlomLevel /t REG_DWORD /d 1 /f
echo.
echo �g�^�X�N�o�[�ɏ�ɂ��ׂẴA�C�R���ƒʒm��\������h�Ƀ`�F�b�N������
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" /v EnableAutoTray /t REG_DWORD /d 0 /f
echo.
echo �������^�X�N�o�[�{�^�����g��
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSmallIcons /t REG_DWORD /d 1 /f
echo.
echo.


echo "��F�ؕt�����[�_�[��panasonic�ł���(y/n)?"
choice

if %errorlevel%==1 (goto :no_start)
echo.
echo �X�N���[���Z�[�o�ݒ聨3D
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v SCRNSAVE.EXE /t REG_SZ /d "ssText3d.scr" /f
echo.
echo �҂����ԁ�15��(900�b)
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaveTimeOut /t REG_SZ /d "900" /f
echo.
echo �ĊJ���ɂɃ��O�I����ʂɖ߂�̃`�F�b�N���O���@��1:�L��
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaverIsSecure /t REG_SZ /d "1" /f

:no_start

rem �l�b�g���[�N�A�_�v�^���ύX�@�I�����p
netsh -c interface set interface name="�C�[�T�l�b�g" newname=�I�����p

rem�@�l�b�g���[�N�A�_�v�^���ύX�@�A�g�p
netsh -c interface set interface name="�C�[�T�l�b�g 2" newname=�A�g�p

echo.
echo "�I�����p�FIPv4�O���A�A�g�p�FIPv6�O��"
powershell -command "Set-NetAdapterBinding -Name """�I�����p""" -ComponentID """ms_tcpip""" -Enabled $false
powershell -command "Set-NetAdapterBinding -Name """�A�g�p""" -ComponentID """ms_tcpip6""" -Enabled $false
echo.
pause
rem Disable-NetAdapterBinding -Name "�I�����p" -ComponentID ms_tcpip4
rem Get-NetAdapterBinding -Name "�A�g�p" -ComponentID ms_tcpip4



rem �v���L�VON
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyEnable /t reg_dword /d 1

rem �v���L�V�ݒ�
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyServer /t reg_sz /d http://proxy.base.oqs-pdl.org:8080

rem �v���L�V�@��O��192.168.220.1
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyOverride /t reg_sz /d "*.onshikaku.org;*.flets-east.jp;*.flets-west.jp;*.lineauth.mnw;*.obn.managedpki.ne.jp;*.cybertrust.ne.jp;*.secomtrust.net;*.rece;pweb.base.oqs-pdl.org;*.kenporen.com;192.168.220.1"


echo�@�I�����t�H���_�쐬
mkdir C:\Users\OqsComApp\Documents\�I����


echo PC���ύX
wmic computersystem where name="%computername%" call rename name="PCNAME999"


echo�@�������O�C�� ���[�U�A�J�E���g��ʂŃ��[�U���Ƀ`�F�b�N������
netplwiz

pause

echo�@�������O�C���@���[�U�A�J�E���g��ʂŃ��[�U���Ƀ`�F�b�N���O����PW����
netplwiz

