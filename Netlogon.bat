@echo off
echo "FW��Netlogon�T�[�r�X�������܂�"

netsh advfirewall firewall set rule name="Netlogon �T�[�r�X (NP ��M)" new profile=private enable=yes
netsh advfirewall firewall set rule name="Netlogon �T�[�r�X (NP ��M)" new profile=public enable=yes
