# 研路无忧 - 环境安装指南

## ✅ 已安装的环境

### 1. Node.js v22.20.0
- **用途**: 前端项目开发（Vue 3 + Vite）
- **验证**: `node --version`
- **npm版本**: 自带 npm

### 2. Java JDK 17.0.12
- **用途**: 后端项目开发（Spring Boot 3.x）
- **验证**: `java -version`
- **环境变量**: 已自动配置

### 3. Python 3.12.10
- **用途**: 数据爬虫开发
- **验证**: `python --version`
- **包管理器**: pip3

### 4. Docker Desktop 28.4.0
- **用途**: 
  - 运行 MySQL 容器
  - 运行 Redis 容器
  - OJ 判题沙箱环境
- **验证**: `docker --version`
- **注意**: 需要手动启动 Docker Desktop

### 5. MySQL 8.4.6
- **用途**: 主数据库
- **安装方式**: 已安装 MSI 包，建议使用 Docker 运行
- **推荐配置**: 见下文

---

## ⚙️ 需要配置的环境

### 1. Maven (构建工具)

由于 winget 没有 Maven，请手动安装：

#### 方法一：使用 Scoop (推荐)
```powershell
# 安装 Scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

# 安装 Maven
scoop install maven
```

#### 方法二：手动下载
1. 下载: https://maven.apache.org/download.cgi
2. 解压到: `C:\Program Files\Apache\Maven`
3. 添加环境变量:
   - `MAVEN_HOME`: `C:\Program Files\Apache\Maven`
   - `Path`: 添加 `%MAVEN_HOME%\bin`

### 2. Redis

使用 Docker 运行（推荐）:

```powershell
docker run -d --name ylwy-redis -p 6379:6379 redis:7-alpine
```

### 3. MySQL

使用 Docker 运行（推荐）:

```powershell
docker run -d --name ylwy-mysql `
  -p 3306:3306 `
  -e MYSQL_ROOT_PASSWORD=ylwy123456 `
  -e MYSQL_DATABASE=ylwy_db `
  -v ylwy-mysql-data:/var/lib/mysql `
  mysql:8.0
```

**默认配置**:
- 端口: 3306
- 用户: root
- 密码: ylwy123456
- 数据库: ylwy_db

---

## 🚀 快速启动

### 1. 启动 Docker Desktop
- 从开始菜单打开 "Docker Desktop"
- 等待 Docker 引擎启动（任务栏图标变绿）

### 2. 启动 MySQL 和 Redis
```powershell
# 启动 MySQL
docker start ylwy-mysql

# 如果容器不存在，创建并启动
docker run -d --name ylwy-mysql `
  -p 3306:3306 `
  -e MYSQL_ROOT_PASSWORD=ylwy123456 `
  -e MYSQL_DATABASE=ylwy_db `
  -v ylwy-mysql-data:/var/lib/mysql `
  mysql:8.0

# 启动 Redis
docker start ylwy-redis

# 如果容器不存在，创建并启动
docker run -d --name ylwy-redis -p 6379:6379 redis:7-alpine
```

### 3. 验证环境
```powershell
# 刷新环境变量
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# 验证 Node.js
node --version
npm --version

# 验证 Java
java -version

# 验证 Python
python --version
pip --version

# 验证 Docker
docker --version
docker ps

# 验证 Maven (安装后)
mvn --version
```

### 4. 验证数据库连接
```powershell
# 连接 MySQL (需要 MySQL 客户端或使用 Docker)
docker exec -it ylwy-mysql mysql -uroot -pylwy123456

# 连接 Redis
docker exec -it ylwy-redis redis-cli
```

---

## 📝 环境变量配置

如果环境变量未生效，手动配置：

### 方法一：PowerShell 临时配置
```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

### 方法二：永久配置
1. 右键"此电脑" → "属性"
2. "高级系统设置" → "环境变量"
3. 确认以下路径在 Path 中:
   - `C:\Program Files\nodejs\`
   - `C:\Program Files\Java\jdk-17\bin`
   - `C:\Users\你的用户名\AppData\Local\Programs\Python\Python312\`
   - `C:\Program Files\Docker\Docker\resources\bin`

---

## 🔧 故障排除

### Docker 无法启动
1. 确保 WSL2 已启用
2. 确保 Hyper-V 已启用 (Windows 专业版)
3. 重启电脑

### MySQL/Redis 无法连接
1. 检查 Docker Desktop 是否运行
2. 检查容器是否启动: `docker ps`
3. 检查端口是否被占用: `netstat -ano | findstr "3306"`

### Maven 命令找不到
1. 确认 Maven 已安装
2. 确认环境变量已配置
3. 重启终端或 IDE

---

## 📚 下一步

环境配置完成后，可以开始：

1. 搭建前端项目框架
2. 搭建后端项目框架
3. 搭建判题服务器
4. 开发数据爬虫

详见项目开发文档。
