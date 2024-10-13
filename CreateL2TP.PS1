$VpnName = "L2TP"
$VpnUrl = "172.20.64.140"
$PreKey = "Hamamatsu-9001-Cms"

$RasExec = "C:\windows\system32\rasdial.exe"
$VpnUser = "CMSnet"
$VpnPass = "TENsmc"

#Remove Vpn Adaptor
Remove-VpnConnection -Name $VpnName -Force -PassThru

#Create VPN Adaptor
Add-VpnConnection -Name $VpnName `
                  -ServerAddress $VpnUrl `
                  -RememberCredential -L2tpPsk $PreKey `
                  -AuthenticationMethod MSChapv2 `
                  -EncryptionLevel Required `
                  -TunnelType L2tp `
                  -Force

