'	Netuse.vbs Rev.2
'
'	Copyright 2013 By T.Tanaka
'

Option Explicit
On Error Resume Next

Dim objWshNetwork   ' WshNetwork �I�u�W�F�N�g
Dim strDrive        ' �h���C�u��
Dim strPubFolder    ' ���L�t�H���_��
'Dim strUserName     ' �ڑ����郆�[�U�[��
'Dim strPassword     ' �p�X���[�h

strDrive = "R:"
strPubFolder = "\\192.168.1.220\OQS"

Do

	Set objWshNetwork = WScript.CreateObject("WScript.Network")
	If Err.Number = 0 Then
    		objWshNetwork.MapNetworkDrive strDrive, strPubFolder,false
    		If Err.Number = 0 Then
        		WScript.Echo strDrive & " �h���C�u�� " & _
            		strPubFolder & " �����蓖�Ă܂����B"
			Exit Do
    		Else
    			If Err.Number = -2147024811 Then
    				' ���[�J���f�o�C�X�����g�p�ς݂Ȃ̂Őؒf����
    				objWshNetwork.RemoveNetworkDrive strDrive,True
    				
    				WScript.Echo strDrive & "�h���C�u��ؒf���܂����B"
    			Else
    				WScript.Echo "�G���[: " & Err.Description
    			End If
    		End If
	Else
    		WScript.Echo "�G���[: " & Err.Description
	End If

'	�I�u�W�F�N�g�擾���s�̉\��������̂ň�x������čĎ擾����

	Set objWshNetwork = Nothing
	Err.Clear 

Loop

