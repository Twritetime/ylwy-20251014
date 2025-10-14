# 研路无忧 - 项目启动脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  研路无忧 - 项目启动" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 刷新环境变量
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
$env:MAVEN_HOME = "D:\software\dev\apache-maven-3.9.11"

# 检查 Redis
Write-Host "[1/4] 检查 Redis..." -ForegroundColor Yellow
$redisProcess = Get-Process redis-server -ErrorAction SilentlyContinue
if ($redisProcess) {
    Write-Host "  ✓ Redis 正在运行" -ForegroundColor Green
} else {
    Write-Host "  ✗ Redis 未运行，正在启动..." -ForegroundColor Yellow
    & .\start-redis.ps1
}

# 检查 MySQL
Write-Host "[2/4] 检查 MySQL..." -ForegroundColor Yellow
$mysqlPort = netstat -ano | findstr ":3306" | Select-Object -First 1
if ($mysqlPort) {
    Write-Host "  ✓ MySQL 正在运行" -ForegroundColor Green
} else {
    Write-Host "  ✗ MySQL 未运行，请启动 MySQL" -ForegroundColor Red
}

Write-Host ""
Write-Host "请选择要启动的服务：" -ForegroundColor Cyan
Write-Host "  1. 前端开发服务器 (Vue 3 + Vite)" -ForegroundColor White
Write-Host "  2. 后端API服务 (Spring Boot)" -ForegroundColor White
Write-Host "  3. 判题服务器" -ForegroundColor White
Write-Host "  4. 全部启动" -ForegroundColor White
Write-Host "  0. 退出" -ForegroundColor White
Write-Host ""

$choice = Read-Host "请输入选择 (0-4)"

switch ($choice) {
    "1" {
        Write-Host "`n[3/4] 启动前端服务..." -ForegroundColor Yellow
        cd frontend
        npm run dev
    }
    "2" {
        Write-Host "`n[3/4] 启动后端服务..." -ForegroundColor Yellow
        cd backend
        mvn spring-boot:run
    }
    "3" {
        Write-Host "`n[3/4] 启动判题服务器..." -ForegroundColor Yellow
        cd judge-server
        mvn spring-boot:run
    }
    "4" {
        Write-Host "`n[3/4] 启动所有服务..." -ForegroundColor Yellow
        Write-Host "  ⚠️  需要在多个终端中手动启动" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "终端 1: cd frontend && npm run dev" -ForegroundColor White
        Write-Host "终端 2: cd backend && mvn spring-boot:run" -ForegroundColor White
        Write-Host "终端 3: cd judge-server && mvn spring-boot:run" -ForegroundColor White
    }
    "0" {
        Write-Host "`n再见！" -ForegroundColor Green
        exit
    }
    default {
        Write-Host "`n无效的选择" -ForegroundColor Red
    }
}
