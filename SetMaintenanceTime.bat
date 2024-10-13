echo ƒƒ“ƒeƒiƒ“ƒX‚ğ14:00‚É
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "Activation Boundary" /t REG_SZ /d "2001-01-01T14:00:00" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d 0 /f
echo.
