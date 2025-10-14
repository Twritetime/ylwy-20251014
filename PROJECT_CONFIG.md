# 研路无忧项目配置

## 开发环境配置

### 已验证的环境
- ✅ Node.js: v22.20.0
- ✅ npm: v10.9.3
- ✅ Java JDK: 17.0.12
- ✅ Maven: 3.9.11
- ✅ Python: 3.12.10
- ✅ pip: 25.0.1
- ✅ Docker: 28.4.0
- ✅ MySQL: 运行中 (端口 3306)
- ⚠️ Redis: 需要确认运行状态

### 环境变量配置
```
MAVEN_HOME=D:\software\dev\apache-maven-3.9.11
Path包含:
  - C:\Program Files\nodejs\
  - C:\Program Files\Java\jdk-17\bin
  - D:\software\dev\apache-maven-3.9.11\bin
  - C:\Users\Administrator\AppData\Local\Programs\Python\Python312\
```

### 数据库配置
- **MySQL**
  - 主机: localhost
  - 端口: 3306
  - 用户: root
  - 密码: (请根据实际配置)
  - 数据库: ylwy_db (待创建)

- **Redis**
  - 主机: localhost
  - 端口: 6379
  - 密码: (如有)

## 项目结构规划

```
ylwy-20251014/
├── frontend/              # 前端项目 (Vue 3 + Vite + Tailwind + Element Plus)
├── backend/               # 后端项目 (Spring Boot 3.x + MyBatis Plus)
├── judge-server/          # 判题服务器 (独立服务 + Docker沙箱)
├── crawler/               # 数据爬虫 (Python)
├── docs/                  # 项目文档
├── env-check.ps1          # 环境检查脚本
├── INSTALL_GUIDE.md       # 安装指南
├── PROJECT_CONFIG.md      # 项目配置 (本文件)
└── README.md              # 项目说明
```

## 快速验证环境

运行环境检查脚本:
```powershell
.\env-check.ps1
```

## 下一步：项目初始化

### 1. 初始化前端项目
```powershell
cd frontend
npm create vite@latest . -- --template vue
npm install
npm install -D tailwindcss postcss autoprefixer
npm install element-plus
npm install pinia vue-router axios
npm install monaco-editor
```

### 2. 初始化后端项目
使用 Spring Initializr 或 Maven 创建项目，包含依赖:
- Spring Boot 3.x
- Spring Web
- Spring Security
- MyBatis Plus
- MySQL Driver
- Redis
- Lombok

### 3. 初始化判题服务器
基于 Spring Boot 或 Node.js，配置 Docker 沙箱环境

### 4. 初始化爬虫项目
```powershell
cd crawler
pip install requests beautifulsoup4 lxml scrapy
```

## 数据库初始化

执行以下 SQL 创建数据库:
```sql
CREATE DATABASE IF NOT EXISTS ylwy_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;
```

## 端口规划

| 服务 | 端口 | 说明 |
|------|------|------|
| 前端开发服务器 | 5173 | Vite 默认端口 |
| 后端API服务 | 8080 | Spring Boot 默认端口 |
| 判题服务器 | 8081 | 独立判题服务 |
| MySQL | 3306 | 数据库 |
| Redis | 6379 | 缓存 |

## 开发规范

### Git 提交规范
- feat: 新功能
- fix: 修复bug
- docs: 文档更新
- style: 代码格式调整
- refactor: 重构
- test: 测试相关
- chore: 构建/工具相关

### 分支策略
- main: 主分支（生产环境）
- develop: 开发分支
- feature/*: 功能分支
- fix/*: 修复分支

## 参考资料
- NoobDream 原站: https://noobdream.com/
- Vue 3 文档: https://cn.vuejs.org/
- Spring Boot 文档: https://spring.io/projects/spring-boot
- Element Plus: https://element-plus.org/zh-CN/
- Tailwind CSS: https://tailwindcss.com/
