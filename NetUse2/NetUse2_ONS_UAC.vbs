'
'	管理者権限で「Netuse2_Ons.Vbs」を実行する
'

'wscript.sleep(30000)

Set fso = CreateObject("Scripting.FileSystemObject")
Set obj = Wscript.CreateObject("Shell.Application")
if Wscript.Arguments.Count = 0 then
obj.ShellExecute "cscript.exe",fso.getParentFolderName(WScript.ScriptFullName) & "\netuse2_ONS.vbs" & " runas", "", "runas", 1
Wscript.Quit
end if
