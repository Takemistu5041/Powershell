#
#   SetDigikarExclusionProxy.ps1
#
#   デジカル用プロキシ設定追加
#
#
#

#   ログインユーザチェック

$User = whoami.exe

$Check_User = $User.split("\")

if((($Check_User[$Check_User.count -1]).ToUpper()) -ne "OQSCOMAPP"){
    Read-Host "OQSComAppアカウントでログインして下さい。`r`n何かキーを押してください。"
    exit
}


#   管理者権限チェック
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrators")) {
    #Start-Process powershell.exe "-WindowStyle Hidden -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs
    Start-Process powershell.exe " -executionpolicy remotesigned -File `"$PSCommandPath`"" -Verb RunAs;

    exit
}

#   フォーム用宣言
Add-Type -Assembly System.Windows.Forms

#
#   選択肢の作成
#
$typename = "System.Management.Automation.Host.ChoiceDescription"
$yes = new-object $typename("&Yes","はい")
$no  = new-object $typename("&No","いいえ")

#
#   選択肢コレクションの作成
#
$assembly= $yes.getType().AssemblyQualifiedName
$Choice = new-object "System.Collections.ObjectModel.Collection``1[[$assembly]]"
$Choice.add($yes)
$Choice.add($no)


#
#   プロキシ確認
#

#   IEの設定をインポート
netsh winhttp import proxy source=ie
$Proxy_Result = netsh winhttp show proxy
if(($Proxy_Result -match '直接アクセス') -or ($Proxy_Result -match 'Direct access')){
    #   プロキシなし、追加
    write-host "プロキシが設定されていません。設定します【Fix】"
    write-host "プロキシのオン・オフはブラウザの設定から行って下さい。"
    netsh winhttp set proxy proxy-server="proxy.base.oqs-pdl.org:8080" bypass-list="*.onshikaku.org;*.flets-east.jp;*.flets-west.jp;*.lineauth.mnw;*.obn.managedpki.ne.jp;*.cybertrust.ne.jp;*.secomtrust.net;*.rece;pweb.base.oqs-pdl.org;192.168.220.1"
}else{
	write-host "プロキシ設定"
	write-host $Proxy_Result
}

#
#   現在のProxy設定を読み込み
#

$Proxy_org = (netsh winhttp show proxy) -split(" ")

$Exc_Proxy_org = $Proxy_org[$Proxy_org.count-2]
$Exc_Proxy_List
 = $Exc_Proxy_org -split(";")







#
#   プロキシ設定(レジストリ側)
#

write-output "--"
Write-Output "プロキシ設定(インターネットオプション)を設定します。"

$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"

#   ProxyServer     proxy.base.oqs-pdl.org:8080
#   ProxyOverride   *.onshikaku.org;*.flets-east.jp;*.flets-west.jp;*.lineauth.mnw;*.obn.managedpki.ne.jp;*.cybertrust.ne.jp;*.secomtrust.net;*.rece;pweb.base.oqs-pdl.org


if(test-path($RegPath)){
    $ChkReg = Get-ItemProperty -path $RegPath
    
    #   プロキシ設定
    Set-ItemProperty -path $RegPath -name ProxyServer -value 'proxy.base.oqs-pdl.org:8080'
    Set-ItemProperty -path $RegPath -name ProxyOverride -value '*.onshikaku.org;*.flets-east.jp;*.flets-west.jp;*.lineauth.mnw;*.obn.managedpki.ne.jp;*.cybertrust.ne.jp;*.secomtrust.net;*.rece;pweb.base.oqs-pdl.org;192.168.220.1'

}else{
    Write-Host ("レジストリエントリ" + $RegPath + "がありません。【エラー】") -ForegroundColor "Red"
}



$ProxySetting = Get-ItemProperty -path $RegPath
$OverrideProxy = $ProxySetting.ProxyOverride
