@echo off
cls
openfiles > NUL 2>&1 


echo 「PCNAME999」を正しいPC名に変更　(例)　山田クリニック　YAMAONS01

pause


echo デスクトップにアイコンを表示させる

echo コンピュータ　
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {20D04FE0-3AEA-1069-A2D8-08002B30309D} /t REG_DWORD /d 0 /f
echo.
rem echo ユーザーのファイル
rem reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {59031a47-3f72-44a7-89c5-5595fe6b30ee} /t REG_DWORD /d 0 /f
echo.
echo ネットワーク
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t REG_DWORD /d 0 /f
echo.
echo ごみ箱
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {645FF040-5081-101B-9F08-00AA002F954E} /t REG_DWORD /d 0 /f
echo.
echo コントロールパネル
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v {5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0} /t REG_DWORD /d 0 /f
echo.
echo プリンター
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{2227a280-3aea-1069-a2de-08002b30309d}" /f 
echo.
echo.

echo 復元ポイントを有効にして、容量をCドライブの5%で設定します。
powershell -command "Enable-ComputerRestore -Drive C:"
vssadmin resize shadowstorage /for=C: /on=C: /maxsize=5%%
echo.
echo.

echo フォルダオプション設定
echo エクスプローラーで開く　PC
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t "REG_DWORD" /d "1" /f
echo.
echo 最近使ったファイル　クイックアクセス無効
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t "REG_DWORD" /d "0" /f
echo.
echo よく使うフォルダ　クイックアクセス無効
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t "REG_DWORD" /d "0" /f 
echo.
echo すべてのフォルダーを表示
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NavPaneShowAllFolders" /t REG_DWORD /d "1" /f
echo.
echo 隠しファイル、隠しフォルダー、および隠しドライブを表示する
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f
echo.
echo 登録されている拡張子は表示しない
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "0" /f
echo.
echo 保護されたオペレーション システム ファイルを表示しない
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d "0" /f
echo.
echo.

echo 電源管理

echo "電源ボタンを押したときの動作 バッテリー　シャットダウン"
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\7648EFA3-DD9C-4E3E-B566-50F929386280" /v DCSettingIndex /t REG_DWORD /d 3 /f
echo.
echo "電源ボタンを押したときの動作 電源　シャットダウン"
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\7648EFA3-DD9C-4E3E-B566-50F929386280" /v ACSettingIndex /t REG_DWORD /d 3 /f
echo.
echo "スリープボタンを押したときの動作 バッテリー　何もしない"
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\96996BC0-AD50-47EC-923B-6F41874DD9EB" /v  DCSettingIndex /t REG_DWORD /d 0 /f
echo.
echo "スリープボタンを押したときの動作 電源　何もしない"
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Power\PowerSettings\96996BC0-AD50-47EC-923B-6F41874DD9EB" /v  ACSettingIndex /t REG_DWORD /d 0 /f
echo.
echo "高速スタートアップ　無効"
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f
echo.
echo "スリープ　無効"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v ShowSleepOption /t REG_DWORD /d 0 /f
echo.
echo.

echo ハードディスク
echo 次の時間が経過後ハードディスクの電源を切る　なし
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0
echo.

echo デスクトップ背景の設定
echo スライド ショー　一時停止
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 001
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 0d7dbae2-4294-402a-ba8e-26777e8488cd 309dce9b-bef4-4119-9921-a851fb12f0f4 001
echo.


echo スリープ
echo 次の時間が経過後スリープしない
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
echo.
echo システム無人スリープのタイムアウト 表示させる
powercfg -attributes SUB_SLEEP 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 -ATTRIB_HIDE
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0
echo.
echo ハイブリッド スリープを許可する　オフ
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 000
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 000
echo.
echo 次の時間が経過後休止状態にする　オフ
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0
echo.
echo スリープ解除タイマーの許可　無効
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 000
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 000
echo.

echo 電源ボタンとカバー
echo カバーを閉じたときの操作　なにもしない
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 000
echo.
echo 電源ボタンの操作　シャットダウン
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 003
echo.
echo スリープボタンの操作　なにもしない
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 000
echo.

echo PCI Express
echo リンク状態の電源管理　オフ
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 000
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 000
echo.

echo プロセッサの電源管理
echo 最小のプロセッサの状態の　100%
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 100
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 100
echo.
echo システムの冷却ポリシー　アクティブ（プロセッサ速度を落とす前にファン速度を上げる）
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 001
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 94d3a615-a899-4ac5-ae2b-e4d8f634367f 001
echo.
echo 最大のプロセッサの状態　100%
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100
echo.

