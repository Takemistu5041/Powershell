Set-ExecutionPolicy RemoteSigned -Scope Process


----------------
#SendKeysを使うため、System.Windows.Forms名前空間読込
Add-Type -AssemblyName System.Windows.Forms
Start-Sleep -Seconds 5

#F5起動
Start-Process -FilePath "C:\Program Files (x86)\F5 VPN\f5fpclientW.exe"
Start-Sleep -seconds 10

#F5　入力
[System.Windows.Forms.SendKeys]::SendWait("^%(a)")
Start-Sleep -Seconds 5

#GoogleChrome起動
Start-Process -FilePath　"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
Start-Sleep -Seconds 20

#Sakesfoce
[System.Windows.Forms.SendKeys]::SendWait("^%(a)")
Start-Sleep -Seconds 8

#右のタブに移動
[System.Windows.Forms.SendKeys]::SendWait("^({TAB})")
Start-Sleep -Milliseconds 500
#Google
[System.Windows.Forms.SendKeys]::SendWait("^%(a)")
Start-Sleep -Seconds 13

#Gmailで決定
[System.Windows.Forms.SendKeys]::SendWait("{TAB}{TAB}{ENTER}")
Start-Sleep -Seconds 23

#右のタブに移動
[System.Windows.Forms.SendKeys]::SendWait("^({TAB})")
Start-Sleep -Milliseconds 500
#Rakumo入力
[System.Windows.Forms.SendKeys]::SendWait("^%(a)")
Start-Sleep -Seconds 15

#右のタブに移動
[System.Windows.Forms.SendKeys]::SendWait("^({TAB})")
Start-Sleep -Milliseconds 500
#ハングアウト_画面更新
[System.Windows.Forms.SendKeys]::SendWait("{F5}")
Start-Sleep -Seconds 8

#右のタブに移動　Keep
[System.Windows.Forms.SendKeys]::SendWait("^({TAB})")
Start-Sleep -Seconds 8

#右のタブに移動
[System.Windows.Forms.SendKeys]::SendWait("^({TAB})")
Start-Sleep -Milliseconds 500
#[Ctrl]+[TAB]で右のタブに移動
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
Start-Sleep -Seconds 2
#KOT入力
[System.Windows.Forms.SendKeys]::SendWait("^%(a)")
Start-Sleep -Seconds 6

#前回表示ウインドウに切替
[System.Windows.Forms.SendKeys]::SendWait("%({TAB})")
Start-Sleep -Milliseconds 500

#Chrom起動
Start-Process -FilePath　"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" https://ap7.salesforce.com/a08/o
Start-Sleep -seconds 10

#新しいタブ
[System.Windows.Forms.SendKeys]::SendWait("^t")
Start-Sleep -seconds 3

#GmailのURL入力
[System.Windows.Forms.SendKeys]::SendWait("https://mail.google.com/mail/u/0/#inbox") -WindowStyle
Start-Sleep -seconds 1

#Enter
[System.Windows.Forms.SendKeys]::SendWait("{Enter}")
Start-Sleep -seconds 5

#新しいタブ
[System.Windows.Forms.SendKeys]::SendWait("^t")
Start-Sleep -seconds 3

#RakumoのURL入力
[System.Windows.Forms.SendKeys]::SendWait("https://a-rakumo.appspot.com/calendar#/")
Start-Sleep -seconds 1

#Enter
[System.Windows.Forms.SendKeys]::SendWait("{Enter}")
Start-Sleep -seconds 5

$wsobj = new-object -comobject wscript.shell
$result = $wsobj.popup("打刻")
