Set-ExecutionPolicy RemoteSigned -Scope Process


----------------
#SendKeys���g�����߁ASystem.Windows.Forms���O��ԓǍ�
Add-Type -AssemblyName System.Windows.Forms
Start-Sleep -Seconds 5

#F5�N��
Start-Process -FilePath "C:\Program Files (x86)\F5 VPN\f5fpclientW.exe"
Start-Sleep -seconds 10

#F5�@����
[System.Windows.Forms.SendKeys]::SendWait("^%(a)")
Start-Sleep -Seconds 5

#GoogleChrome�N��
Start-Process -FilePath�@"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
Start-Sleep -Seconds 20

#Sakesfoce
[System.Windows.Forms.SendKeys]::SendWait("^%(a)")
Start-Sleep -Seconds 8

#�E�̃^�u�Ɉړ�
[System.Windows.Forms.SendKeys]::SendWait("^({TAB})")
Start-Sleep -Milliseconds 500
#Google
[System.Windows.Forms.SendKeys]::SendWait("^%(a)")
Start-Sleep -Seconds 13

#Gmail�Ō���
[System.Windows.Forms.SendKeys]::SendWait("{TAB}{TAB}{ENTER}")
Start-Sleep -Seconds 23

#�E�̃^�u�Ɉړ�
[System.Windows.Forms.SendKeys]::SendWait("^({TAB})")
Start-Sleep -Milliseconds 500
#Rakumo����
[System.Windows.Forms.SendKeys]::SendWait("^%(a)")
Start-Sleep -Seconds 15

#�E�̃^�u�Ɉړ�
[System.Windows.Forms.SendKeys]::SendWait("^({TAB})")
Start-Sleep -Milliseconds 500
#�n���O�A�E�g_��ʍX�V
[System.Windows.Forms.SendKeys]::SendWait("{F5}")
Start-Sleep -Seconds 8

#�E�̃^�u�Ɉړ��@Keep
[System.Windows.Forms.SendKeys]::SendWait("^({TAB})")
Start-Sleep -Seconds 8

#�E�̃^�u�Ɉړ�
[System.Windows.Forms.SendKeys]::SendWait("^({TAB})")
Start-Sleep -Milliseconds 500
#[Ctrl]+[TAB]�ŉE�̃^�u�Ɉړ�
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
Start-Sleep -Seconds 2
#KOT����
[System.Windows.Forms.SendKeys]::SendWait("^%(a)")
Start-Sleep -Seconds 6

#�O��\���E�C���h�E�ɐؑ�
[System.Windows.Forms.SendKeys]::SendWait("%({TAB})")
Start-Sleep -Milliseconds 500

#Chrom�N��
Start-Process -FilePath�@"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://ap7.salesforce.com/a08/o
Start-Sleep -seconds 10

#�V�����^�u
[System.Windows.Forms.SendKeys]::SendWait("^t")
Start-Sleep -seconds 3

#Gmail��URL����
[System.Windows.Forms.SendKeys]::SendWait("https://mail.google.com/mail/u/0/#inbox") -WindowStyle
Start-Sleep -seconds 1

#Enter
[System.Windows.Forms.SendKeys]::SendWait("{Enter}")
Start-Sleep -seconds 5

#�V�����^�u
[System.Windows.Forms.SendKeys]::SendWait("^t")
Start-Sleep -seconds 3

#Rakumo��URL����
[System.Windows.Forms.SendKeys]::SendWait("https://a-rakumo.appspot.com/calendar#/")
Start-Sleep -seconds 1

#Enter
[System.Windows.Forms.SendKeys]::SendWait("{Enter}")
Start-Sleep -seconds 5

$wsobj = new-object -comobject wscript.shell
$result = $wsobj.popup("�ō�")
