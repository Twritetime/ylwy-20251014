# 研路无忧 - 开发环境配置信息

## 数据库配置

### MySQL 配置
```yaml
host: localhost
port: 3306
username: root
password: root
database: ylwy_db
```

**连接字符串**：
```
jdbc:mysql://localhost:3306/ylwy_db?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
```

### Redis 配置
```yaml
host: localhost
port: 6379
password: (无密码)
```

**安装路径**：`D:\phpstudy_pro\Extensions\redis3.0.504`

**启动命令**：
```powershell
cd D:\phpstudy_pro\Extensions\redis3.0.504
.\redis-server.exe --port 6379
```

**测试连接**：
```powershell
.\redis-cli.exe ping
# 应返回: PONG
```

## Maven 配置

**安装路径**：`D:\software\dev\apache-maven-3.9.11`

**环境变量**：
```
MAVEN_HOME=D:\software\dev\apache-maven-3.9.11
Path=%Path%;%MAVEN_HOME%\bin
```

## 环境验证

所有环境已配置完成并验证通过：

| 组件 | 版本 | 状态 | 配置 |
|------|------|------|------|
| Node.js | v22.20.0 | ✅ | 默认 |
| npm | v10.9.3 | ✅ | 默认 |
| Java JDK | 17.0.12 | ✅ | 默认 |
| Maven | 3.9.11 | ✅ | D:\software\dev\apache-maven-3.9.11 |
| Python | 3.12.10 | ✅ | 默认 |
| Docker | 28.5.1 | ✅ | 默认 |
| MySQL | 8.0.12 | ✅ | localhost:3306, root/root |
| Redis | 3.0.504 | ✅ | localhost:6379, 无密码 |

## 后端 application.yml 配置模板

```yaml
spring:
  application:
    name: ylwy-backend
  
  # 数据源配置
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/ylwy_db?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: root
    password: root
  
  # Redis 配置
  data:
    redis:
      host: localhost
      port: 6379
      database: 0
      timeout: 3000ms
  
  # JPA 配置 (如果使用)
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQL8Dialect

# MyBatis Plus 配置
mybatis-plus:
  configuration:
    map-underscore-to-camel-case: true
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
  mapper-locations: classpath:mapper/*.xml
  type-aliases-package: com.ylwy.entity

# 服务器配置
server:
  port: 8080
  servlet:
    context-path: /api

# JWT 配置
jwt:
  secret: ylwy-secret-key-2024-change-in-production
  expiration: 86400000  # 24小时
```

## 前端 .env 配置模板

```env
# 开发环境配置
VITE_API_BASE_URL=http://localhost:8080/api
VITE_UPLOAD_URL=http://localhost:8080/api/upload

# 生产环境配置 (.env.production)
# VITE_API_BASE_URL=https://api.yourdomain.com
```

## 数据库初始化

### 创建数据库
```sql
CREATE DATABASE IF NOT EXISTS ylwy_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE ylwy_db;
```

### 创建用户表 (示例)
```sql
CREATE TABLE `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码(加密)',
  `email` VARCHAR(100) COMMENT '邮箱',
  `nickname` VARCHAR(50) COMMENT '昵称',
  `avatar` VARCHAR(255) COMMENT '头像URL',
  `school_from` VARCHAR(100) COMMENT '本科院校',
  `school_target` VARCHAR(100) COMMENT '目标院校',
  `signature` VARCHAR(255) COMMENT '个性签名',
  `role` VARCHAR(20) DEFAULT 'user' COMMENT '角色(user/admin)',
  `status` TINYINT DEFAULT 1 COMMENT '状态(0禁用/1启用)',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  INDEX `idx_username` (`username`),
  INDEX `idx_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';
```

## 快速启动脚本

### 启动 Redis (start-redis.ps1)
```powershell
cd D:\phpstudy_pro\Extensions\redis3.0.504
Start-Process .\redis-server.exe -ArgumentList "--port 6379" -WindowStyle Minimized
Write-Host "Redis started on port 6379" -ForegroundColor Green
```

### 环境检查 (env-check.ps1)
已创建，运行：
```powershell
.\env-check.ps1
```

## 注意事项

1. **Redis 需要每次手动启动**（或配置为 Windows 服务）
2. **MySQL 密码为 root**，生产环境请修改为强密码
3. **JWT Secret** 在生产环境必须修改
4. 所有端口确保未被占用：
   - 前端: 5173
   - 后端: 8080
   - 判题服务: 8081
   - MySQL: 3306
   - Redis: 6379
