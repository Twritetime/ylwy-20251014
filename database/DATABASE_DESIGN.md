# 研路无忧 - 数据库设计文档

## 📊 数据库ER图（文字描述）

```
用户(users) 1 ----< N 提交记录(submissions)
用户(users) 1 ----< N 答题记录(user_answers)
用户(users) 1 ----< N 考试记录(exam_records)
用户(users) 1 ----< N 动态(activities)

题目(questions) 1 ----< N 选项(question_options)
题目(questions) 1 ----< N 测试用例(test_cases)
题目(questions) 1 ----< N 提交记录(submissions)
题目(questions) 1 ----< N 答题记录(user_answers)

科目(subjects) 1 ----< N 题目(questions)
分类(question_categories) 1 ----< N 题目(questions)
```

---

## 📋 表结构详细设计

### 1. 用户表 (users)

**用途**：存储用户基本信息

| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 用户ID | PK, AUTO_INCREMENT |
| username | VARCHAR(50) | 用户名 | UNIQUE, NOT NULL |
| password | VARCHAR(255) | 密码(BCrypt加密) | NOT NULL |
| email | VARCHAR(100) | 邮箱 | |
| phone | VARCHAR(20) | 手机号 | |
| nickname | VARCHAR(50) | 昵称 | |
| avatar | VARCHAR(255) | 头像URL | DEFAULT |
| school_from | VARCHAR(100) | 本科院校 | |
| school_target | VARCHAR(100) | 目标院校 | |
| signature | VARCHAR(255) | 个性签名 | |
| role | VARCHAR(20) | 角色 | DEFAULT 'user' |
| status | TINYINT | 状态 | DEFAULT 1 |
| created_at | DATETIME | 创建时间 | DEFAULT CURRENT_TIMESTAMP |
| updated_at | DATETIME | 更新时间 | ON UPDATE CURRENT_TIMESTAMP |

**索引**：
- PRIMARY KEY (id)
- INDEX idx_username (username)
- INDEX idx_email (email)
- INDEX idx_status (status)

---

### 2. 学校表 (schools)

**用途**：存储学校信息

| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 学校ID | PK, AUTO_INCREMENT |
| name | VARCHAR(100) | 学校名称 | NOT NULL |
| province | VARCHAR(50) | 省份 | |
| city | VARCHAR(50) | 城市 | |
| level | VARCHAR(20) | 学校层次 | |
| logo | VARCHAR(255) | 学校logo | |
| description | TEXT | 学校简介 | |
| hot_index | INT | 热门指数 | DEFAULT 0 |
| view_count | INT | 浏览次数 | DEFAULT 0 |
| created_at | DATETIME | 创建时间 | |
| updated_at | DATETIME | 更新时间 | |

**索引**：
- PRIMARY KEY (id)
- INDEX idx_name (name)
- INDEX idx_province (province)
- INDEX idx_hot_index (hot_index DESC)

---

### 3. 科目表 (subjects)

**用途**：存储科目信息（C语言、数据结构等）

| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 科目ID | PK, AUTO_INCREMENT |
| name | VARCHAR(50) | 科目名称 | NOT NULL |
| code | VARCHAR(20) | 科目代码 | UNIQUE, NOT NULL |
| description | VARCHAR(255) | 科目描述 | |
| sort_order | INT | 排序 | DEFAULT 0 |
| created_at | DATETIME | 创建时间 | |

**预置数据**：
- C语言 (C)
- 数据结构 (DS)
- 操作系统 (OS)
- 计算机组成原理 (CO)
- 计算机网络 (CN)

---

### 4. 题目分类表 (question_categories)

**用途**：题目分类（简单模拟、基础算法等）

| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 分类ID | PK, AUTO_INCREMENT |
| name | VARCHAR(50) | 分类名称 | NOT NULL |
| parent_id | BIGINT | 父分类ID | DEFAULT 0 |
| sort_order | INT | 排序 | DEFAULT 0 |
| created_at | DATETIME | 创建时间 | |

**预置数据**：
- 简单模拟
- 基础算法
- 搜索
- 数学
- 数据结构
- 动态规划
- 图论
- 计算几何

---

### 5. 题目表 (questions) ⭐

**用途**：存储所有题目（选择题和编程题）

| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 题目ID | PK, AUTO_INCREMENT |
| question_no | VARCHAR(20) | 题目编号 | UNIQUE, NOT NULL |
| title | VARCHAR(255) | 题目标题 | NOT NULL |
| content | TEXT | 题目内容 | NOT NULL |
| type | VARCHAR(20) | 题目类型 | NOT NULL (choice/program) |
| difficulty | VARCHAR(20) | 难度 | DEFAULT 'medium' |
| subject_id | BIGINT | 科目ID | FK -> subjects |
| category_id | BIGINT | 分类ID | FK -> question_categories |
| school_source | VARCHAR(100) | 来源学校 | |
| time_limit | INT | 时间限制(ms) | DEFAULT 1000 |
| memory_limit | INT | 内存限制(MB) | DEFAULT 256 |
| pass_rate | DECIMAL(5,2) | 通过率(%) | DEFAULT 0.00 |
| submit_count | INT | 提交次数 | DEFAULT 0 |
| accept_count | INT | 通过次数 | DEFAULT 0 |
| created_at | DATETIME | 创建时间 | |
| updated_at | DATETIME | 更新时间 | |

**索引**：
- PRIMARY KEY (id)
- UNIQUE KEY uk_question_no (question_no)
- INDEX idx_type (type)
- INDEX idx_difficulty (difficulty)
- INDEX idx_subject (subject_id)
- INDEX idx_category (category_id)

---

### 6. 选择题选项表 (question_options)

**用途**：存储选择题的选项

| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 选项ID | PK, AUTO_INCREMENT |
| question_id | BIGINT | 题目ID | FK -> questions, NOT NULL |
| option_key | VARCHAR(5) | 选项标识 | NOT NULL (A/B/C/D) |
| option_content | TEXT | 选项内容 | NOT NULL |
| is_correct | TINYINT | 是否正确答案 | DEFAULT 0 |
| created_at | DATETIME | 创建时间 | |

**外键**：
- FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE

---

### 7. 测试用例表 (test_cases)

**用途**：存储编程题的测试用例

| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 测试用例ID | PK, AUTO_INCREMENT |
| question_id | BIGINT | 题目ID | FK -> questions, NOT NULL |
| input | TEXT | 输入数据 | NOT NULL |
| expected_output | TEXT | 期望输出 | NOT NULL |
| is_sample | TINYINT | 是否示例用例 | DEFAULT 0 |
| sort_order | INT | 排序 | DEFAULT 0 |
| created_at | DATETIME | 创建时间 | |

**外键**：
- FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE

---

### 8. 代码提交记录表 (submissions) ⭐

**用途**：存储用户提交的代码和判题结果

| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 提交ID | PK, AUTO_INCREMENT |
| user_id | BIGINT | 用户ID | FK -> users, NOT NULL |
| question_id | BIGINT | 题目ID | FK -> questions, NOT NULL |
| language | VARCHAR(20) | 编程语言 | NOT NULL |
| code | TEXT | 提交代码 | NOT NULL |
| status | VARCHAR(20) | 判题状态 | DEFAULT 'pending' |
| score | INT | 得分 | DEFAULT 0 |
| time_used | INT | 运行时间(ms) | |
| memory_used | INT | 内存使用(KB) | |
| error_message | TEXT | 错误信息 | |
| pass_count | INT | 通过测试用例数 | DEFAULT 0 |
| total_count | INT | 总测试用例数 | DEFAULT 0 |
| created_at | DATETIME | 创建时间 | |

**判题状态**：
- pending - 等待判题
- judging - 判题中
- ac - Accepted (通过)
- wa - Wrong Answer (答案错误)
- tle - Time Limit Exceeded (超时)
- mle - Memory Limit Exceeded (内存超限)
- re - Runtime Error (运行错误)
- ce - Compile Error (编译错误)
- se - System Error (系统错误)

---

### 9. 用户答题记录表 (user_answers)

**用途**：存储用户选择题的答题记录

| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 记录ID | PK, AUTO_INCREMENT |
| user_id | BIGINT | 用户ID | FK -> users, NOT NULL |
| question_id | BIGINT | 题目ID | FK -> questions, NOT NULL |
| answer | VARCHAR(255) | 用户答案 | |
| is_correct | TINYINT | 是否正确 | |
| created_at | DATETIME | 答题时间 | |

---

