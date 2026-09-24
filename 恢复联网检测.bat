@echo off
fltmc >nul 2>&1 || (
    echo 请求管理员权限...
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~f0""' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"
set ruleName=BlockCustomIPList
netsh advfirewall firewall delete rule name="%ruleName%"
echo 防火墙规则已删除
echo.
echo 注意：hosts条目需要手动打开 hosts 文件删除
echo 路径：C:\Windows\System32\drivers\etc\hosts
ipconfig /flushdns
echo DNS缓存已刷新
pause
