# YLWY Environment Check Script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  YLWY - Development Environment Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
$env:MAVEN_HOME = "D:\software\dev\apache-maven-3.9.11"

# Check Node.js
Write-Host "Checking Node.js..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    $npmVersion = npm --version
    Write-Host "  [OK] Node.js: $nodeVersion" -ForegroundColor Green
    Write-Host "  [OK] npm: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] Node.js not found" -ForegroundColor Red
}
Write-Host ""

# Check Java
Write-Host "Checking Java..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "  [OK] $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] Java not found" -ForegroundColor Red
}
Write-Host ""

# Check Maven
Write-Host "Checking Maven..." -ForegroundColor Yellow
try {
    $mavenVersion = mvn --version | Select-Object -First 1
    Write-Host "  [OK] $mavenVersion" -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] Maven not found" -ForegroundColor Red
}
Write-Host ""

# Check Python
Write-Host "Checking Python..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version
    $pipVersion = pip --version | Select-Object -First 1
    Write-Host "  [OK] $pythonVersion" -ForegroundColor Green
    Write-Host "  [OK] $pipVersion" -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] Python not found" -ForegroundColor Red
}
Write-Host ""

# Check Docker
Write-Host "Checking Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version
    Write-Host "  [OK] $dockerVersion" -ForegroundColor Green
} catch {
    Write-Host "  [ERROR] Docker not found" -ForegroundColor Red
}
Write-Host ""

# Check MySQL port
Write-Host "Checking MySQL (port 3306)..." -ForegroundColor Yellow
$mysqlPort = netstat -ano | findstr ":3306" | Select-Object -First 1
if ($mysqlPort) {
    Write-Host "  [OK] MySQL is running" -ForegroundColor Green
} else {
    Write-Host "  [ERROR] MySQL not running" -ForegroundColor Red
}
Write-Host ""

# Check Redis port
Write-Host "Checking Redis (port 6379)..." -ForegroundColor Yellow
$redisPort = netstat -ano | findstr ":6379" | findstr "LISTENING"
if ($redisPort) {
    Write-Host "  [OK] Redis is running" -ForegroundColor Green
} else {
    Write-Host "  [WARNING] Redis not detected on port 6379" -ForegroundColor Red
}
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Environment Check Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
