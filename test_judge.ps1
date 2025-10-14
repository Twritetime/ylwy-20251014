# 测试C++代码判题
$testRequest = @{
    submissionId = 1
    questionId = 6
    language = "cpp"
    code = @"
#include <iostream>
using namespace std;

int main() {
    int a, b;
    cin >> a >> b;
    cout << a + b << endl;
    return 0;
}
"@
    testCases = @(
        @{
            input = "1 2"
            expectedOutput = "3"
        },
        @{
            input = "5 10"
            expectedOutput = "15"
        }
    )
    timeLimit = 1000
    memoryLimit = 262144
} | ConvertTo-Json -Depth 5

Write-Host "🔍 测试判题服务器..." -ForegroundColor Cyan
Write-Host ""

# 测试健康检查
Write-Host "[1] 健康检查..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri 'http://localhost:8081/judge/health'
    Write-Host "✓ 判题服务器运行正常: $health" -ForegroundColor Green
} catch {
    Write-Host "✗ 判题服务器未运行" -ForegroundColor Red
    exit
}

Write-Host ""

# 测试C++代码判题
Write-Host "[2] 测试C++代码判题(A+B问题)..." -ForegroundColor Yellow
try {
    $result = Invoke-RestMethod -Uri 'http://localhost:8081/judge/execute' `
        -Method POST `
        -Body $testRequest `
        -ContentType 'application/json'
    
    Write-Host "✓ 判题完成！" -ForegroundColor Green
    Write-Host ""
    Write-Host "提交ID: $($result.submissionId)" -ForegroundColor White
    Write-Host "判题状态: $($result.status)" -ForegroundColor $(if($result.status -eq 'ac'){'Green'}else{'Red'})
    Write-Host "状态消息: $($result.message)" -ForegroundColor White
    Write-Host "运行时间: $($result.timeUsed) ms" -ForegroundColor White
    Write-Host "内存使用: $($result.memoryUsed) KB" -ForegroundColor White
    Write-Host "通过用例: $($result.passCount)/$($result.totalCount)" -ForegroundColor White
    
    if ($result.errorMessage) {
        Write-Host "错误信息: $($result.errorMessage)" -ForegroundColor Red
    }
    
    if ($result.compileOutput) {
        Write-Host "编译输出: $($result.compileOutput)" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "✗ 判题失败: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
