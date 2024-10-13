Option Explicit

'2015/11/06		DD系とORCAのダンプが引っかからないので修正
'2016/05/10		正規表現によるチェックに変更
'				検索パターンの追加
'2016/05/11		検索パターンの追加
'2016/05/12		UNCパス検索の追加
'2016/09/13		検査依頼ファイル検索の追加
'2017/06/09		CSVファイル検索の追加
'2018/09/03		Windowsの一部フォルダを除外

public const strVersion = "2019/05/20"
public objWriteFile
'***************************************************************************************************************
' Sub and Function
'***************************************************************************************************************

Function CHKPattern(objRE ,strPattern ,strData)

	With objRE
		.Pattern = strPattern	''検索パターンを設定
		.IgnoreCase = True		''大文字と小文字を区別しない
		.Global = True			''文字列全体を検索
		If .Test(strData) Then
			CHKPattern = True
		Else
			CHKPattern = False
		End If
	End With

End Function

Sub CommonCHK(objRE ,strFileName ,strWorkPath ,strFile ,strExt ,checkflg ,folderflg ,strRiyu)

	'***************
	'主に画像
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
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\00_ビルドモジュール\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DD2共有\\51.セットアップファイル\\DD2開発中セットアップ\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\09.運用手順書（マニュアル）\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\11.セットアップ関連\\セットアップCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\13.ソース\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\14-ビルドモジュール\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\14-ビルドモジュール_old\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\オプション関連\\■■旧オプション関連\\他システムインストーラ等\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\オプション関連\\■他社連携仕様書\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\オプション関連\\■各連携手順書\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\開発チーム作業用\\pcAnywhere\12.5フル\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\開発チーム作業用\\インストーラ\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\マスタ－管理\\PcAnywhere12.5\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\CS支援課\\【医科】発送資料\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\CS支援課\\日立\\Hi-SEED\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\CS支援課\\日立\\Hi-SEED W3\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\CS支援課\\日立\\Hi-SEED W3\(R\)※共通\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\CS支援課\\日立\\Hi-SEED W3R\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\CS支援課\\日立\\Pre-SEED\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\CS支援課\\日立\\Pre-SEED AS\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\DDTOP共有\\09-発送関連\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\DDTOP共有\\DDTOP_提供マニュアル\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\DDTOP共有\\セットアップ手順書\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■GooCo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■Hi-story\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■Pharma-SEED\\インストーラー\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(NS\)\\【CD】バージョンアップツール\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(NS\)\\【CD】保険薬局システムＮＳセットアップCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(VER6\)\\【CD】JAPIC添付文書差分データ\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(VER6\)\\【CD】MDB画像\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\コールセンター対応時添付資料\\医科\\地方公費\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\サービス部門\\2015-2016スギ入替資料\\レセコン撤去機写真\\" ,strWorkPath) _
				) then
			checkflg = true : strRiyu = "画像要確認"
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
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\00_ビルドモジュール\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DD2共有\\51.セットアップファイル\\DD2開発中セットアップ\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\09.運用手順書（マニュアル）\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\11.セットアップ関連\\セットアップCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\13.ソース\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\14-ビルドモジュール\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\14-ビルドモジュール_old\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\オプション関連\\■■旧オプション関連\\他システムインストーラ等\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\オプション関連\\■他社連携仕様書\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\オプション関連\\■各連携手順書\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\開発チーム作業用\\pcAnywhere\12.5フル\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\開発チーム作業用\\インストーラ\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\マスタ－管理\\PcAnywhere12.5\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■GooCo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■Hi-story\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■Pharma-SEED\\インストーラー\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(NS\)\\【CD】バージョンアップツール\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(NS\)\\【CD】保険薬局システムＮＳセットアップCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(VER6\)\\【CD】JAPIC添付文書差分データ\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(VER6\)\\【CD】MDB画像\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\コールセンター対応時添付資料\\医科\\地方公費\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\サービス部門\\2015-2016スギ入替資料\\レセコン撤去機写真\\" ,strWorkPath) _
				) then
			checkflg = true : strRiyu = "画像要確認"
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
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\00_ビルドモジュール\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DD2共有\\51.セットアップファイル\\DD2開発中セットアップ\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\09.運用手順書（マニュアル）\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\11.セットアップ関連\\セットアップCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\13.ソース\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\14-ビルドモジュール\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\14-ビルドモジュール_old\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\オプション関連\\■■旧オプション関連\\他システムインストーラ等\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\オプション関連\\■他社連携仕様書\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\オプション関連\\■各連携手順書\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\開発チーム作業用\\pcAnywhere\12.5フル\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\開発チーム作業用\\インストーラ\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\マスタ－管理\\PcAnywhere12.5\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■GooCo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■Hi-story\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■Pharma-SEED\\インストーラー\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(NS\)\\【CD】バージョンアップツール\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(NS\)\\【CD】保険薬局システムＮＳセットアップCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(VER6\)\\【CD】JAPIC添付文書差分データ\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(VER6\)\\【CD】MDB画像\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\コールセンター対応時添付資料\\医科\\地方公費\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\サービス部門\\2015-2016スギ入替資料\\レセコン撤去機写真\\" ,strWorkPath) _
				) then
			checkflg = true : strRiyu = "画像要確認"
		End if
	End if

	'***************
	'主にスターフレンド
	if CHKPattern(objRE ,"BS.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "スターフレンド"
	End if

	'***************
	'主にサービスフレンド
	if CHKPattern(objRE ,"HH.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "サービスフレンド"
	End if
	if CHKPattern(objRE ,"BT.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "サービスフレンド"
	End if
	if CHKPattern(objRE ,"PW.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "サービスフレンド"
	End if
	if CHKPattern(objRE ,"CN.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "サービスフレンド"
	End if

	'***************
	'主に請求システム
	if CHKPattern(objRE ,"KAIGO[0-9]{2}.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "請求システム"
	End if

	'***************
	'主に全銀交換ファイルシステム
	if CHKPattern(objRE ,"BANKIF.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "全銀交換ファイルシステム"
	End if

	'***************
	'主に歯科システム
	if CHKPattern(objRE ,"一括[0-9]{3}.*\.lzh$" ,strFileName) then
		checkflg = true : strRiyu = "歯科システム"
	End if
	if CHKPattern(objRE ,"毎日[0-9]{3}.*\.lzh$" ,strFileName) then
		checkflg = true : strRiyu = "歯科システム"
	End if
	if CHKPattern(objRE ,"receipt.*\.mdb$" ,strFileName) then
		checkflg = true : strRiyu = "歯科システム"
	End if
	if CHKPattern(objRE ,"[0-9]{6}.*MST.*\.mdb$" ,strFileName) then
		checkflg = true : strRiyu = "歯科システム"
	End if
	if CHKPattern(objRE ,"[0-9]{6}.*BYO.*\.mdb$" ,strFileName) then
		checkflg = true : strRiyu = "歯科システム"
	End if
	if CHKPattern(objRE ,"DRDB[0-9]{4}.*\.INI$" ,strFileName) then
		checkflg = true : strRiyu = "歯科システム"
	End if
	if CHKPattern(objRE ,"REZEDEN.*\.INI$" ,strFileName) then
		checkflg = true : strRiyu = "歯科システム"
	End if
	if CHKPattern(objRE ,"REZEPATH.*\.INI$" ,strFileName) then
		checkflg = true : strRiyu = "歯科システム"
	End if
	if CHKPattern(objRE ,"mitsumo.*\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "歯科システム"
	End if
	if CHKPattern(objRE ,"ModeKep1.*\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "歯科システム"
	End if

	'***************
	'接続情報
	if CHKPattern(objRE ,"接続情報.*\.mdb$" ,strFileName) then
		checkflg = true : strRiyu = "接続情報"
	End if

	'***************
	'VPN接続管理
	if CHKPattern(objRE ,"VPN接続管理.*.exe$" ,strFileName) then
		checkflg = true : strRiyu = "接続情報"
	End if

	'***************
	'CSV
	if CHKPattern(objRE ,".*.csv$" ,strFileName) then
		checkflg = true : strRiyu = "CSVファイル"
	End if

	'***************
	'主にHi-SEED
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
	'主にORCA
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
	'主にDDtop
	if CHKPattern(objRE ,"ddii.*\.enc\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "DDtop"
	End if
	if CHKPattern(objRE ,"DDtop_.*_[0-9]{8}.log$" ,strFileName) then
		checkflg = true : strRiyu = "DDtop"
	End if

	'***************
	'主にDD2
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
	'主にDDtop、DD2
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
	'主にDD2、DW2
	if CHKPattern(objRE ,"datadb.*\.lzh$" ,strFileName) then
		checkflg = true : strRiyu = "DD2 or DW2"
	End if
	if CHKPattern(objRE ,"masterdb.*\.lzh$" ,strFileName) then
		checkflg = true : strRiyu = "DD2 or DW2"
	End if
	'主にDW2
	if CHKPattern(objRE ,"datadb.*\.mdf$" ,strFileName) then
		checkflg = true : strRiyu = "DD2 or DW2"
	End if
	if CHKPattern(objRE ,"masterdb.*\.mdf$" ,strFileName) then
		checkflg = true : strRiyu = "DD2 or DW2"
	End if
	'主にDW2
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
	'主にSuperClinic
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
	'主にPre-SEED
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
	'主にMOA C's
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
	'主にべてらん君
	if CHKPattern(objRE ,"SY[0-9]{6}GAI\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "べてらん君"
	End if
	if CHKPattern(objRE ,"KO[0-9]{6}GAI\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "べてらん君"
	End if
	if CHKPattern(objRE ,"SY[0-9]{6}NYU\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "べてらん君"
	End if
	if CHKPattern(objRE ,"KO[0-9]{6}NYU\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "べてらん君"
	End if
	if CHKPattern(objRE ,"履歴データ[0-9]{14}\.zip$" ,strFileName) then
		checkflg = true : strRiyu = "べてらん君"
	End if

	'***************
	'レセ電点検ファイル
	if CHKPattern(objRE ,"checkfile_.*\.UKE$" ,strFileName) then
		checkflg = true : strRiyu = "レセ電点検ファイル"
	End if
	if CHKPattern(objRE ,"[0-9]{6}[SK]1RECEIPT.*\.UKEA$" ,strFileName) then
		checkflg = true : strRiyu = "レセ電点検ファイル"
	End if

	'***************
	'レセ電ファイル
	if CHKPattern(objRE ,"RECEIPT.\.UKE$" ,strFileName) then
		checkflg = true : strRiyu = "レセ電ファイル"
	End if
	if CHKPattern(objRE ,"RECEIPT.\.UKEA$" ,strFileName) then
		checkflg = true : strRiyu = "レセ電点検ファイル"
	End if
	if CHKPattern(objRE ,"RECEIPT.\.CYO$" ,strFileName) then
		checkflg = true : strRiyu = "レセ電ファイル"
	End if
	if CHKPattern(objRE ,"RECEIPT.\.HEN$" ,strFileName) then
		checkflg = true : strRiyu = "レセ電ファイル"
	End if
	if CHKPattern(objRE ,"RECEIPT.\.SAH$" ,strFileName) then
		checkflg = true : strRiyu = "レセ電ファイル"
	End if
	if CHKPattern(objRE ,"RECEIPT_[0-9]{6}.*\.ZIP$" ,strFileName) then
		checkflg = true : strRiyu = "レセ電ファイル"
	End if
'調剤の労災レセ電ファイル
	if CHKPattern(objRE ,"RREY.*\.CYO$" ,strFileName) then
		checkflg = true : strRiyu = "レセ電ファイル"
	End if
	if CHKPattern(objRE ,"RREY[0-9]{4}\.CYO$" ,strFileName) then
		checkflg = true : strRiyu = "レセ電ファイル"
	End if

	'***************
	'主にPharma-SEED
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
	'主にNSIPS
	if CHKPattern(objRE ,"[ADBUadbu][0-9]{20}\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "NSIPS"
	End if

	'***************
	'主にめいと
	if CHKPattern(objRE ,"YSBACK01$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"chozai[0-9]{2}.*\.mdf$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"chozai[0-9]{2}.*\.ldf$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"chozai[0-9]{2}.*\.mdf.*$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"chozai[0-9]{2}.*\.ldf.*$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"RECEIPTY_[0-9]{6}_[SKsk]\.CYO$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"KZ[0-9]{6}\.CSV$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"[0-9]{5}-[0-9]{2}\.tif$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"^[0-9]{4}\.dat$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"KANZY\.TXT$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"[0-9]{8}\.tif$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"[0-9]{1,8}\.tif$" ,strFileName) then
		if CHKPattern(objRE ,"\\.*DATA[0-9].*$" ,strWorkPath) then
			checkflg = true : strRiyu = "ぶんぎょうめいと"
			folderflg = true
		End if
	End if
	if CHKPattern(objRE ,"kanja\.log$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	'if CHKPattern(objRE ,"フォルダ名\.log$" ,strFileName) then
	'	checkflg = true : strRiyu = "ぶんぎょうめいと"
	'End if
	if CHKPattern(objRE ,"meisai\.log$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"trnerr.*\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"trnerr2.*\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"jyufuku.*\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"kanerror.*\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"BUHN.*\.CSV$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"YS080_[0-9]{4}[0-9]{2}\.csv$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"KEN[0-9]{7}\.csv$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"OS050_22_4[0-9]{2}[0-9]{2}_KEN[0-9]{7}\.csv$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"214[0-9]{7}\.csv$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"OS050_21_4[0-9]{2}[0-9]{2}_KEN[0-9]{7}[0-9]{2}[0-9]{2}\.csv$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"M_SYOHO.*\.TXT$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
	End if
	if CHKPattern(objRE ,"\\.*CNV.*\\[0-9]{14,18}$" ,strWorkPath) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
		folderflg = true
	End if
	if CHKPattern(objRE ,"\\.*IJIDATA.*$" ,strWorkPath) then
		checkflg = true : strRiyu = "ぶんぎょうめいと"
		folderflg = true
	End if
	'*****************************	薬歴の表紙をどうしますか？

	'***************
	'主にめいとＮＳ
	if CHKPattern(objRE ,"SA12Elixir\.DB$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいとＮＳ"
	End if
	if CHKPattern(objRE ,"SA12Elixir\.log$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいとＮＳ"
	End if
	if CHKPattern(objRE ,"SA12Zaiko\.DB$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいとＮＳ"
	End if
	if CHKPattern(objRE ,"SA12Zaiko\.log$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいとＮＳ"
	End if
	if CHKPattern(objRE ,"SYAHO.*\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいとＮＳ"
	End if
	if CHKPattern(objRE ,"KOKUHO.*\.txt$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいとＮＳ"
	End if
	if CHKPattern(objRE ,"K[0-9]{7}\.CSV$" ,strFileName) then		'******************* 要確認
		checkflg = true : strRiyu = "ぶんぎょうめいとＮＳ"
	End if

	'***************
	'主にめいとＮＥＸＴ
	if CHKPattern(objRE ,"BK[0-9]{4}[0-9]{2}[0-9]{2}[0-9]{2}[0-9]{2}[0-9]{2}[A-Z]{3}Ver.*\.cph$" ,strFileName) then
		checkflg = true : strRiyu = "ぶんぎょうめいとＮＥＸＴ"
	End if

	'***************
	'主にワンズ、レモラ
	if CHKPattern(objRE ,"PWA.*\.DAT$" ,strFileName) then
		checkflg = true : strRiyu = "ワンズ、レモラ"
	End if

	'***************
	'主にGooco
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
	'主にHi-story
	if CHKPattern(objRE ,"HI-STORY_BACKUP.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "Gooco"
	End if

	'***************
	'主にHi-story
	if CHKPattern(objRE ,"[0-9]{8}\.txt$" ,strFileName) then
		if CHKPattern(objRE ,"\\.*RVDATA.*$" ,strWorkPath) then
			checkflg = true : strRiyu = "調剤データ渡し"
			folderflg = true
		End if
	End if

	'***************
	'主にSugi
	if CHKPattern(objRE ,"sugidb_dat.*\.mdb$" ,strFileName) then
		checkflg = true : strRiyu = "Ｓｕｇｉ"
	End if
	if CHKPattern(objRE ,"sugidb_log.*\.ldf$" ,strFileName) then
		checkflg = true : strRiyu = "Ｓｕｇｉ"
	End if
	if CHKPattern(objRE ,"sugidb.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "Ｓｕｇｉ"
	End if
	if CHKPattern(objRE ,"sugidb_log.*\.bak$" ,strFileName) then
		checkflg = true : strRiyu = "Ｓｕｇｉ"
	End if

	'***************
	'主にコンバートツールデータ
	if CHKPattern(objRE ,"BUHN.*\.mdb$" ,strFileName) then
		checkflg = true : strRiyu = "MS-Access要確認"
	End if



    ''レセ電ファイル
    'If strExt = "UKE" Or strExt = "UKEA" Or strExt = "CYO" Or strExt = "HEN" Or strExt = "SAH" _
    '	or InStr(strFile, "RECEIPTC") <> 0 or InStr(strFile, "RECEIPTY") <> 0 Then
    '    checkflg = True
    'End If

	'***************
	'画像は？
	'***************

	'***************
	'主にPDF
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
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\00_ビルドモジュール\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DD2共有\\51.セットアップファイル\\DD2開発中セットアップ\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\09.運用手順書（マニュアル）\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\11.セットアップ関連\\セットアップCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\13.ソース\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\14-ビルドモジュール\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\DDTOP共有\\14-ビルドモジュール_old\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\オプション関連\\■■旧オプション関連\\他システムインストーラ等\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\オプション関連\\■他社連携仕様書\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\オプション関連\\■各連携手順書\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\開発チーム作業用\\pcAnywhere\12.5フル\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\nas01-a2\\開発チーム作業用\\インストーラ\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\システム開発\\マスタ－管理\\PcAnywhere12.5\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■GooCo\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■Hi-story\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■Pharma-SEED\\インストーラー\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(NS\)\\【CD】バージョンアップツール\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(NS\)\\【CD】保険薬局システムＮＳセットアップCD\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(VER6\)\\【CD】JAPIC添付文書差分データ\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\■調剤システム\\■ぶんぎょうめいと\(VER6\)\\【CD】MDB画像\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\コールセンター対応時添付資料\\医科\\地方公費\\" ,strWorkPath) _
				or CHKPattern(objRE ,"^\\\\flsv01\\全社展開\\サービス部門\\2015-2016スギ入替資料\\レセコン撤去機写真\\" ,strWorkPath) _
				) then
			checkflg = true : strRiyu = "ＰＤＦ要確認"
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
		exit sub				'************* エラーなら抜ける（アクセス権がない）
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
			'ZIPは？中身を見ますか？
			'***************
			'***************
			'主にZIP書庫
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
					checkflg = true : strRiyu = "ＺＩＰ書庫要確認"
				End if
			End if
			'主にtar書庫
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
					checkflg = true : strRiyu = "ＴＡＲ書庫要確認"
				End if
			End if

			Call CommonCHK(objRE ,strFileName ,strWorkPath ,strFile ,strExt ,checkflg ,folderflg ,strRiyu)


			'ファイルの種類により除外する
			'if objFl.Type = "アプリケーション" or objFl.Type = "アプリケーション拡張" or objFl.Type = "構成設定" _
			'	or objFl.Type = "ショートカット" then
			'	checkflg = false
			'end if
			if checkflg = true then
				if folderflg = true then
					'フォルダの場合
					on error resume next
					objWriteFile.WriteLine chr(&h22) & objFl.ParentFolder.Path & chr(&h22) & "," & "" _
							& "," & chr(&h22) & objFl.ParentFolder.Path & chr(&h22) _
							& "," & strRiyu & "," & "フォルダ（ファイル有り）" & "," & cstr(Int(objFl.Size / 1024)) _
							& "," & cstr(objFl.DateCreated) & "," & cstr(objFl.DateLastAccessed) & "," & cstr(objFl.DateLastModified)
					if err <> 0 then
						'msgbox "エラー発生" & vbcrlf & vbcrlf & "ファイルパス" & vbcrlf & objFl.ParentFolder.Path
					end if
					on error goto 0
					'フォルダの場合は、for nextを抜ける（それ以下を確認してもあまり意味がないので）
					exit for
				else
					on error resume next
					objWriteFile.WriteLine chr(&h22) & objFs.GetBaseName(objFl.Path) & chr(&h22) & "," & objFs.GetExtensionName(objFl.Path) _
							& "," & chr(&h22) & objFl.ParentFolder.Path & chr(&h22) _
							& "," & strRiyu & "," & objFl.Type & "," & cstr(Int(objFl.Size / 1024)) _
							& "," & cstr(objFl.DateCreated) & "," & cstr(objFl.DateLastAccessed) & "," & cstr(objFl.DateLastModified)
					if err <> 0 then
						'msgbox "エラー発生" & vbcrlf & vbcrlf & "ファイルパス" & vbcrlf & objFl.Path
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
	' 変数定義
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
	' 定数定義
	'-------------------------------------
	Const ForReading = 1 
	Const ForWriting = 2 
	Const OpenWriteFile = "checkfile5.csv"
	Const Separate = ",,,,,,,"

	Ans = Msgbox ("ファイルのチェックを開始します。" & vbcrlf & vbcrlf _
			& "※ 終了メッセージが表示されるまで、" & vbcrlf _
			& "　 結果ファイルを開かないでください。" _
			,vbInformation + vbSystemModal + vbYesNo,"確認　Ver." & strVersion)
	if Ans=vbYes then 
		NetWorkDrive = False
		NetWorkDriveOnly = False
		NetWorkPath = False
		NetWorkPathZen = False
		Ans = Msgbox ("ネットワークドライブのチェックを" & vbcrlf _
				& "行いますか？" _
				,vbInformation + vbSystemModal + vbYesNo,"確認")
		if Ans = vbYes then
			NetWorkDrive = True
			Ans = Msgbox ("ネットワークドライブだけのチェックを" & vbcrlf _
					& "行いますか？" _
					,vbInformation + vbSystemModal + vbYesNo + vbDefaultButton2,"確認")
			if Ans = vbYes then
				NetWorkDriveOnly = True
			end if
		end if
		Ans = Msgbox ("アクセス可能な、ネットワークパスの" & vbcrlf _
				& "チェックを行いますか？" _
				,vbInformation + vbSystemModal + vbYesNo + vbDefaultButton2,"確認")
		if Ans = vbYes then
			NetWorkPath = True
			Ans = Msgbox ("ネットワークパスのチェックに" & vbcrlf _
					& "文書管理を含めますか？" _
					,vbInformation + vbSystemModal + vbYesNo + vbDefaultButton2,"確認")
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
		objWriteFile.WriteLine "名前,拡張子,親フォルダ名,チェック理由,種類,サイズ(KB),作成年月日,最終アクセス年月日,更新年月日"

		Set objRE = CreateObject("VBScript.RegExp")

		'WScript.Echo "このコンピュータのドライブ一覧"

		For Each objDriveL In objFileSys.Drives
			If objFileSys.DriveExists(objDriveL) = True Then
				Set objDriveC = objFileSys.GetDrive(objDriveL)
				'WScript.echo "ドライブのレター　　　：" & objDriveL
				'WScript.echo "ドライブの種類　　　　：" & objDriveC.DriveType
				' 1 リムーバブル系
				' 2 HDD
				' 3 ネットワーク系
				' 4 CD系
				'WScript.echo "ディスクが使用可能？　：" & objDriveC.IsReady
				if objDriveC.IsReady = true and objDriveC.DriveType <> 3 and Not NetWorkDriveOnly _
					or objDriveC.IsReady = true and objDriveC.DriveType = 3 and NetWorkDrive then
					'FileDisp objDriveL , objWriteFile
					FileDisp objDriveL & "\"
				end if
			end if
		Next
		if NetWorkPath = true then
			FileDisp "\\flsv01\cs企画"
			FileDisp "\\flsv01\システム開発"
			FileDisp "\\flsv01\営業企画"
			FileDisp "\\flsv01\営業推進"
			FileDisp "\\flsv01\沖縄"
			FileDisp "\\flsv01\広島"
			FileDisp "\\flsv01\札幌"
			FileDisp "\\flsv01\三重"
			FileDisp "\\flsv01\首都圏"
			FileDisp "\\flsv01\情報セキュリティ推進室"
			FileDisp "\\flsv01\静岡"
			FileDisp "\\flsv01\大阪"
			FileDisp "\\flsv01\長野"
			FileDisp "\\flsv01\浜松"
			FileDisp "\\flsv01\福岡"
			FileDisp "\\flsv01\名古屋"
			FileDisp "\\flsv01\全社個人情報保護"
			FileDisp "\\flsv01\情報システム"
			FileDisp "\\flsv01\経営管理"
			FileDisp "\\flsv01\財務経理"
			FileDisp "\\flsv01\財務経理データ交換"
			FileDisp "\\flsv01\人事総務"
			FileDisp "\\flsv01\役員会"
			if NetWorkPathZen = true then
				FileDisp "\\flsv01\文書管理"
			end if
		end if
		
		objWriteFile.WriteLine now() & Separate
		objWriteFile.Close
		
		set objWriteFile = nothing
		Set objDriveC = Nothing
		Set objDriveL = Nothing
		Set objFileSys = Nothing
		set objRE = nothing

	'	音を鳴らす
	Dim WAVPATH, PlayTime, ws
	WAVPATH = "%WINDIR%\Media\Alarm05.wav"
	PlayTime = "5000"
	Set ws = CreateObject("Wscript.Shell")
	Dim CommandScript
	CommandScript = "mshta ""about:playing... <OBJECT CLASSID='CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95' ><param name='src' value='WAVPATH'><param name='PlayCount' value='1'><param name='autostart' value='true'></OBJECT><script>setTimeout(function(){window.close()},PlayTime);</script>"""
	CommandScript = Replace(CommandScript, "WAVPATH", WAVPATH)
	CommandScript = Replace(CommandScript, "PlayTime", PlayTime)
	ws.run CommandScript, 0, True


		Msgbox "処理が終了しました。" & OpenWriteFile & "を参照ください。",vbInformation + vbApplicationModal,"結果"
	else
		Msgbox "中止しました。",vbInformation + vbApplicationModal,"結果"
	end if



