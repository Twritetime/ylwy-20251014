# 研路无忧

## 项目概述

研路无忧考研服务平台 - 完全仿照 [NoobDream](https://noobdream.com/) 的计算机考研刷题平台

### 核心功能
- ✅ 在线编程题库（OJ判题系统）
- ✅ 选择题题库
- ✅ 智能组卷系统
- ✅ 学校信息查询
- ✅ 用户系统（注册/登录/个人中心）
- ✅ 实时动态流
- ✅ 排行榜统计

## 项目结构

```
ylwy-20251014/
├── frontend/              # 前端项目 (Vue 3 + Vite + Tailwind + Element Plus)
│   ├── src/
│   ├── package.json
│   └── vite.config.js
├── backend/               # 后端项目 (Spring Boot 3.x + MyBatis Plus)
│   ├── src/
│   ├── pom.xml
│   └── application.yml
├── judge-server/          # 判题服务器 (独立服务 + Docker沙箱)
│   ├── src/
│   ├── pom.xml
│   └── application.yml
├── crawler/               # 数据爬虫 (Python)
│   ├── crawler.py
│   ├── config.py
│   └── requirements.txt
├── docs/                  # 项目文档
├── env-check.ps1          # 环境检查脚本
├── start-redis.ps1        # Redis 启动脚本
├── start.ps1              # 项目启动脚本
└── README.md              # 项目说明
```

## 技术架构

### 前端技术栈
- **Vue 3** - 渐进式JavaScript框架
- **Tailwind CSS** - 实用优先的CSS框架
- **Element Plus** - Vue 3组件库
- **Vite** - 前端构建工具
- **Pinia** - 状态管理
- **Vue Router** - 路由管理
- **Monaco Editor** - 代码编辑器（OJ系统）

### 后端技术栈
- **Spring Boot 3.x** - 单体应用框架
- **Spring Security** - 安全框架
- **MyBatis Plus** - 数据访问层框架
- **MySQL** - 主数据库
- **Redis** - 缓存和会话存储
- **JWT** - 身份认证
- **Docker** - OJ判题沙箱

### 爬虫技术栈
- **Python 3.12**
- **Requests** - HTTP库
- **BeautifulSoup4** - HTML解析
- **PyMySQL** - 数据库连接

## 快速开始

### 1. 环境检查

```powershell
# 运行环境检查脚本
.\env-check.ps1
```

**需要的环境**：
- Node.js v22.20.0 ✅
- Java JDK 17.0.12 ✅
- Maven 3.9.11 ✅
- Python 3.12.10 ✅
- Docker 28.5.1 ✅
- MySQL 8.x ✅
- Redis 3.0.504 ✅

### 2. 启动 Redis

```powershell
.\start-redis.ps1
```

### 3. 初始化数据库

连接 MySQL 并执行：

```sql
CREATE DATABASE IF NOT EXISTS ylwy_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

### 4. 安装依赖

**前端：**
```powershell
cd frontend
npm install
```

**后端：**
```powershell
cd backend
mvn clean install
```

**判题服务器：**
```powershell
cd judge-server
mvn clean install
```

**爬虫：**
```powershell
cd crawler
pip install -r requirements.txt
```

### 5. 启动项目

**方法一：使用启动脚本**
```powershell
.\start.ps1
```

**方法二：手动启动（需要3个终端）**

终端 1 - 前端：
```powershell
cd frontend
npm run dev
# 访问: http://localhost:5173
```

终端 2 - 后端：
```powershell
cd backend
mvn spring-boot:run
# API: http://localhost:8080/api
```

终端 3 - 判题服务器：
```powershell
cd judge-server
mvn spring-boot:run
# 服务: http://localhost:8081
```

## 数据爬取

```powershell
cd crawler
python crawler.py
```

**❗ 重要提示**：
- 爬取的数据仅供学习研究使用
- 不得用于商业目的
- 请遵守目标网站的 robots.txt 规则

## 端口说明

| 服务 | 端口 | 说明 |
|------|------|------|
| 前端开发服务器 | 5173 | Vite 默认端口 |
| 后端API服务 | 8080 | Spring Boot |
| 判题服务器 | 8081 | 独立服务 |
| MySQL | 3306 | 数据库 |
| Redis | 6379 | 缓存 |

## 开发文档

- [`INSTALL_GUIDE.md`](./INSTALL_GUIDE.md) - 安装指南
- [`DEV_CONFIG.md`](./DEV_CONFIG.md) - 开发配置详情
- [`PROJECT_CONFIG.md`](./PROJECT_CONFIG.md) - 项目配置说明
- [`ENV_SETUP_COMPLETE.md`](./ENV_SETUP_COMPLETE.md) - 环境配置完成指引

## 开发进度

- [x] 环境搭建
- [x] 项目脚手架创建
- [ ] 数据库设计
- [ ] 用户系统开发
- [ ] 题库系统开发
- [ ] OJ判题系统开发
- [ ] 学校信息模块
- [ ] 智能组卷功能
- [ ] UI完善
- [ ] 测试与优化

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License

## 致谢

感谢 [NoobDream](https://noobdream.com/) 提供的优秀平台参考。