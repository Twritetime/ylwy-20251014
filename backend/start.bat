@echo off
echo 正在启动研路无忧后端服务...
echo.

REM 检查 JAVA_HOME 是否设置
if "%JAVA_HOME%"=="" (
    echo [错误] JAVA_HOME 环境变量未设置
    echo 请先设置 JAVA_HOME 环境变量，例如：
    echo set JAVA_HOME=C:\Program Files\Java\jdk-17
    echo.
    pause
    exit /b 1
)

REM 检查 Maven
if "%MAVEN_HOME%"=="" (
    echo [警告] MAVEN_HOME 环境变量未设置，使用默认路径
    set MAVEN_HOME=D:\software\dev\apache-maven-3.9.11
)

echo JAVA_HOME: %JAVA_HOME%
echo MAVEN_HOME: %MAVEN_HOME%
echo.

REM 启动 Spring Boot 应用
"%MAVEN_HOME%\bin\mvn.cmd" spring-boot:run

pause
