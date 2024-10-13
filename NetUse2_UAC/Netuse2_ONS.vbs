'	Netuse.vbs Rev.2
'
'	Copyright 2013 By T.Tanaka
'

Option Explicit
On Error Resume Next

Dim objWshNetwork   ' WshNetwork オブジェクト
Dim strDrive        ' ドライブ名
Dim strPubFolder    ' 共有フォルダ名
'Dim strUserName     ' 接続するユーザー名
'Dim strPassword     ' パスワード

strDrive = "R:"
strPubFolder = "\\192.168.1.220\OQS"

Do

	Set objWshNetwork = WScript.CreateObject("WScript.Network")
	If Err.Number = 0 Then
    		objWshNetwork.MapNetworkDrive strDrive, strPubFolder,false
    		If Err.Number = 0 Then
        		WScript.Echo strDrive & " ドライブに " & _
            		strPubFolder & " を割り当てました。"
			Exit Do
    		Else
    			If Err.Number = -2147024811 Then
    				' ローカルデバイス名が使用済みなので切断する
    				objWshNetwork.RemoveNetworkDrive strDrive,True
    				
    				WScript.Echo strDrive & "ドライブを切断しました。"
    			Else
    				WScript.Echo "エラー: " & Err.Description
    			End If
    		End If
	Else
    		WScript.Echo "エラー: " & Err.Description
	End If

'	オブジェクト取得失敗の可能性もあるので一度解放して再取得する

	Set objWshNetwork = Nothing
	Err.Clear 

Loop

