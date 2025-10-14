# 数据库初始化脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  研路无忧 - 数据库初始化" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 数据库配置
$dbHost = "localhost"
$dbPort = "3306"
$dbUser = "root"
$dbPass = "root"
$dbName = "ylwy_db"
$sqlFile = "init.sql"

Write-Host "[1/3] 检查SQL文件..." -ForegroundColor Yellow
if (Test-Path $sqlFile) {
    Write-Host "  ✓ SQL文件存在: $sqlFile" -ForegroundColor Green
} else {
    Write-Host "  ✗ SQL文件不存在!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "[2/3] 连接MySQL数据库..." -ForegroundColor Yellow
Write-Host "  主机: $dbHost" -ForegroundColor White
Write-Host "  端口: $dbPort" -ForegroundColor White
Write-Host "  用户: $dbUser" -ForegroundColor White
Write-Host ""

Write-Host "[3/3] 执行SQL脚本..." -ForegroundColor Yellow
Write-Host ""
Write-Host "请使用以下方法之一导入数据库：" -ForegroundColor Cyan
Write-Host ""
Write-Host "方法一：使用Navicat等数据库工具" -ForegroundColor White
Write-Host "  1. 打开Navicat连接到MySQL" -ForegroundColor Gray
Write-Host "  2. 点击'查询' -> '新建查询'" -ForegroundColor Gray
Write-Host "  3. 打开文件: $((Get-Location).Path)\$sqlFile" -ForegroundColor Gray
Write-Host "  4. 点击'运行'执行SQL" -ForegroundColor Gray
Write-Host ""
Write-Host "方法二：使用MySQL命令行（如果已配置）" -ForegroundColor White
Write-Host "  mysql -uroot -proot < init.sql" -ForegroundColor Gray
Write-Host ""
Write-Host "方法三：使用PowerShell脚本（需要MySQL .NET Connector）" -ForegroundColor White
Write-Host "  .\import-db.ps1" -ForegroundColor Gray
Write-Host ""

Write-Host "SQL文件路径：" -ForegroundColor Yellow
Write-Host "  $((Get-Location).Path)\$sqlFile" -ForegroundColor White
Write-Host ""

# 显示SQL文件内容摘要
Write-Host "SQL脚本包含以下表：" -ForegroundColor Cyan
Write-Host "  1. users - 用户表" -ForegroundColor White
Write-Host "  2. schools - 学校表" -ForegroundColor White
Write-Host "  3. subjects - 科目表" -ForegroundColor White
Write-Host "  4. question_categories - 题目分类表" -ForegroundColor White
Write-Host "  5. questions - 题目表" -ForegroundColor White
Write-Host "  6. question_options - 选择题选项表" -ForegroundColor White
Write-Host "  7. test_cases - 测试用例表" -ForegroundColor White
Write-Host "  8. submissions - 代码提交记录表" -ForegroundColor White
Write-Host "  9. user_answers - 用户答题记录表" -ForegroundColor White
Write-Host "  10. exam_records - 考试记录表" -ForegroundColor White
Write-Host "  11. activities - 动态表" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
