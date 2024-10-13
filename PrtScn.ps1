[void]
[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[Windows.Forms.SendKeys]::SendWait("^{PRTSC}")
