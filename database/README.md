# 数据库初始化说明

## 📊 数据库结构

### 数据库信息
- **数据库名**：ylwy_db
- **字符集**：utf8mb4
- **排序规则**：utf8mb4_unicode_ci

### 数据表列表（11张表）

| 序号 | 表名 | 说明 | 主要字段 |
|------|------|------|----------|
| 1 | users | 用户表 | id, username, password, email, school_from, school_target |
| 2 | schools | 学校表 | id, name, province, level, hot_index |
| 3 | subjects | 科目表 | id, name, code, description |
| 4 | question_categories | 题目分类表 | id, name, parent_id |
| 5 | questions | 题目表 | id, question_no, title, content, type, difficulty |
| 6 | question_options | 选择题选项表 | id, question_id, option_key, option_content, is_correct |
| 7 | test_cases | 测试用例表 | id, question_id, input, expected_output |
| 8 | submissions | 代码提交记录表 | id, user_id, question_id, code, status, score |
| 9 | user_answers | 用户答题记录表 | id, user_id, question_id, answer, is_correct |
| 10 | exam_records | 考试记录表 | id, user_id, exam_type, total_score, user_score |
| 11 | activities | 动态表 | id, user_id, type, content, created_at |

---

## 🚀 初始化方法

### 方法一：使用 Navicat（推荐）

1. 打开 Navicat，连接到 MySQL
   - 主机：localhost
   - 端口：3306
   - 用户：root
   - 密码：root

2. 点击 "查询" → "新建查询"

3. 点击 "打开文件"，选择：
   ```
   d:\projects\ylwy-20251014\database\init.sql
   ```

4. 点击 "运行" 或按 F5 执行

5. 查看执行结果，应显示 "数据库初始化完成！"

---

### 方法二：使用 MySQL Workbench

1. 打开 MySQL Workbench，连接到 MySQL

2. 点击 "File" → "Open SQL Script"

3. 选择文件：
   ```
   d:\projects\ylwy-20251014\database\init.sql
   ```

4. 点击闪电图标⚡执行

---

### 方法三：使用命令行（需配置MySQL路径）

如果 MySQL 命令行工具在 PATH 中：

```powershell
cd d:\projects\ylwy-20251014\database
mysql -uroot -proot < init.sql
```

如果没有配置 PATH，使用完整路径：

```powershell
# 示例路径（根据实际安装路径调整）
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -uroot -proot < init.sql
```

---

### 方法四：复制粘贴执行

1. 打开 `init.sql` 文件

2. 复制全部内容

3. 在 Navicat 或 MySQL Workbench 中：
   - 新建查询
   - 粘贴内容
   - 执行

---

## ✅ 验证数据库

### 检查数据库是否创建成功

```sql
SHOW DATABASES LIKE 'ylwy_db';
```

### 查看所有表

```sql
USE ylwy_db;
SHOW TABLES;
```

应显示 11 张表：
```
+-------------------+
| Tables_in_ylwy_db |
+-------------------+
| activities        |
| exam_records      |
| question_categories|
| question_options  |
| questions         |
| schools           |
| subjects          |
| submissions       |
| test_cases        |
| user_answers      |
| users             |
+-------------------+
```

### 查看表结构

```sql
DESC users;
DESC questions;
DESC submissions;
```

### 查看初始数据

```sql
-- 查看科目数据
SELECT * FROM subjects;

-- 查看题目分类
SELECT * FROM question_categories;
```

---

## 📝 初始化数据

### 科目数据（已自动插入）

| ID | 科目名称 | 科目代码 | 排序 |
|----|---------|---------|------|
| 1 | C语言 | C | 1 |
| 2 | 数据结构 | DS | 2 |
| 3 | 操作系统 | OS | 3 |
| 4 | 计算机组成原理 | CO | 4 |
| 5 | 计算机网络 | CN | 5 |

### 题目分类（已自动插入）

| ID | 分类名称 | 父分类ID |
|----|---------|----------|
| 1 | 简单模拟 | 0 |
| 2 | 基础算法 | 0 |
| 3 | 搜索 | 0 |
| 4 | 数学 | 0 |
| 5 | 数据结构 | 0 |
| 6 | 动态规划 | 0 |
| 7 | 图论 | 0 |
| 8 | 计算几何 | 0 |

---

## 🔧 常见问题

### 1. 连接失败

**问题**：无法连接到MySQL

**解决**：
- 确认 MySQL 服务正在运行
- 检查端口 3306 是否被占用
- 确认用户名密码正确（root/root）

### 2. 权限错误

**问题**：Access denied for user 'root'@'localhost'

**解决**：
```sql
-- 重置root密码（在MySQL命令行中）
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
FLUSH PRIVILEGES;
```

### 3. 数据库已存在

**问题**：Can't create database 'ylwy_db'; database exists

**解决**：
- 如果需要重新创建，先删除旧数据库：
  ```sql
  DROP DATABASE IF EXISTS ylwy_db;
  ```
- 然后重新执行 init.sql

### 4. 字符集问题

**问题**：中文乱码

**解决**：
- 确保数据库使用 utf8mb4 字符集
- 检查连接字符集：
  ```sql
  SHOW VARIABLES LIKE 'character%';
  ```

---

## 📂 文件说明

| 文件 | 说明 |
|------|------|
| `init.sql` | 数据库初始化SQL脚本 |
| `init-db.ps1` | 初始化辅助脚本 |
| `README.md` | 本说明文档 |

---

## 🎯 下一步

数据库初始化完成后：

1. ✅ 更新后端配置文件 `application.yml`
2. ✅ 创建实体类（Entity）
3. ✅ 创建 Mapper 接口
4. ✅ 开发业务逻辑
5. ✅ 测试数据库连接

---

## 📞 需要帮助？

如果初始化遇到问题，请检查：
1. MySQL 是否正在运行
2. 用户名密码是否正确
3. 端口是否正确
4. 是否有足够的权限

**SQL文件位置**：
```
d:\projects\ylwy-20251014\database\init.sql
```
