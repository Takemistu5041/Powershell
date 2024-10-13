@echo off
echo "FWのNetlogonサービスを許可します"

netsh advfirewall firewall set rule name="Netlogon サービス (NP 受信)" new profile=private enable=yes
netsh advfirewall firewall set rule name="Netlogon サービス (NP 受信)" new profile=public enable=yes
