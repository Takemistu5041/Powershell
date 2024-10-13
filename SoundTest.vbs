Dim WAVPATH, PlayTime
WAVPATH = "%WINDIR%\Media\Alarm05.wav"
PlayTime = "5000"
Set ws = CreateObject("Wscript.Shell")
Dim CommandScript
CommandScript = "mshta ""about:playing... <OBJECT CLASSID='CLSID:22D6F312-B0F6-11D0-94AB-0080C74C7E95' ><param name='src' value='WAVPATH'><param name='PlayCount' value='1'><param name='autostart' value='true'></OBJECT><script>setTimeout(function(){window.close()},PlayTime);</script>"""
CommandScript = Replace(CommandScript, "WAVPATH", WAVPATH)
CommandScript = Replace(CommandScript, "PlayTime", PlayTime)
ws.run CommandScript, 0, True
