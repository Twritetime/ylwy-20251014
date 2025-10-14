# 研路无忧 - 计算机考研刷题平台

完全仿照 [NoobDream](https://noobdream.com/) 的计算机考研刷题平台，包含在线编程题库、选择题题库、智能组卷、学校信息查询等功能。

## 项目结构

```
ylwy-20251014/
├── frontend/          # 前端项目 (Vue 3 + Vite + Tailwind CSS)
├── backend/           # 后端项目 (Spring Boot 3.x)
├── judge-server/      # 判题服务器 (Spring Boot + Docker)
├── crawler/           # 数据爬虫 (Python)
└── database/          # 数据库脚本
```

## 技术栈

### 前端
- Vue 3.5.22
- Vite 7.1.7
- Tailwind CSS 4.1.14
- Element Plus 2.11.4
- Vue Router 4.6.0
- Pinia 3.0.3
- Axios 1.12.2
- Monaco Editor (代码编辑器)

### 后端
- Spring Boot 3.2.0
- Spring Security
- MyBatis Plus 3.5.5
- MySQL 8.x
- Redis 3.0.504
- JWT 0.12.3
- Lombok
- Hutool

### 判题服务
- Spring Boot 3.2.0
- Docker (代码沙箱)

### 数据爬虫
- Python 3.12.10
- BeautifulSoup4
- Requests

## 快速开始

### 1. 环境要求

- Node.js 22.x+
- Java JDK 17+
- Maven 3.9+
- MySQL 8.x
- Redis 3.x+
- Python 3.12+
- Docker (可选，用于判题)

### 2. 数据库初始化

使用 Navicat 或其他 MySQL 客户端执行：

```sql
-- 1. 创建数据库
CREATE DATABASE ylwy_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 2. 执行初始化脚本
-- 导入 database/init.sql
```

或使用命令行：

```bash
mysql -u root -p < database/init.sql
```

### 3. 启动 Redis

确保 Redis 服务已启动：

- Windows: 启动 `D:\phpstudy_pro\Extensions\redis3.0.504\redis-server.exe`
- Linux/Mac: `redis-server`

### 4. 配置环境变量

#### Windows PowerShell

```powershell
# 配置 JAVA_HOME
$env:JAVA_HOME = "C:\Program Files\Java\jdk-17"

# 配置 Maven（如果未全局配置）
$env:MAVEN_HOME = "D:\software\dev\apache-maven-3.9.11"
$env:PATH += ";$env:MAVEN_HOME\bin"
```

#### Windows CMD

```cmd
set JAVA_HOME=C:\Program Files\Java\jdk-17
set MAVEN_HOME=D:\software\dev\apache-maven-3.9.11
set PATH=%PATH%;%MAVEN_HOME%\bin
```

### 5. 启动后端服务

#### 方式一：使用启动脚本（推荐）

```bash
cd backend
start.bat
```

#### 方式二：使用 Maven 命令

```bash
cd backend
mvn spring-boot:run
```

#### 方式三：使用 IDE

在 IntelliJ IDEA 或 Eclipse 中直接运行 `YlwyApplication.java`

后端服务将在 `http://localhost:8080/api` 启动

### 6. 启动前端服务

```bash
cd frontend
npm install    # 首次运行需要安装依赖
npm run dev
```

前端服务将在 `http://localhost:5173` 启动

### 7. 启动判题服务（可选）

```bash
cd judge-server
mvn spring-boot:run
```

判题服务将在 `http://localhost:8081` 启动

## 项目功能

### ✅ 已完成

- [x] 用户注册、登录、JWT 认证
- [x] 题库列表（支持筛选：题目类型、难度、科目）
- [x] 题目详情页
  - [x] 选择题答题
  - [x] 编程题代码编辑器（Monaco Editor）
- [x] 院校列表与查询
- [x] 科目分类
- [x] 响应式布局

### 🚧 进行中

- [ ] 代码提交与判题系统
- [ ] 用户提交记录
- [ ] 排行榜统计
- [ ] 智能组卷功能

### 📋 待开发

- [ ] 用户个人中心
- [ ] 题目收藏与笔记
- [ ] 讨论区
- [ ] 数据爬虫（爬取 NoobDream 数据）
- [ ] 管理后台

## 数据库设计

项目包含 11 张核心数据表：

1. `users` - 用户表
2. `questions` - 题目表
3. `question_options` - 题目选项表
4. `test_cases` - 测试用例表
5. `submissions` - 提交记录表
6. `user_answers` - 用户答案表
7. `exam_records` - 组卷记录表
8. `schools` - 院校表
9. `subjects` - 科目表
10. `question_categories` - 题目分类表
11. `activities` - 动态表

## API 接口

### 认证接口

- `POST /api/auth/register` - 用户注册
- `POST /api/auth/login` - 用户登录
- `GET /api/auth/current` - 获取当前用户信息

### 题库接口

- `GET /api/questions/list` - 获取题目列表（分页、筛选）
- `GET /api/questions/{id}` - 获取题目详情

### 科目接口

- `GET /api/subjects/list` - 获取科目列表

### 院校接口

- `GET /api/schools/list` - 获取院校列表（分页、搜索）

## 开发说明

### 前端开发

```bash
cd frontend
npm run dev     # 开发模式
npm run build   # 生产构建
npm run preview # 预览生产构建
```

### 后端开发

```bash
cd backend
mvn clean install  # 编译打包
mvn spring-boot:run  # 运行
```

## 配置说明

### 后端配置

编辑 `backend/src/main/resources/application.yml`：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ylwy_db
    username: root
    password: root  # 修改为你的数据库密码
  
  data:
    redis:
      host: localhost
      port: 6379

jwt:
  secret: ylwy-secret-key-2024-please-change-in-production-environment
  expiration: 86400000  # 24小时
```

### 前端配置

编辑 `frontend/.env.development`：

```
VITE_API_BASE_URL=http://localhost:8080/api
```

## 注意事项

1. **数据库配置**：确保 MySQL 已启动，并且数据库密码与配置文件一致
2. **Redis 配置**：确保 Redis 服务已启动
3. **端口占用**：
   - 前端默认 5173 端口
   - 后端默认 8080 端口
   - 判题服务默认 8081 端口
4. **CORS**：后端已配置允许前端跨域请求
5. **JWT Secret**：生产环境请修改为强密钥

## 常见问题

### Q: 启动后端时提示 JAVA_HOME 未设置？

A: 请先配置 JAVA_HOME 环境变量，指向 JDK 17 的安装目录。

### Q: 前端无法连接后端？

A: 检查：
1. 后端服务是否启动成功（访问 http://localhost:8080/api）
2. 前端 `.env.development` 配置是否正确
3. 浏览器控制台是否有 CORS 错误

### Q: 数据库连接失败？

A: 检查：
1. MySQL 服务是否启动
2. 数据库名称是否为 `ylwy_db`
3. 用户名密码是否正确
4. `application.yml` 配置是否正确

## 许可证

本项目仅用于学习研究，不得用于商业用途。

## 联系方式

如有问题，请提交 Issue。
