@echo off
REM 判断是否管理员权限
fltmc >nul 2>&1 || (
    echo 正在请求管理员权限...
    powershell -Command "Start-Process cmd -ArgumentList '/c ""%~f0""' -Verb RunAs"
    exit /b
)
cd /d "%~dp0"

:main
echo ==============================================
echo          屏蔽域名(hosts)+IP(系统防火墙)
echo ==============================================
set "hostsPath=%SystemRoot%\System32\drivers\etc\hosts"
echo.
echo [1] 写入hosts屏蔽条目（存在则跳过，不会重复添加）

:: 逐行检测，不存在才追加
findstr /i "127.0.0.1 www.youtusoft.com" "%hostsPath%" >nul || echo 127.0.0.1 www.youtusoft.com>>"%hostsPath%"
findstr /i "127.0.0.1 youtusoft.com" "%hostsPath%" >nul || echo 127.0.0.1 youtusoft.com>>"%hostsPath%"
findstr /i "127.0.0.1 hostbuf.com" "%hostsPath%" >nul || echo 127.0.0.1 hostbuf.com>>"%hostsPath%"
findstr /i "127.0.0.1 www.hostbuf.com" "%hostsPath%" >nul || echo 127.0.0.1 www.hostbuf.com>>"%hostsPath%"
findstr /i "127.0.0.1 dkys.org" "%hostsPath%" >nul || echo 127.0.0.1 dkys.org>>"%hostsPath%"
findstr /i "127.0.0.1 tcpspeed.com" "%hostsPath%" >nul || echo 127.0.0.1 tcpspeed.com>>"%hostsPath%"
findstr /i "127.0.0.1 www.wn1998.com" "%hostsPath%" >nul || echo 127.0.0.1 www.wn1998.com>>"%hostsPath%"
findstr /i "127.0.0.1 wn1998.com" "%hostsPath%" >nul || echo 127.0.0.1 wn1998.com>>"%hostsPath%"
findstr /i "127.0.0.1 pwlt.wn1998.com" "%hostsPath%" >nul || echo 127.0.0.1 pwlt.wn1998.com>>"%hostsPath%"
findstr /i "127.0.0.1 backup.www.hostbuf.com" "%hostsPath%" >nul || echo 127.0.0.1 backup.www.hostbuf.com>>"%hostsPath%"

echo [OK] hosts处理完成
echo 刷新DNS缓存
ipconfig /flushdns

echo.
echo [2] 添加Windows防火墙出站规则，屏蔽指定IP
set ruleName=BlockCustomIPList
netsh advfirewall firewall delete rule name="%ruleName%" >nul 2>&1

netsh advfirewall firewall add rule ^
name="%ruleName%" ^
dir=out ^
action=block ^
remoteip=101.32.72.254,45.56.98.223,193.9.44.7,103.99.178.153,47.76.185.223 ^
enable=yes ^
profile=any

if %errorlevel% equ 0 (
    echo [OK] 防火墙IP屏蔽规则创建成功
) else (
    echo [ERROR] 防火墙规则添加失败
)

echo.
echo ==============================================
echo 操作结束！
echo hosts已处理，防火墙IP拦截已配置
echo ==============================================
echo.
pause
