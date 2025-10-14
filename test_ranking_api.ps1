# 测试排行榜API脚本
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  研路无忧 - 排行榜API测试" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 测试登录获取token
Write-Host "[1] 测试登录..." -ForegroundColor Yellow
$loginData = @{
    username = "admin"
    password = "123456"
} | ConvertTo-Json

try {
    $loginRes = Invoke-RestMethod -Uri 'http://localhost:8080/api/auth/login' `
        -Method POST `
        -Body $loginData `
        -ContentType 'application/json'
    
    if ($loginRes.code -eq 200) {
        $token = $loginRes.data
        Write-Host "✓ 登录成功！Token: $($token.Substring(0,20))..." -ForegroundColor Green
    } else {
        Write-Host "✗ 登录失败：$($loginRes.message)" -ForegroundColor Red
        exit
    }
} catch {
    Write-Host "✗ 登录请求失败：$_" -ForegroundColor Red
    exit
}

Write-Host ""

# 2. 测试获取排行榜列表
Write-Host "[2] 测试获取排行榜列表..." -ForegroundColor Yellow
try {
    $rankListRes = Invoke-RestMethod -Uri 'http://localhost:8080/api/rank/list?limit=10'
    
    if ($rankListRes.code -eq 200) {
        Write-Host "✓ 获取排行榜成功！共 $($rankListRes.data.Count) 条记录" -ForegroundColor Green
        Write-Host ""
        Write-Host "排名  用户名        昵称          AC数  提交数  AC率" -ForegroundColor Cyan
        Write-Host "----  ----------  ----------  ----  ------  ----" -ForegroundColor Cyan
        foreach ($user in $rankListRes.data) {
            $acRate = if ($user.acRate) { "$($user.acRate)%" } else { "N/A" }
            Write-Host ("{0,-4}  {1,-10}  {2,-10}  {3,-4}  {4,-6}  {5}" -f `
                $user.rank, $user.username, $user.nickname, $user.acCount, $user.submitCount, $acRate)
        }
    } else {
        Write-Host "✗ 获取排行榜失败：$($rankListRes.message)" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ 请求失败：$_" -ForegroundColor Red
}

Write-Host ""

# 3. 测试获取我的排名
Write-Host "[3] 测试获取我的排名..." -ForegroundColor Yellow
$headers = @{
    'Authorization' = "Bearer $token"
}

try {
    $myRankRes = Invoke-RestMethod -Uri 'http://localhost:8080/api/rank/my' -Headers $headers
    
    if ($myRankRes.code -eq 200) {
        $myRank = $myRankRes.data
        Write-Host "✓ 获取我的排名成功！" -ForegroundColor Green
        Write-Host ""
        Write-Host "  用户名: $($myRank.username)" -ForegroundColor White
        Write-Host "  昵称:   $($myRank.nickname)" -ForegroundColor White
        Write-Host "  排名:   第 $($myRank.rank) 名" -ForegroundColor Yellow
        Write-Host "  AC数:   $($myRank.acCount) 题" -ForegroundColor Green
        Write-Host "  提交数: $($myRank.submitCount) 次" -ForegroundColor Blue
        $acRate = if ($myRank.acRate) { "$($myRank.acRate)%" } else { "0%" }
        Write-Host "  AC率:   $acRate" -ForegroundColor Cyan
    } else {
        Write-Host "✗ 获取我的排名失败：$($myRankRes.message)" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ 请求失败：$_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  测试完成！" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
