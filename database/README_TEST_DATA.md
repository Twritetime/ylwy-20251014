# 测试数据导入说明

## 📊 测试数据概览

`test_data.sql` 包含了以下测试数据：

### 1. 用户数据 (users) - 8条
- **admin** - 管理员账号
- **zhangsan** 到 **wujiu** - 7个普通用户
- 所有密码统一为：`123456`

### 2. 学校数据 (schools) - 15所
- 清华大学、北京大学、上海交通大学等985/211名校
- 包含热度指数、浏览量等数据

### 3. 题目数据 (questions) - 10道
- **5道选择题**：C语言基础、数据结构等
- **5道编程题**：A+B Problem、斐波那契数列、链表反转等

### 4. 选择题选项 (question_options) - 20条
- 为每道选择题提供4个选项

### 5. 测试用例 (test_cases) - 11条
- 为编程题提供示例和隐藏测试用例

### 6. 代码提交记录 (submissions) - 5条
- 包含AC、TLE等各种判题状态

### 7. 用户答题记录 (user_answers) - 10条
- 用户答题的正确/错误记录

### 8. 考试记录 (exam_records) - 3条
- 智能组卷的完成记录

### 9. 用户动态 (activities) - 5条
- 用户提交代码、完成考试等动态

## 📥 导入方法

### 方法一：使用 Navicat（推荐）

1. 打开 Navicat，连接到 ylwy_db 数据库
2. 点击菜单栏 **文件** → **运行SQL文件**
3. 选择 `test_data.sql` 文件
4. 点击 **开始** 执行

### 方法二：使用 MySQL Workbench

1. 打开 MySQL Workbench，连接到数据库
2. 点击菜单 **File** → **Open SQL Script**
3. 选择 `test_data.sql` 文件
4. 点击 **执行** (闪电图标)

### 方法三：使用命令行（需配置MySQL PATH）

```bash
# Windows
mysql -u root -p ylwy_db < test_data.sql

# 或者
Get-Content test_data.sql | mysql -u root -p ylwy_db
```

### 方法四：使用 phpstudy 自带工具

1. 打开 phpstudy
2. 进入 MySQL 管理
3. 选择 ylwy_db 数据库
4. 导入 test_data.sql 文件

## ✅ 验证导入

导入成功后，执行以下SQL验证：

```sql
-- 检查用户数量
SELECT COUNT(*) FROM users;  -- 应返回 8

-- 检查学校数量
SELECT COUNT(*) FROM schools;  -- 应返回 15

-- 检查题目数量
SELECT COUNT(*) FROM questions;  -- 应返回 10

-- 查看测试用户
SELECT username, nickname, role FROM users;

-- 查看题目列表
SELECT question_no, title, type, difficulty FROM questions;
```

## 🔑 测试账号

| 用户名 | 密码 | 角色 | 昵称 |
|--------|------|------|------|
| admin | 123456 | admin | 管理员 |
| zhangsan | 123456 | user | 小张 |
| lisi | 123456 | user | 小李 |
| wangwu | 123456 | user | 小王 |

## 🎯 测试场景

导入测试数据后，可以测试以下功能：

1. **用户登录**
   - 使用 zhangsan/123456 登录
   - 验证 JWT Token 生成

2. **题库浏览**
   - 查看10道题目
   - 按类型、难度筛选

3. **代码提交**
   - 选择编程题提交代码
   - 查看已有提交记录

4. **答题记录**
   - 查看用户的答题历史
   - 统计正确率

5. **用户动态**
   - 查看实时动态流
   - 用户活跃度统计

## 📝 注意事项

1. 导入前确保已执行 `init.sql` 初始化数据库
2. 测试数据会插入大量记录，可能需要几秒钟
3. 如需重新导入，建议先清空相关表数据
4. BCrypt密码已预先加密，密码为 `123456`

## 🗑️ 清空测试数据

如需清空测试数据，执行：

```sql
-- 清空所有数据（保留表结构）
SET FOREIGN_KEY_CHECKS=0;
TRUNCATE TABLE activities;
TRUNCATE TABLE exam_records;
TRUNCATE TABLE user_answers;
TRUNCATE TABLE submissions;
TRUNCATE TABLE test_cases;
TRUNCATE TABLE question_options;
TRUNCATE TABLE questions;
TRUNCATE TABLE schools;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS=1;

-- 重新插入科目和分类（这两个表是基础数据）
-- 执行 init.sql 中的 INSERT 语句
```