### 10. 考试记录表 (exam_records)

**用途**：存储智能组卷等考试记录

| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 考试ID | PK, AUTO_INCREMENT |
| user_id | BIGINT | 用户ID | FK -> users, NOT NULL |
| exam_type | VARCHAR(50) | 考试类型 | NOT NULL |
| subject_ids | VARCHAR(255) | 科目ID列表 | |
| total_score | INT | 总分 | DEFAULT 0 |
| user_score | INT | 用户得分 | DEFAULT 0 |
| total_count | INT | 题目总数 | DEFAULT 0 |
| correct_count | INT | 正确数量 | DEFAULT 0 |
| duration | INT | 考试时长(秒) | |
| started_at | DATETIME | 开始时间 | |
| finished_at | DATETIME | 完成时间 | |
| created_at | DATETIME | 创建时间 | |

---

### 11. 动态表 (activities)

**用途**：存储用户动态（登录、答题、组卷等）

| 字段名 | 类型 | 说明 | 约束 |
|--------|------|------|------|
| id | BIGINT | 动态ID | PK, AUTO_INCREMENT |
| user_id | BIGINT | 用户ID | FK -> users, NOT NULL |
| type | VARCHAR(50) | 动态类型 | NOT NULL |
| content | VARCHAR(500) | 动态内容 | NOT NULL |
| related_id | BIGINT | 关联ID | |
| metadata | JSON | 元数据 | |
| created_at | DATETIME | 创建时间 | |

**动态类型**：
- login - 用户登录
- submit - 代码提交
- exam - 智能组卷
- answer - 答题

---

## 🔗 表关系说明

### 一对多关系

1. **users -> submissions** (一个用户多次提交)
2. **users -> user_answers** (一个用户多次答题)
3. **users -> exam_records** (一个用户多次考试)
4. **users -> activities** (一个用户多条动态)
5. **questions -> question_options** (一个题目多个选项)
6. **questions -> test_cases** (一个题目多个测试用例)
7. **questions -> submissions** (一个题目被多次提交)
8. **subjects -> questions** (一个科目多道题目)
9. **question_categories -> questions** (一个分类多道题目)

### 外键约束

- CASCADE DELETE：删除主表记录时自动删除相关子表记录
- 适用于：question_options, test_cases, submissions, user_answers, exam_records, activities

---

## 📈 性能优化

### 索引策略

1. **主键索引**：所有表的 id 字段
2. **唯一索引**：username, question_no, subject.code
3. **普通索引**：
   - 外键字段（user_id, question_id等）
   - 查询频繁的字段（type, status, difficulty等）
   - 时间字段（created_at）用于排序

### 查询优化建议

1. 使用 EXPLAIN 分析查询
2. 避免 SELECT *
3. 合理使用JOIN
4. 分页查询使用LIMIT
5. 对大文本字段（content, code）考虑分表

---

## 🔒 安全考虑

1. **密码加密**：使用 BCrypt 加密存储
2. **SQL注入防护**：使用MyBatis参数绑定
3. **权限控制**：role字段区分普通用户和管理员
4. **软删除**：考虑添加deleted字段（可选）

---

## 📊 数据统计字段

1. **questions表**：
   - submit_count：提交次数
   - accept_count：通过次数
   - pass_rate：通过率（自动计算）

2. **schools表**：
   - hot_index：热门指数
   - view_count：浏览次数

3. **submissions表**：
   - pass_count/total_count：测试用例通过情况

---

## 🎯 扩展建议

### 未来可能添加的表

1. **评论表** (comments)：题目评论讨论
2. **收藏表** (favorites)：用户收藏题目
3. **标签表** (tags)：题目标签系统
4. **通知表** (notifications)：系统通知
5. **竞赛表** (contests)：在线竞赛
6. **错题本表** (wrong_questions)：用户错题集

---

## ✅ 初始化检查清单

- [ ] 数据库创建成功
- [ ] 所有11张表创建成功
- [ ] 科目数据插入成功（5条）
- [ ] 题目分类数据插入成功（8条）
- [ ] 外键约束创建成功
- [ ] 索引创建成功
- [ ] 字符集为utf8mb4
- [ ] 后端配置文件已更新

---

**文档版本**：v1.0  
**更新时间**：2025-10-14  
**维护人员**：YLWY Developer
