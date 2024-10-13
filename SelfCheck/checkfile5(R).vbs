Option Explicit

'2015/11/06		DD�n��ORCA�̃_���v������������Ȃ��̂ŏC��
'2016/05/10		���K�\���ɂ��`�F�b�N�ɕύX
'				�����p�^�[���̒ǉ�
'2016/05/11		�����p�^�[���̒ǉ�
'2016/05/12		UNC�p�X�����̒ǉ�
'2016/09/13		�����˗��t�@�C�������̒ǉ�
'2017/06/09		CSV�t�@�C�������̒ǉ�
'2018/09/03		Windows�̈ꕔ�t�H���_�����O

public const strVersion = "2019/05/20"
public objWriteFile
'***************************************************************************************************************
' Sub and Function
'***************************************************************************************************************

Function CHKPattern(objRE ,strPattern ,strData)

	With objRE
		.Pattern = strPattern	''�����p�^�[����ݒ�
		.IgnoreCase = True		''�啶���Ə���������ʂ��Ȃ�
		.Global = True			''������S�̂�����
		If .Test(strData) Then
			CHKPattern = True
		Else
			CHKPattern = False
		End If
	End With

End Function

Sub CommonCHK(objRE ,strFileName ,strWorkPath ,strFile ,strExt ,checkflg ,folderflg ,strRiyu)

	'***************
	'��ɉ摜
	if CHKPattern(objRE ,".*\.bmp$" ,strFileName) then
		if Not ( _
				CHKPattern(objRE ,"^[CDEQR]:\\.*chozai.*\\lib$" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\DctNet\\Ex\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\DctNet\\Ika\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\DLUpdaterWorkFolder\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^D:\\DLUpdaterWorkFolder\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^D:\\Ndw\\Installer\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\TEMP_NDW\\SupportTool\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\MAVP\\VirusBuster\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^D:\\ServicePack\\Hi-SEED_W3R\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^D:\\ServicePack\\Hi-SEED_W3\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Drivers\\.*\\printer\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\Data\\workspace\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\Data\\w32\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\framework\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Microsoft Visual Studio\\VB98\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Program Files\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Program Files \(x86\)\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Citrix\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Corel\\Messages\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Logishrd\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Microsoft\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Logishrd\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Microsoft\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Citrix\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Corel\\Messages\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\EPSON DIRECT\\Backup Tool\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\Public\\Pictures\\Sample Pictures$" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Local\\Corel\\Thumbs\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Local\\Google\\Chrome\\User Data\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Local\\Microsoft\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Roaming\\Corel\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Roaming\\Skype\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Roaming\\Microsoft\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Roaming\\Sun\\Java\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Globalization\\MCT\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Installer\\\$PatchCache\$\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Microsoft\.NET\\Framework\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Microsoft\.NET\\Framework64\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\DriverStore\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\GWX\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\migwiz\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\oem$" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\oobe\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\spool\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\SysWOW64$" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Web\\Wallpaper\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\winsxs\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\\$WINDOWS.~BT\\NewOS\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\eclipse\\features\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\eclipse\\plugins\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\eclipse\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\java\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\python\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\tomcat\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\xampp\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Lenovo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Synaptics\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\SWTOOLS\\DRIVERS\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\SWTOOLS\\readyapps\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Lenovo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Synaptics\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows.old\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\SoftwareDistribution\\Download\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\00_�r���h���W���[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DD2���L\\51.�Z�b�g�A�b�v�t�@�C��\\DD2�J�����Z�b�g�A�b�v\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\09.�^�p�菇���i�}�j���A���j\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\11.�Z�b�g�A�b�v�֘A\\�Z�b�g�A�b�vCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\13.�\�[�X\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\14-�r���h���W���[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\14-�r���h���W���[��_old\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�I�v�V�����֘A\\�������I�v�V�����֘A\\���V�X�e���C���X�g�[����\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�I�v�V�����֘A\\�����ИA�g�d�l��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�I�v�V�����֘A\\���e�A�g�菇��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�J���`�[����Ɨp\\pcAnywhere\12.5�t��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�J���`�[����Ɨp\\�C���X�g�[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\�}�X�^�|�Ǘ�\\PcAnywhere12.5\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\CS�x����\\�y��ȁz��������\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\CS�x����\\����\\Hi-SEED\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\CS�x����\\����\\Hi-SEED W3\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\CS�x����\\����\\Hi-SEED W3\(R\)������\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\CS�x����\\����\\Hi-SEED W3R\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\CS�x����\\����\\Pre-SEED\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\CS�x����\\����\\Pre-SEED AS\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\DDTOP���L\\09-�����֘A\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\DDTOP���L\\DDTOP_�񋟃}�j���A��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\DDTOP���L\\�Z�b�g�A�b�v�菇��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\��GooCo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\��Hi-story\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\��Pharma-SEED\\�C���X�g�[���[\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(NS\)\\�yCD�z�o�[�W�����A�b�v�c�[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(NS\)\\�yCD�z�ی���ǃV�X�e���m�r�Z�b�g�A�b�vCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(VER6\)\\�yCD�zJAPIC�Y�t���������f�[�^\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(VER6\)\\�yCD�zMDB�摜\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�R�[���Z���^�[�Ή����Y�t����\\���\\�n������\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�T�[�r�X����\\2015-2016�X�M���֎���\\���Z�R���P���@�ʐ^\\" ,strWorkPath) _
				) then
			checkflg = true : strRiyu = "�摜�v�m�F"
		End if
	End if
	if CHKPattern(objRE ,".*\.png$" ,strFileName) then
		if Not ( _
				CHKPattern(objRE ,"^C:\\Lotus\\Notes\\Data\\domino\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Apps\\334CH\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\SupportAssist\\Client\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\SupportAssist\\Client\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\DctNet\\Ex\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\DctNet\\Ika\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\HistoryUpdater\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^D:\\HistoryUpdater\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Ndw\\UsersManual\\Contents\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\TEMP_NDW\\SupportTool\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\MAVP\\VirusBuster\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\HiStory\\UpdateBackup\\[0-9]{12}\\bin\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\HiStory\\yDrive\\bin\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\ImmersiveControlPanel\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Drivers\\.*\\printer\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\Data\\workspace\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\Data\\w32\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\framework\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Microsoft Visual Studio\\VB98\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Program Files\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Program Files \(x86\)\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Citrix\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Corel\\Messages\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Logishrd\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Microsoft\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Hi-Bridge\\HiStoryUpdater\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Hi-Bridge\\HiStoryUpdater\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Local\\Packages\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Logishrd\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Microsoft\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Citrix\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Corel\\Messages\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\EPSON DIRECT\\Backup Tool\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\Public\\Pictures\\Sample Pictures$" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Local\\Corel\\Thumbs\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Local\\Google\\Chrome\\User Data\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Local\\Microsoft\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Roaming\\Corel\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Roaming\\Skype\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Roaming\\Microsoft\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Roaming\\Sun\\Java\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Globalization\\MCT\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Installer\\\$PatchCache\$\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Microsoft\.NET\\Framework\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Microsoft\.NET\\Framework64\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\servicing\\LCU\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\SoftwareDistribution\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\DriverStore\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\GWX\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\migwiz\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\oem$" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\oobe\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\spool\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\SysWOW64$" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Web\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\winsxs\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\\$WINDOWS.~BT\\NewOS\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\eclipse\\features\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\eclipse\\plugins\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\eclipse\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\java\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\python\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\tomcat\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\xampp\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Lenovo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Synaptics\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\SWTOOLS\\DRIVERS\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\SWTOOLS\\readyapps\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Lenovo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Synaptics\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\ImmersiveControlPanel\\images\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\InfusedApps\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\MiracastView\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\SystemApps\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\SystemResources\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows.old" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\SoftwareDistribution\\Download\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\00_�r���h���W���[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DD2���L\\51.�Z�b�g�A�b�v�t�@�C��\\DD2�J�����Z�b�g�A�b�v\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\09.�^�p�菇���i�}�j���A���j\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\11.�Z�b�g�A�b�v�֘A\\�Z�b�g�A�b�vCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\13.�\�[�X\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\14-�r���h���W���[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\14-�r���h���W���[��_old\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�I�v�V�����֘A\\�������I�v�V�����֘A\\���V�X�e���C���X�g�[����\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�I�v�V�����֘A\\�����ИA�g�d�l��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�I�v�V�����֘A\\���e�A�g�菇��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�J���`�[����Ɨp\\pcAnywhere\12.5�t��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�J���`�[����Ɨp\\�C���X�g�[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\�}�X�^�|�Ǘ�\\PcAnywhere12.5\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\��GooCo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\��Hi-story\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\��Pharma-SEED\\�C���X�g�[���[\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(NS\)\\�yCD�z�o�[�W�����A�b�v�c�[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(NS\)\\�yCD�z�ی���ǃV�X�e���m�r�Z�b�g�A�b�vCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(VER6\)\\�yCD�zJAPIC�Y�t���������f�[�^\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(VER6\)\\�yCD�zMDB�摜\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�R�[���Z���^�[�Ή����Y�t����\\���\\�n������\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�T�[�r�X����\\2015-2016�X�M���֎���\\���Z�R���P���@�ʐ^\\" ,strWorkPath) _
				) then
			checkflg = true : strRiyu = "�摜�v�m�F"
		End if
	End if
	if CHKPattern(objRE ,".*\.jpg$" ,strFileName) then
		if Not ( _
				CHKPattern(objRE ,"^[CDEQR]:\\.*chozai.*\\lib$" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Apps\\334CH\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\DctNet\\Ex\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\DctNet\\Ika\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\BtrnApp\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Ndw\\UsersManual\\Contents\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\TEMP_NDW\\Gadgets\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\TEMP_NDW\\SupportTool\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\HiStory\\UpdateBackup\\[0-9]{12}\\bin\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\HiStory\\yDrive\\bin\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Drivers\\.*\\printer\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\SystemApps\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Web\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\Data\\domino\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\Data\\workspace\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\Data\\w32\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\framework\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Microsoft Visual Studio\\VB98\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Program Files\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Program Files \(x86\)\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Citrix\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Corel\\Messages\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Logishrd\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Microsoft\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\EPSON DIRECT\\Backup Tool\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Hi-Bridge\\HiStoryUpdater\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Hi-Bridge\\HiStoryUpdater\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Local\\Packages\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Logishrd\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Microsoft\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Citrix\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Corel\\Messages\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\EPSON DIRECT\\Backup Tool\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\Public\\Pictures\\Sample Pictures$" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Local\\Corel\\Thumbs\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Local\\Google\\Chrome\\User Data\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Local\\Microsoft\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Roaming\\Corel\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Roaming\\Skype\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Roaming\\Microsoft\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\AppData\\Roaming\\Sun\\Java\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Globalization\\MCT\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Installer\\\$PatchCache\$\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Microsoft\.NET\\Framework\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Microsoft\.NET\\Framework64\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\servicing\\LCU\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\DriverStore\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\GWX\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\migwiz\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\oem$" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\oobe\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\System32\\spool\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\SysWOW64$" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\Web\\Wallpaper\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\winsxs\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\\$WINDOWS.~BT\\NewOS\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\eclipse\\features\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\eclipse\\plugins\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\eclipse\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\java\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\python\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\tomcat\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\xampp\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Lenovo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Synaptics\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\SWTOOLS\\DRIVERS\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\SWTOOLS\\readyapps\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Lenovo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Synaptics\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows.old" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Windows\\SoftwareDistribution\\Download\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\00_�r���h���W���[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DD2���L\\51.�Z�b�g�A�b�v�t�@�C��\\DD2�J�����Z�b�g�A�b�v\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\09.�^�p�菇���i�}�j���A���j\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\11.�Z�b�g�A�b�v�֘A\\�Z�b�g�A�b�vCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\13.�\�[�X\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\14-�r���h���W���[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\14-�r���h���W���[��_old\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�I�v�V�����֘A\\�������I�v�V�����֘A\\���V�X�e���C���X�g�[����\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�I�v�V�����֘A\\�����ИA�g�d�l��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�I�v�V�����֘A\\���e�A�g�菇��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�J���`�[����Ɨp\\pcAnywhere\12.5�t��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�J���`�[����Ɨp\\�C���X�g�[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\�}�X�^�|�Ǘ�\\PcAnywhere12.5\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\��GooCo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\��Hi-story\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\��Pharma-SEED\\�C���X�g�[���[\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(NS\)\\�yCD�z�o�[�W�����A�b�v�c�[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(NS\)\\�yCD�z�ی���ǃV�X�e���m�r�Z�b�g�A�b�vCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(VER6\)\\�yCD�zJAPIC�Y�t���������f�[�^\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(VER6\)\\�yCD�zMDB�摜\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�R�[���Z���^�[�Ή����Y�t����\\���\\�n������\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�T�[�r�X����\\2015-2016�X�M���֎���\\���Z�R���P���@�ʐ^\\" ,strWorkPath) _
				) then
			checkflg = true : strRiyu = "�摜�v�m�F"
		End if
	End if

	'***************
	'��ɃX�^�[�t�����h
	if CHKPattern(objRE ,"BS.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "�X�^�[�t�����h"
	End if

	'***************
	'��ɃT�[�r�X�t�����h
	if CHKPattern(objRE ,"HH.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "�T�[�r�X�t�����h"
	End if
	if CHKPattern(objRE ,"BT.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "�T�[�r�X�t�����h"
	End if
	if CHKPattern(objRE ,"PW.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "�T�[�r�X�t�����h"
	End if
	if CHKPattern(objRE ,"CN.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "�T�[�r�X�t�����h"
	End if

	'***************
	'��ɐ����V�X�e��
	if CHKPattern(objRE ,"KAIGO[0-9]{2}.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "�����V�X�e��"
	End if

	'***************
	'��ɑS������t�@�C���V�X�e��
	if CHKPattern(objRE ,"BANKIF.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "�S������t�@�C���V�X�e��"
	End if

	'***************
	'��Ɏ��ȃV�X�e��
	if CHKPattern(objRE ,"�ꊇ[0-9]{3}.*\.lzh$" ,strFileName) then
		checkflg = true : strRiyu = "���ȃV�X�e��"
	End if
	if CHKPattern(objRE ,"����[0-9]{3}.*\.lzh$" ,strFileName) then
		checkflg = true : strRiyu = "���ȃV�X�e��"
	End if
	if CHKPattern(objRE ,"receipt.*\.mdb$" ,strFileName) then
		checkflg = true : strRiyu = "���ȃV�X�e��"
	End if
	if CHKPattern(objRE ,"[0-9]{6}.*MST.*\.mdb$" ,strFileName) then
		checkflg = true : strRiyu = "���ȃV�X�e��"
	End if
	if CHKPattern(objRE ,"[0-9]{6}.*BYO.*\.mdb$" ,strFileName) then
		checkflg = true : strRiyu = "���ȃV�X�e��"
	End if
	if CHKPattern(objRE ,"DRDB[0-9]{4}.*\.INI$" ,strFileName) then
		checkflg = true : strRiyu = "���ȃV�X�e��"
	End if
	if CHKPattern(objRE ,"REZEDEN.*\.INI$" ,strFileName) then
		checkflg = true : strRiyu = "���ȃV�X�e��"
	End if
	if CHKPattern(objRE ,"REZEPATH.*\.INI$" ,strFileName) then
		checkflg = true : strRiyu = "���ȃV�X�e��"
	End if
	if CHKPattern(objRE ,"mitsumo.*\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "���ȃV�X�e��"
	End if
	if CHKPattern(objRE ,"ModeKep1.*\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "���ȃV�X�e��"
	End if

	'***************
	'�ڑ����
	if CHKPattern(objRE ,"�ڑ����.*\.mdb$" ,strFileName) then
		checkflg = true : strRiyu = "�ڑ����"
	End if

	'***************
	'VPN�ڑ��Ǘ�
	if CHKPattern(objRE ,"VPN�ڑ��Ǘ�.*.exe$" ,strFileName) then
		checkflg = true : strRiyu = "�ڑ����"
	End if

	'***************
	'CSV
	if CHKPattern(objRE ,".*.csv$" ,strFileName) then
		checkflg = true : strRiyu = "CSV�t�@�C��"
	End if

	'***************
	'���Hi-SEED
	if CHKPattern(objRE ,"ALL_[0-9]{14}.*\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "Hi-SEED"
	End if
	if CHKPattern(objRE ,"DWDB.BACKUP.*\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "Hi-SEED"
	End if
	if CHKPattern(objRE ,"DWDB.*\.mdf$" ,strFileName) then
		checkflg = true : strRiyu = "Hi-SEED"
	End if
	if CHKPattern(objRE ,"DWDB_log.*\.mdf$" ,strFileName) then
		checkflg = true : strRiyu = "Hi-SEED"
	End if
	if CHKPattern(objRE ,"ALL_[0-9]{14}" ,strWorkPath) then
		checkflg = true : strRiyu = "Hi-SEED"
		folderflg = true
	End if
	if CHKPattern(objRE ,"[0-9]_[0-9]{9}\.jpg$" ,strFileName) then
		checkflg = true : strRiyu = "Hi-SEED"
	End if
	if CHKPattern(objRE ,"IRAI[0-9]{18}\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "Hi-SEED"
	End if
	if CHKPattern(objRE ,"IRAI[0-9]{17}\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "Hi-SEED"
	End if
	if CHKPattern(objRE ,"KEKKA[0-9]{18}\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "Hi-SEED"
	End if
	if CHKPattern(objRE ,"KEKKA[0-9]{17}\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "Hi-SEED"
	End if

	'***************
	'���ORCA
	if CHKPattern(objRE ,".*\.dmp$" ,strFileName) then
		if Not ( _
				CHKPattern(objRE ,"^C:\\Lotus\\Notes\\Data\\IBM_TECHNICAL_SUPPORT" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\Data\\workspace\\logs" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Microsoft\\Windows\\WER\\ReportQueue\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Microsoft\\Windows\\WER\\ReportQueue\\" ,strWorkPath) _
				) then
			checkflg = true : strRiyu = "ORCA"
		End if
	End if
	if CHKPattern(objRE ,".*\.dump$" ,strFileName) then
		checkflg = true : strRiyu = "ORCA"
	End if
	if CHKPattern(objRE ,".*\.dmp\.gz$" ,strFileName) then
		checkflg = true : strRiyu = "ORCA"
	End if
	if CHKPattern(objRE ,".*\.dump\.gz$" ,strFileName) then
		checkflg = true : strRiyu = "ORCA"
	End if
	if CHKPattern(objRE ,".*\.dmp\.gz\.crypt$" ,strFileName) then
		checkflg = true : strRiyu = "ORCA"
	End if
	if CHKPattern(objRE ,".*\.dmp\.bz2$" ,strFileName) then
		checkflg = true : strRiyu = "ORCA"
	End if
	if CHKPattern(objRE ,".*\.dump\.bz2$" ,strFileName) then
		checkflg = true : strRiyu = "ORCA"
	End if
	'if CHKPattern(objRE ,".*\.out$" ,strFileName) then
	'	checkflg = true : strRiyu = "ORCA"
	'End if
	if CHKPattern(objRE ,"tenken\.uke$" ,strFileName) then
		checkflg = true : strRiyu = "ORCA"
	End if
	If strExt = "CSV" and (InStr(strFile, "PTINF") <>0 or InStr(strFile, "PTHKNINF") <>0 _
		or InStr(strFile, "PTKOHINF") <>0 or InStr(strFile, "SRYKARRK") <>0 _
		or InStr(strFile, "PTBYOMEI") <>0 or InStr(strFile, "ORKANJA") <>0 _
		or InStr(strFile, "ORHOKEN") <>0 or InStr(strFile, "ORKOHI") <>0 _
		or InStr(strFile, "ORSHIN") <>0 or InStr(strFile, "ORKANJABYOMEI") <>0 ) Then
		checkflg = true : strRiyu = "ORCA"
	End If

	'***************
	'���DDtop
	if CHKPattern(objRE ,"ddii.*\.enc\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "DDtop"
	End if
	if CHKPattern(objRE ,"DDtop_.*_[0-9]{8}.log$" ,strFileName) then
		checkflg = true : strRiyu = "DDtop"
	End if

	'***************
	'���DD2
	if CHKPattern(objRE ,"DoctorsDesk.S..\.TXT$" ,strFileName) then
		checkflg = true : strRiyu = "DD2"
	End if
	if CHKPattern(objRE ,"PRJ..\.TXT$" ,strFileName) then
		checkflg = true : strRiyu = "DD2"
	End if
	if CHKPattern(objRE ,"Neo..\.TXT$" ,strFileName) then
		checkflg = true : strRiyu = "DD2"
	End if
	if CHKPattern(objRE ,"ActiveLog\.TXT$" ,strFileName) then
		checkflg = true : strRiyu = "DD2"
	End if

	'***************
	'���DDtop�ADD2
	if CHKPattern(objRE ,"ddii.*\.dmp$" ,strFileName) then
		checkflg = true : strRiyu = "DDtop or DD2"
	End if
	if CHKPattern(objRE ,".*\.backup$" ,strFileName) then
		checkflg = true : strRiyu = "DDtop or DD2"
	End if
	if CHKPattern(objRE ,"ddii.*\.dmp\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "DDtop or DD2"
	End if
	if CHKPattern(objRE ,"ddii.*\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "DDtop or DD2"
	End if
	if CHKPattern(objRE ,".*\.backup\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "DDtop or DD2"
	End if
	if CHKPattern(objRE ,".*_[0-9]{8}_[0-9]{2}\.doc$" ,strFileName) _
		or CHKPattern(objRE ,".*_[0-9]{8}_[0-9]{2}\.docx$" ,strFileName) _
		or CHKPattern(objRE ,".*_[0-9]{8}_[0-9]{2}\.xls$" ,strFileName) _
		or CHKPattern(objRE ,".*_[0-9]{8}_[0-9]{2}\.xlsx$" ,strFileName) _
		then
		checkflg = true : strRiyu = "DDtop or DD2"
	End if
	if CHKPattern(objRE ,"^[0-9]{14}_.*\.jpg$" ,strFileName) _
		or CHKPattern(objRE ,"^[0-9]{14}_.*\.png$" ,strFileName) _
		or CHKPattern(objRE ,"^[0-9]{14}_.*\.doc$" ,strFileName) _
		or CHKPattern(objRE ,"^[0-9]{14}_.*\.docx$" ,strFileName) _
		or CHKPattern(objRE ,"^[0-9]{14}_.*\.xls$" ,strFileName) _
		or CHKPattern(objRE ,"^[0-9]{14}_.*\.xlsx$" ,strFileName) _
		then
		checkflg = true : strRiyu = "DDtop or DD2"
	End if
	if CHKPattern(objRE ,"Personal" ,strWorkPath) then
		if Not ( CHKPattern(objRE ,"C:\\Lotus\\Notes\\Data\\workspace\\" ,strWorkPath) _
				or CHKPattern(objRE ,"C:\\Lotus\\Notes\\framework\\" ,strWorkPath) _
				or CHKPattern(objRE ,"C:\\Windows\\winsxs\\" ,strWorkPath) _
				) then
			checkflg = true : strRiyu = "DDtop or DD2"
			folderflg = true
		End if
	End if

	'***************
	'���DD2�ADW2
	if CHKPattern(objRE ,"datadb.*\.lzh$" ,strFileName) then
		checkflg = true : strRiyu = "DD2 or DW2"
	End if
	if CHKPattern(objRE ,"masterdb.*\.lzh$" ,strFileName) then
		checkflg = true : strRiyu = "DD2 or DW2"
	End if
	'���DW2
	if CHKPattern(objRE ,"datadb.*\.mdf$" ,strFileName) then
		checkflg = true : strRiyu = "DD2 or DW2"
	End if
	if CHKPattern(objRE ,"masterdb.*\.mdf$" ,strFileName) then
		checkflg = true : strRiyu = "DD2 or DW2"
	End if
	'���DW2
	if CHKPattern(objRE ,"datadb.*\.mdf$" ,strFileName) then
		checkflg = true : strRiyu = "DD2 or DW2"
	End if
	if CHKPattern(objRE ,"datadb.*\.ldf$" ,strFileName) then
		checkflg = true : strRiyu = "DD2 or DW2"
	End if
	if CHKPattern(objRE ,"masterdb.*\.mdf$" ,strFileName) then
		checkflg = true : strRiyu = "DD2 or DW2"
	End if
	if CHKPattern(objRE ,"masterdb.*\.ldf$" ,strFileName) then
		checkflg = true : strRiyu = "DD2 or DW2"
	End if

	'***************
	'���SuperClinic
	if CHKPattern(objRE ,"EBA.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "SuperClinic"
	End if
	if CHKPattern(objRE ,"EGAZO\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "SuperClinic"
	End if
	if CHKPattern(objRE ,"Jbamain\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "SuperClinic"
	End if

	'***************
	'���Pre-SEED
	if CHKPattern(objRE ,"MedDB.*\.mdf$" ,strFileName) then
		checkflg = true : strRiyu = "Pre-SEED"
	End if
	if CHKPattern(objRE ,"MedDB_log.*\.mdf$" ,strFileName) then
		checkflg = true : strRiyu = "Pre-SEED"
	End if
	if CHKPattern(objRE ,"MedDB_backup" ,strFileName) then
		checkflg = true : strRiyu = "Pre-SEED"
	End if
	if CHKPattern(objRE ,"LZHBackup\.lzh" ,strFileName) then
		checkflg = true : strRiyu = "Pre-SEED"
	End if
	if CHKPattern(objRE ,"FtnMoneyTool_MedDB_[0-9]{6}_[0-9]{6}\.log$" ,strFileName) then
		checkflg = true : strRiyu = "Pre-SEED"
	End if

	'***************
	'���MOA C's
	if CHKPattern(objRE ,"^D[0-9]{8}$" ,strWorkPath) then
		checkflg = true : strRiyu = "MOA-C's"
		folderflg = true
	End if
	if CHKPattern(objRE ,"^M[0-9]{6}$" ,strWorkPath) then
		checkflg = true : strRiyu = "MOA-C's"
		folderflg = true
	End if
	if CHKPattern(objRE ,"sbackup$" ,strWorkPath) then
		checkflg = true : strRiyu = "MOA-C's"
		folderflg = true
	End if
	if CHKPattern(objRE ,"ubackup$" ,strWorkPath) then
		checkflg = true : strRiyu = "MOA-C's"
		folderflg = true
	End if
	if CHKPattern(objRE ,"ubk_kan\.fil$" ,strFileName) then
		checkflg = true : strRiyu = "MOA-C's"
	End if
	if CHKPattern(objRE ,"ubk_file\.fil$" ,strFileName) then
		checkflg = true : strRiyu = "MOA-C's"
	End if
	if CHKPattern(objRE ,"ubackup.*\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "MOA-C's"
	End if
	if CHKPattern(objRE ,"sbackup.*\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "MOA-C's"
	End if
	if CHKPattern(objRE ,"D[0-9]{8}.*\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "MOA-C's"
	End if
	if CHKPattern(objRE ,"M[0-9]{6}.*\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "MOA-C's"
	End if

	'***************
	'��ɂׂĂ��N
	if CHKPattern(objRE ,"SY[0-9]{6}GAI\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "�ׂĂ��N"
	End if
	if CHKPattern(objRE ,"KO[0-9]{6}GAI\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "�ׂĂ��N"
	End if
	if CHKPattern(objRE ,"SY[0-9]{6}NYU\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "�ׂĂ��N"
	End if
	if CHKPattern(objRE ,"KO[0-9]{6}NYU\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "�ׂĂ��N"
	End if
	if CHKPattern(objRE ,"�����f�[�^[0-9]{14}\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "�ׂĂ��N"
	End if

	'***************
	'���Z�d�_���t�@�C��
	if CHKPattern(objRE ,"checkfile_.*\.UKE$" ,strFileName) then
		checkflg = true : strRiyu = "���Z�d�_���t�@�C��"
	End if
	if CHKPattern(objRE ,"[0-9]{6}[SK]1RECEIPT.*\.UKEA$" ,strFileName) then
		checkflg = true : strRiyu = "���Z�d�_���t�@�C��"
	End if

	'***************
	'���Z�d�t�@�C��
	if CHKPattern(objRE ,"RECEIPT.\.UKE$" ,strFileName) then
		checkflg = true : strRiyu = "���Z�d�t�@�C��"
	End if
	if CHKPattern(objRE ,"RECEIPT.\.UKEA$" ,strFileName) then
		checkflg = true : strRiyu = "���Z�d�_���t�@�C��"
	End if
	if CHKPattern(objRE ,"RECEIPT.\.CYO$" ,strFileName) then
		checkflg = true : strRiyu = "���Z�d�t�@�C��"
	End if
	if CHKPattern(objRE ,"RECEIPT.\.HEN$" ,strFileName) then
		checkflg = true : strRiyu = "���Z�d�t�@�C��"
	End if
	if CHKPattern(objRE ,"RECEIPT.\.SAH$" ,strFileName) then
		checkflg = true : strRiyu = "���Z�d�t�@�C��"
	End if
	if CHKPattern(objRE ,"RECEIPT_[0-9]{6}.*\.ZIP$" ,strFileName) then
		checkflg = true : strRiyu = "���Z�d�t�@�C��"
	End if
'���܂̘J�Ѓ��Z�d�t�@�C��
	if CHKPattern(objRE ,"RREY.*\.CYO$" ,strFileName) then
		checkflg = true : strRiyu = "���Z�d�t�@�C��"
	End if
	if CHKPattern(objRE ,"RREY[0-9]{4}\.CYO$" ,strFileName) then
		checkflg = true : strRiyu = "���Z�d�t�@�C��"
	End if

	'***************
	'���Pharma-SEED
	if CHKPattern(objRE ,"JDDATA" ,strWorkPath) then
		checkflg = true : strRiyu = "Pharma-SEED"
		folderflg = true
	End if
	if CHKPattern(objRE ,"JDDATA.*\,zip$" ,strFileName) then
		checkflg = true : strRiyu = "Pharma-SEED"
	End if
	if CHKPattern(objRE ,"^J[DKZ].*\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "Pharma-SEED"
	End if
	if CHKPattern(objRE ,"J[DKZ].*\.lzh$" ,strFileName) then
		checkflg = true : strRiyu = "Pharma-SEED"
	End if
	if CHKPattern(objRE ,"JYRDATA\.dmp$" ,strFileName) then
		checkflg = true : strRiyu = "Pharma-SEED"
	End if
	if CHKPattern(objRE ,"RECEIPTY\.[SKsk]10$" ,strFileName) then
		checkflg = true : strRiyu = "Pharma-SEED"
	End if
	if CHKPattern(objRE ,"[0-9]{2]m4[0-9]{3}\.csv$" ,strFileName) then
		checkflg = true : strRiyu = "Pharma-SEED"
	End if
	if CHKPattern(objRE ,"^[0-9]{23}\.png$" ,strFileName) then
		checkflg = true : strRiyu = "Pharma-SEED"
	End if
	if CHKPattern(objRE ,"^[0-9]{8}-[0-9]{8}-[0-9]{8}-[0-9]{2}\.png$" ,strFileName) then
		checkflg = true : strRiyu = "Pharma-SEED"
	End if
	if CHKPattern(objRE ,"^[0-9]{8}-[0-9]{8}-[0-9]{8}-[0-9]{2}-[0-9]{2}\.png$" ,strFileName) then
		checkflg = true : strRiyu = "Pharma-SEED"
	End if

	'***************
	'���NSIPS
	if CHKPattern(objRE ,"[ADBUadbu][0-9]{20}\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "NSIPS"
	End if

	'***************
	'��ɂ߂���
	if CHKPattern(objRE ,"YSBACK01$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"chozai[0-9]{2}.*\.mdf$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"chozai[0-9]{2}.*\.ldf$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"chozai[0-9]{2}.*\.mdf.*$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"chozai[0-9]{2}.*\.ldf.*$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"RECEIPTY_[0-9]{6}_[SKsk]\.CYO$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"KZ[0-9]{6}\.CSV$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"[0-9]{5}-[0-9]{2}\.tif$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"^[0-9]{4}\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"KANZY\.TXT$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"[0-9]{8}\.tif$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"[0-9]{1,8}\.tif$" ,strFileName) then
		if CHKPattern(objRE ,"\\.*DATA[0-9].*$" ,strWorkPath) then
			checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
			folderflg = true
		End if
	End if
	if CHKPattern(objRE ,"kanja\.log$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	'if CHKPattern(objRE ,"�t�H���_��\.log$" ,strFileName) then
	'	checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	'End if
	if CHKPattern(objRE ,"meisai\.log$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"trnerr.*\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"trnerr2.*\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"jyufuku.*\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"kanerror.*\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"BUHN.*\.CSV$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"YS080_[0-9]{4}[0-9]{2}\.csv$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"KEN[0-9]{7}\.csv$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"OS050_22_4[0-9]{2}[0-9]{2}_KEN[0-9]{7}\.csv$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"214[0-9]{7}\.csv$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"OS050_21_4[0-9]{2}[0-9]{2}_KEN[0-9]{7}[0-9]{2}[0-9]{2}\.csv$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"M_SYOHO.*\.TXT$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
	End if
	if CHKPattern(objRE ,"\\.*CNV.*\\[0-9]{14,18}$" ,strWorkPath) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
		folderflg = true
	End if
	if CHKPattern(objRE ,"\\.*IJIDATA.*$" ,strWorkPath) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂���"
		folderflg = true
	End if
	'*****************************	����̕\�����ǂ����܂����H

	'***************
	'��ɂ߂��Ƃm�r
	if CHKPattern(objRE ,"SA12Elixir\.DB$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂��Ƃm�r"
	End if
	if CHKPattern(objRE ,"SA12Elixir\.log$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂��Ƃm�r"
	End if
	if CHKPattern(objRE ,"SA12Zaiko\.DB$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂��Ƃm�r"
	End if
	if CHKPattern(objRE ,"SA12Zaiko\.log$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂��Ƃm�r"
	End if
	if CHKPattern(objRE ,"SYAHO.*\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂��Ƃm�r"
	End if
	if CHKPattern(objRE ,"KOKUHO.*\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂��Ƃm�r"
	End if
	if CHKPattern(objRE ,"K[0-9]{7}\.CSV$" ,strFileName) then		'******************* �v�m�F
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂��Ƃm�r"
	End if

	'***************
	'��ɂ߂��Ƃm�d�w�s
	if CHKPattern(objRE ,"BK[0-9]{4}[0-9]{2}[0-9]{2}[0-9]{2}[0-9]{2}[0-9]{2}[A-Z]{3}Ver.*\.cph$" ,strFileName) then
		checkflg = true : strRiyu = "�Ԃ񂬂傤�߂��Ƃm�d�w�s"
	End if

	'***************
	'��Ƀ����Y�A������
	if CHKPattern(objRE ,"PWA.*\.DAT$" ,strFileName) then
		checkflg = true : strRiyu = "�����Y�A������"
	End if

	'***************
	'���Gooco
	'if CHKPattern(objRE ,"MS_AgentSigningCertificate\.cer$" ,strFileName) then
	'	checkflg = true : strRiyu = "Gooco"
	'End if
	if CHKPattern(objRE ,"DP_.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "Gooco"
	End if
	if CHKPattern(objRE ,"GG_.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "Gooco"
	End if
	if CHKPattern(objRE ,"VG_.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "Gooco"
	End if
	if CHKPattern(objRE ,"\\.*20_BAK.*$" ,strWorkPath) then
		checkflg = true : strRiyu = "Gooco"
		folderflg = true
	End if

	'***************
	'���Hi-story
	if CHKPattern(objRE ,"HI-STORY_BACKUP.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "Gooco"
	End if

	'***************
	'���Hi-story
	if CHKPattern(objRE ,"[0-9]{8}\.txt$" ,strFileName) then
		if CHKPattern(objRE ,"\\.*RVDATA.*$" ,strWorkPath) then
			checkflg = true : strRiyu = "���܃f�[�^�n��"
			folderflg = true
		End if
	End if

	'***************
	'���Sugi
	if CHKPattern(objRE ,"sugidb_dat.*\.mdb$" ,strFileName) then
		checkflg = true : strRiyu = "�r������"
	End if
	if CHKPattern(objRE ,"sugidb_log.*\.ldf$" ,strFileName) then
		checkflg = true : strRiyu = "�r������"
	End if
	if CHKPattern(objRE ,"sugidb.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "�r������"
	End if
	if CHKPattern(objRE ,"sugidb_log.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "�r������"
	End if

	'***************
	'��ɃR���o�[�g�c�[���f�[�^
	if CHKPattern(objRE ,"BUHN.*\.mdb$" ,strFileName) then
		checkflg = true : strRiyu = "MS-Access�v�m�F"
	End if



    ''���Z�d�t�@�C��
    'If strExt = "UKE" Or strExt = "UKEA" Or strExt = "CYO" Or strExt = "HEN" Or strExt = "SAH" _
    '	or InStr(strFile, "RECEIPTC") <> 0 or InStr(strFile, "RECEIPTY") <> 0 Then
    '    checkflg = True
    'End If

	'***************
	'�摜�́H
	'***************

	'***************
	'���PDF
	if CHKPattern(objRE ,".*\.pdf$" ,strFileName) then
		if Not ( _
				CHKPattern(objRE ,"^C:\\Lotus\\Notes\\framework\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Program Files \(x86\)\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Program Files\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\DctNet\\Ex\\ToolPgm\\KaiteiDocument\\PDF" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\BtrnApp\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\HiStory\\UpdateBackup\\[0-9]{12}\\bin\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\HiStory\\yDrive\\bin\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\HistoryUpdater\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^D:\\HistoryUpdater\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^D:\\ServicePack\\Hi-SEED_W3R\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^D:\\ServicePack\\Hi-SEED_W3\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^D:\\PH_SEEDAS\\PDFDX" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\JWinPrg\\HTML\\manual\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^D:\\PH_SEEDAS\\JWinPrg\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\.*\\Downloads\\cms_setup\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\\$WINDOWS.~BT\\NewOS\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Microsoft Visual Studio\\VB98\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^[CDEQR]:\\CHOZAI.*\\YDB07" ,strWorkPath) _
				or CHKPattern(objRE ,"^[CDJY]:\\EC\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^[CDJY]:\\EC_BAK\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^[CDJY]:\\SSMS.*\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\eclipse\\features\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\eclipse\\plugins\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\eclipse\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\java\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\python\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\tomcat\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\pleiades\\xampp\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Lenovo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\ProgramData\\Synaptics\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\SWTOOLS\\DRIVERS\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\SWTOOLS\\readyapps\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Lenovo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\Synaptics\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^C:\\Users\\All Users\\EPSON DIRECT\\Backup Tool\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\00_�r���h���W���[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DD2���L\\51.�Z�b�g�A�b�v�t�@�C��\\DD2�J�����Z�b�g�A�b�v\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\09.�^�p�菇���i�}�j���A���j\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\11.�Z�b�g�A�b�v�֘A\\�Z�b�g�A�b�vCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\13.�\�[�X\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\14-�r���h���W���[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\DDTOP���L\\14-�r���h���W���[��_old\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�I�v�V�����֘A\\�������I�v�V�����֘A\\���V�X�e���C���X�g�[����\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�I�v�V�����֘A\\�����ИA�g�d�l��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�I�v�V�����֘A\\���e�A�g�菇��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�J���`�[����Ɨp\\pcAnywhere\12.5�t��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\nas01-a2\\�J���`�[����Ɨp\\�C���X�g�[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�V�X�e���J��\\�}�X�^�|�Ǘ�\\PcAnywhere12.5\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\��GooCo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\��Hi-story\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\��Pharma-SEED\\�C���X�g�[���[\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(NS\)\\�yCD�z�o�[�W�����A�b�v�c�[��\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(NS\)\\�yCD�z�ی���ǃV�X�e���m�r�Z�b�g�A�b�vCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(VER6\)\\�yCD�zJAPIC�Y�t���������f�[�^\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�����܃V�X�e��\\���Ԃ񂬂傤�߂���\(VER6\)\\�yCD�zMDB�摜\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�R�[���Z���^�[�Ή����Y�t����\\���\\�n������\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\�S�ГW�J\\�T�[�r�X����\\2015-2016�X�M���֎���\\���Z�R���P���@�ʐ^\\" ,strWorkPath) _
				) then
			checkflg = true : strRiyu = "�o�c�e�v�m�F"
		End if
	End if

End Sub

Sub FileDisp(strPath)

	dim objFs
	dim objFld
	dim objFl
	dim objSub
	dim strFile
	dim strExt
	dim strWorkPath
	dim strFileName
	dim strRiyu

	dim checkflg
	Dim folderflg
	
	Dim L
	Dim Err_Code

	Dim Shell
	Dim Folder

	Dim ErrFlg
	
	Set objFs = CreateObject("Scripting.FileSystemObject")
	ErrFlg = False
	on error resume next
	Set objFld = objFs.GetFolder(strPath)
	if err <> 0 then
		ErrFlg = true
	end if
	on error goto 0
	if ErrFlg = true then
		exit sub				'************* �G���[�Ȃ甲����i�A�N�Z�X�����Ȃ��j
	end if
	
	Set Shell=CreateObject("Shell.Application")

	On Error Resume Next
	L = objFld.Files.Count
	Err_Code = Err
	On Error GoTo 0
    
	If Err_Code = 0 Then
		For Each objFl In objFld.Files
			'WScript.Sleep 1
			checkflg = false
			folderflg = false
			strRiyu = ""
			strFile = UCase(objFs.GetBaseName(objFl.Path))
			strExt = UCase(objFs.GetExtensionName(objFl.Path))
			strWorkPath = UCase(objFl.ParentFolder.Path)
			strFileName = UCase(objFs.GetFileName(objFl.Path))

			'***************
			'ZIP�́H���g�����܂����H
			'***************
			'***************
			'���ZIP����
			if CHKPattern(objRE ,".*\.zip$" ,strFileName) then
				if Not ( _
						CHKPattern(objRE ,"^C:\\Lotus\\Notes\\framework\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\Program Files \(x86\)\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\Program Files\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\ProgramData\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\Users\\.*\\Downloads\\cms_setup\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\Users\\All Users\\Symantec\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\jvm\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\Windows\\Installer\\\$PatchCache\$\\" ,strWorkPath) _
						) then
					checkflg = true : strRiyu = "�y�h�o���ɗv�m�F"
				End if
			End if
			'���tar����
			if CHKPattern(objRE ,".*\.tgz$" ,strFileName) or CHKPattern(objRE ,".*\.tar.gz$" ,strFileName) then
				if Not ( _
						CHKPattern(objRE ,"^C:\\Lotus\\Notes\\framework\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\Program Files \(x86\)\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\Program Files\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\ProgramData\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\Users\\.*\\Downloads\\cms_setup\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\Users\\All Users\\Symantec\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\Lotus\\Notes\\jvm\\" ,strWorkPath) _
						or CHKPattern(objRE ,"^C:\\Windows\\Installer\\\$PatchCache\$\\" ,strWorkPath) _
						) then
					checkflg = true : strRiyu = "�s�`�q���ɗv�m�F"
				End if
			End if

			Call CommonCHK(objRE ,strFileName ,strWorkPath ,strFile ,strExt ,checkflg ,folderflg ,strRiyu)


			'�t�@�C���̎�ނɂ�菜�O����
			'if objFl.Type = "�A�v���P�[�V����" or objFl.Type = "�A�v���P�[�V�����g��" or objFl.Type = "�\���ݒ�" _
			'	or objFl.Type = "�V���[�g�J�b�g" then
			'	checkflg = false
			'end if
			if checkflg = true then
				if folderflg = true then
					'�t�H���_�̏ꍇ
					on error resume next
					objWriteFile.WriteLine chr(&h22) & objFl.ParentFolder.Path & chr(&h22) & "," & "" _
							& "," & chr(&h22) & objFl.ParentFolder.Path & chr(&h22) _
							& "," & strRiyu & "," & "�t�H���_�i�t�@�C���L��j" & "," & cstr(Int(objFl.Size / 1024)) _
							& "," & cstr(objFl.DateCreated) & "," & cstr(objFl.DateLastAccessed) & "," & cstr(objFl.DateLastModified)
					if err <> 0 then
						'msgbox "�G���[����" & vbcrlf & vbcrlf & "�t�@�C���p�X" & vbcrlf & objFl.ParentFolder.Path
					end if
					on error goto 0
					'�t�H���_�̏ꍇ�́Afor next�𔲂���i����ȉ����m�F���Ă����܂�Ӗ����Ȃ��̂Łj
					exit for
				else
					on error resume next
					objWriteFile.WriteLine chr(&h22) & objFs.GetBaseName(objFl.Path) & chr(&h22) & "," & objFs.GetExtensionName(objFl.Path) _
							& "," & chr(&h22) & objFl.ParentFolder.Path & chr(&h22) _
							& "," & strRiyu & "," & objFl.Type & "," & cstr(Int(objFl.Size / 1024)) _
							& "," & cstr(objFl.DateCreated) & "," & cstr(objFl.DateLastAccessed) & "," & cstr(objFl.DateLastModified)
					if err <> 0 then
						'msgbox "�G���[����" & vbcrlf & vbcrlf & "�t�@�C���p�X" & vbcrlf & objFl.Path
					end if
					on error goto 0
				end if
			end if
		Next
		if folderflg <> true then
			For Each objSub In objFld.SubFolders
				'FileDisp objSub.Path, objWriteFile
				FileDisp objSub.Path
			Next
		end if
	end if
	set objSub = nothing
	set objFl = nothing
	set objFld = nothing
	set objFs = nothing
	
End Sub

'***************************************************************************************************************
' main
'***************************************************************************************************************

	'-------------------------------------
	' �ϐ���`
	'-------------------------------------
	Dim objFileSys
	Dim objDriveL
	Dim objDriveC
'	dim objWriteFile
	Dim objRE

	Dim WSH
	Dim sDesktop

	dim Ans
	Dim NetWorkDrive
	Dim NetWorkDriveOnly
	Dim NetWorkPath
	Dim NetWorkPathZen

	'-------------------------------------
	' �萔��`
	'-------------------------------------
	Const ForReading = 1 
	Const ForWriting = 2 
	Const OpenWriteFile = "checkfile5.csv"
	Const Separate = ",,,,,,,"

	Ans = Msgbox ("�t�@�C���̃`�F�b�N���J�n���܂��B" & vbcrlf & vbcrlf _
			& "�� �I�����b�Z�[�W���\�������܂ŁA" & vbcrlf _
			& "�@ ���ʃt�@�C�����J���Ȃ��ł��������B" _
			,vbInformation + vbSystemModal + vbYesNo,"�m�F�@Ver." & strVersion)
	if Ans=vbYes then 
		NetWorkDrive = False
		NetWorkDriveOnly = False
		NetWorkPath = False
		NetWorkPathZen = False
		Ans = Msgbox ("�l�b�g���[�N�h���C�u�̃`�F�b�N��" & vbcrlf _
				& "�s���܂����H" _
				,vbInformation + vbSystemModal + vbYesNo,"�m�F")
		if Ans = vbYes then
			NetWorkDrive = True
			Ans = Msgbox ("�l�b�g���[�N�h���C�u�����̃`�F�b�N��" & vbcrlf _
					& "�s���܂����H" _
					,vbInformation + vbSystemModal + vbYesNo + vbDefaultButton2,"�m�F")
			if Ans = vbYes then
				NetWorkDriveOnly = True
			end if
		end if
		Ans = Msgbox ("�A�N�Z�X�\�ȁA�l�b�g���[�N�p�X��" & vbcrlf _
				& "�`�F�b�N���s���܂����H" _
				,vbInformation + vbSystemModal + vbYesNo + vbDefaultButton2,"�m�F")
		if Ans = vbYes then
			NetWorkPath = True
			Ans = Msgbox ("�l�b�g���[�N�p�X�̃`�F�b�N��" & vbcrlf _
					& "�����Ǘ����܂߂܂����H" _
					,vbInformation + vbSystemModal + vbYesNo + vbDefaultButton2,"�m�F")
			if Ans = vbYes then
				NetWorkPathZen = True
			end if
		end if

		Set WSH = CreateObject("WScript.Shell")
		sDesktop = WSH.SpecialFolders("Desktop")
		Set WSH = Nothing
		
		Set objFileSys = CreateObject("Scripting.FileSystemObject")
		objFileSys.CreateTextFile OpenWriteFile
		Set objWriteFile = objFileSys.OpenTextFile(OpenWriteFile,ForWriting, TRUE)
		objWriteFile.WriteLine now() & ",Ver " & strVersion & Separate
		objWriteFile.WriteLine "���O,�g���q,�e�t�H���_��,�`�F�b�N���R,���,�T�C�Y(KB),�쐬�N����,�ŏI�A�N�Z�X�N����,�X�V�N����"

		Set objRE = CreateObject("VBScript.RegExp")

		'WScript.Echo "���̃R���s���[�^�̃h���C�u�ꗗ"

		For Each objDriveL In objFileSys.Drives
			If objFileSys.DriveExists(objDriveL) = True Then
				Set objDriveC = objFileSys.GetDrive(objDriveL)
				'WScript.echo "�h���C�u�̃��^�[�@�@�@�F" & objDriveL
				'WScript.echo "�h���C�u�̎�ށ@�@�@�@�F" & objDriveC.DriveType
				' 1 �����[�o�u���n
				' 2 HDD
				' 3 �l�b�g���[�N�n
				' 4 CD�n
				'WScript.echo "�f�B�X�N���g�p�\�H�@�F" & objDriveC.IsReady
				if objDriveC.IsReady = true and objDriveC.DriveType <> 3 and Not NetWorkDriveOnly _
					or objDriveC.IsReady = true and objDriveC.DriveType = 3 and NetWorkDrive then
					'FileDisp objDriveL , objWriteFile
					FileDisp objDriveL & "\"
				end if
			end if
		Next
		if NetWorkPath = true then
			FileDisp "\\flsv01\cs���"
			FileDisp "\\flsv01\�V�X�e���J��"
			FileDisp "\\flsv01\�c�Ɗ��"
			FileDisp "\\flsv01\�c�Ɛ��i"
			FileDisp "\\flsv01\����"
			FileDisp "\\flsv01\�L��"
			FileDisp "\\flsv01\�D�y"
			FileDisp "\\flsv01\�O�d"
			FileDisp "\\flsv01\��s��"
			FileDisp "\\flsv01\���Z�L�����e�B���i��"
			FileDisp "\\flsv01\�É�"
			FileDisp "\\flsv01\���"
			FileDisp "\\flsv01\����"
			FileDisp "\\flsv01\�l��"
			FileDisp "\\flsv01\����"
			FileDisp "\\flsv01\���É�"
			FileDisp "\\flsv01\�S�Ќl���ی�"
			FileDisp "\\flsv01\���V�X�e��"
			FileDisp "\\flsv01\�o�c�Ǘ�"
			FileDisp "\\flsv01\�����o��"
			FileDisp "\\flsv01\�����o���f�[�^����"
			FileDisp "\\flsv01\�l������"
			FileDisp "\\flsv01\������"
			if NetWorkPathZen = true then
				FileDisp "\\flsv01\�����Ǘ�"
			end if
		end if
		
		objWriteFile.WriteLine now() & Separate
		objWriteFile.Close
		
		set objWriteFile = nothing
		Set objDriveC = Nothing
		Set objDriveL = Nothing
		Set objFileSys = Nothing
		set objRE = nothing

	'	����炷
	Dim WAVPATH, PlayTime, ws
	WAVPATH = "%WINDIR%\Media\Alarm05.wav"
	PlayTime = "5000"
	Set ws = CreateObject("Wscript.Shell")
	Dim CommandScript
	CommandScript = "mshta ""about:playing... <OBJECT CLASSID='CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95' ><param name='src' value='WAVPATH'><param name='PlayCount' value='1'><param name='autostart' value='true'></OBJECT><script>setTimeout(function(){window.close()},PlayTime);</script>"""
	CommandScript = Replace(CommandScript, "WAVPATH", WAVPATH)
	CommandScript = Replace(CommandScript, "PlayTime", PlayTime)
	ws.run CommandScript, 0, True


		Msgbox "�������I�����܂����B" & OpenWriteFile & "���Q�Ƃ��������B",vbInformation + vbApplicationModal,"����"
	else
		Msgbox "���~���܂����B",vbInformation + vbApplicationModal,"����"
	end if