echo ディスプレイ
echo 次の時間が経過後ディスプレイの電源を切らない
powercfg -SetAcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
powercfg -SetDcValueIndex 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
echo.
echo.


echo Windowsで通常使うプリンタを管理する　無効
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v LegacyDefaultPrinterMode /t REG_DWORD /d 1 /f
echo.

echo セーフモードに F8起動 で入れるようにする
bcdedit /set {default} bootmenupolicy legacy
echo.
echo.


echo Firewall VPNでPingを返す
echo ドメイン側にプライベートも追加
netsh advfirewall firewall set rule name="ファイルとプリンターの共有 (エコー要求 - ICMPv4 受信)" profile=domain new enable=yes profile=domain,private remoteip=any
echo.
echo プライベート、パブリック側をパブリックのみに変更
netsh advfirewall firewall set rule name="ファイルとプリンターの共有 (エコー要求 - ICMPv4 受信)" profile=private,public new enable=no profile=public
echo.
echo IEのホームページをGoogleに設定
reg add "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "https://www.google.co.jp" /f
rem reg delete "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main" /v "Secondary Start Pages" /f
echo.
echo.
echo デバイスの暗号化をオフに変更
powershell -command "manage-bde -off C:"
echo.
echo. 
echo ネットワークに接続されているデバイスの自動セットアップを無効にする
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\NcdAutoSetup\Private" /v AutoSetup /t REG_DWORD /d 0 /f
echo.
echo.

echo タスクバー
echo “タスクバーのボタン”をタスク バーに入りきらない場合に結合
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarGlomLevel /t REG_DWORD /d 1 /f
echo.
echo “タスクバーに常にすべてのアイコンと通知を表示する”にチェックを入れる
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" /v EnableAutoTray /t REG_DWORD /d 0 /f
echo.
echo 小さいタスクバーボタンを使う
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarSmallIcons /t REG_DWORD /d 1 /f
echo.
echo.


echo "顔認証付きリーダーはpanasonicですか(y/n)?"
choice

if %errorlevel%==1 (goto :no_start)
echo.
echo スクリーンセーバ設定→3D
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v SCRNSAVE.EXE /t REG_SZ /d "ssText3d.scr" /f
echo.
echo 待ち時間→15分(900秒)
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaveTimeOut /t REG_SZ /d "900" /f
echo.
echo 再開時ににログオン画面に戻るのチェックを外す　○1:有効
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v ScreenSaverIsSecure /t REG_SZ /d "1" /f

:no_start

rem ネットワークアダプタ名変更　オン資用
netsh -c interface set interface name="イーサネット" newname=オン資用

rem　ネットワークアダプタ名変更　連携用
netsh -c interface set interface name="イーサネット 2" newname=連携用

echo.
echo "オン資用：IPv4外す、連携用：IPv6外す"
powershell -command "Set-NetAdapterBinding -Name """オン資用""" -ComponentID """ms_tcpip""" -Enabled $false
powershell -command "Set-NetAdapterBinding -Name """連携用""" -ComponentID """ms_tcpip6""" -Enabled $false
echo.
pause
rem Disable-NetAdapterBinding -Name "オン資用" -ComponentID ms_tcpip4
rem Get-NetAdapterBinding -Name "連携用" -ComponentID ms_tcpip4



rem プロキシON
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyEnable /t reg_dword /d 1

rem プロキシ設定
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyServer /t reg_sz /d http://proxy.base.oqs-pdl.org:8080

rem プロキシ　例外に192.168.220.1
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings" /f /v ProxyOverride /t reg_sz /d "*.onshikaku.org;*.flets-east.jp;*.flets-west.jp;*.lineauth.mnw;*.obn.managedpki.ne.jp;*.cybertrust.ne.jp;*.secomtrust.net;*.rece;pweb.base.oqs-pdl.org;*.kenporen.com;192.168.220.1"


echo　オン資フォルダ作成
mkdir C:\Users\OqsComApp\Documents\オン資


echo PC名変更
wmic computersystem where name="%computername%" call rename name="PCNAME999"


echo　自動ログイン ユーザアカウント画面でユーザがにチェックを入れる
netplwiz

pause

echo　自動ログイン　ユーザアカウント画面でユーザがにチェックを外してPW入力
netplwiz

