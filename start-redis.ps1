# Start Redis Server for YLWY Project

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Redis Server" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$redisPath = "D:\phpstudy_pro\Extensions\redis3.0.504"
$redisExe = "$redisPath\redis-server.exe"

# Check if Redis executable exists
if (Test-Path $redisExe) {
    Write-Host "Redis found at: $redisPath" -ForegroundColor Green
    
    # Check if Redis is already running
    $redisProcess = Get-Process redis-server -ErrorAction SilentlyContinue
    if ($redisProcess) {
        Write-Host "Redis is already running (PID: $($redisProcess.Id))" -ForegroundColor Yellow
    } else {
        # Start Redis server
        Write-Host "Starting Redis server on port 6379..." -ForegroundColor Yellow
        Start-Process $redisExe -ArgumentList "--port 6379" -WindowStyle Normal -WorkingDirectory $redisPath
        Start-Sleep -Seconds 2
        
        # Verify Redis is running
        $redisProcess = Get-Process redis-server -ErrorAction SilentlyContinue
        if ($redisProcess) {
            Write-Host "[OK] Redis started successfully (PID: $($redisProcess.Id))" -ForegroundColor Green
        } else {
            Write-Host "[ERROR] Failed to start Redis" -ForegroundColor Red
        }
    }
} else {
    Write-Host "[ERROR] Redis executable not found at: $redisExe" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
