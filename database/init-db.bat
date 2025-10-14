@echo off
chcp 65001 >nul
echo ========================================
echo   研路无忧 - 数据库初始化
echo ========================================
echo.

set MYSQL_HOST=localhost
set MYSQL_PORT=3306
set MYSQL_USER=root
set MYSQL_PASS=root

echo [1/2] 检查SQL文件...
if not exist "init.sql" (
    echo   × SQL文件不存在！
    pause
    exit /b 1
)
echo   √ SQL文件存在
echo.

echo [2/2] 执行SQL脚本...
echo.
echo 请在Navicat或MySQL Workbench中执行以下文件：
echo   %CD%\init.sql
echo.
echo 或使用命令行（如果MySQL在PATH中）：
echo   mysql -u%MYSQL_USER% -p%MYSQL_PASS% ^< init.sql
echo.

pause
