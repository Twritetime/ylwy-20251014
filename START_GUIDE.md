# 研路无忧 - 启动指南

## 系统要求

- **Java**: JDK 17+
- **Maven**: Apache Maven 3.9+
- **Node.js**: v22 LTS
- **MySQL**: 8.0+
- **Redis**: 3.0+

## 快速启动

### 1. 启动后端服务

```bash
cd backend
D:\software\dev\apache-maven-3.9.11\bin\mvn.cmd --global-settings settings.xml spring-boot:run
```

**服务地址**: http://localhost:8080/api

**启动成功标志**:
```
========================================
  研路无忧后端服务启动成功！
  API地址: http://localhost:8080/api
========================================
```

### 2. 启动前端服务

```bash
cd frontend
npm run dev
```

**服务地址**: http://localhost:5173

**启动成功标志**:
```
VITE v7.1.9  ready in 259 ms
➜  Local:   http://localhost:5173/
```

## 功能访问

### 主要页面

1. **首页**: http://localhost:5173/
2. **题库**: http://localhost:5173/questions
3. **院校查询**: http://localhost:5173/schools
4. **排行榜**: http://localhost:5173/ranking (新增)
5. **题目详情**: http://localhost:5173/questions/:id

### 测试账号

所有测试账号密码统一为: `123456`

| 用户名 | 昵称 | 角色 |
|--------|------|------|
| admin | 管理员 | admin |
| zhangsan | 小张 | user |
| lisi | 小李 | user |
| wangwu | 小王 | user |

## API接口

### 排行榜相关接口

#### 1. 获取排行榜列表
```
GET /api/rank/list?limit=100
```

**响应示例**:
```json
{
  "code": 200,
  "message": "操作成功",
  "data": [
    {
      "userId": 1,
      "username": "admin",
      "nickname": "管理员",
      "avatar": "https://avatar.default.com/default.png",
      "acCount": 5,
      "submitCount": 10,
      "acRate": 50.0,
      "rank": 1
    }
  ]
}
```

#### 2. 获取我的排名
```
GET /api/rank/my
Authorization: Bearer {token}
```

### 其他核心接口

- `POST /api/auth/login` - 用户登录
- `POST /api/auth/register` - 用户注册
- `GET /api/questions/list` - 获取题目列表
- `GET /api/questions/{id}` - 获取题目详情
- `POST /api/submissions/submit` - 提交代码
- `GET /api/submissions/my` - 获取我的提交记录

## 开发工具

### 后端热重载

使用Spring Boot DevTools，修改Java文件后自动重启：
```bash
mvn spring-boot:run
```

### 前端热重载

Vite自动热更新，修改Vue文件后浏览器自动刷新：
```bash
npm run dev
```

## 数据库

### 导入测试数据

```bash
# Windows PowerShell
D:\phpstudy_pro\Extensions\MySQL5.7.26\bin\mysql.exe `
  -uroot -proot `
  --default-character-set=utf8mb4 `
  ylwy_db < database/test_data.sql
```

### 清空测试数据

```bash
D:\phpstudy_pro\Extensions\MySQL5.7.26\bin\mysql.exe `
  -uroot -proot `
  --default-character-set=utf8mb4 `
  ylwy_db < database/clear_test_data.sql
```

## 故障排除

### 问题1: Maven配置错误
**错误信息**: `Non-parseable settings`

**解决方案**: 使用项目本地settings.xml
```bash
mvn --global-settings settings.xml spring-boot:run
```

### 问题2: 端口被占用
**错误信息**: `Port 8080 is already in use`

**解决方案**: 
```bash
# 查找占用进程
netstat -ano | findstr "8080"
# 杀死进程
taskkill /PID <进程ID> /F
```

### 问题3: 前端启动失败
**错误信息**: `EADDRINUSE: address already in use`

**解决方案**: 修改端口或关闭占用的进程
```bash
# 在vite.config.js中修改端口
server: { port: 5174 }
```

### 问题4: 数据库连接失败
**错误信息**: `Access denied for user`

**解决方案**: 检查application.yml配置
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ylwy_db
    username: root
    password: root
```

## 开发文档

- **项目总结**: `DEVELOPMENT_SUMMARY.md`
- **排行榜开发日志**: `DEVELOPMENT_LOG_RANKING.md`
- **测试数据说明**: `database/README_TEST_DATA.md`
- **API文档**: 启动后访问 http://localhost:8080/api/doc.html

## 技术栈

### 后端
- Spring Boot 3.2.0
- MyBatis Plus 3.5.7
- Spring Security + JWT
- MySQL 8.0
- Redis 3.0

### 前端
- Vue 3.5.22
- Vite 7.1.9
- Element Plus 2.11.4
- Tailwind CSS 4.1.14
- Monaco Editor 0.52.2

## 项目结构

```
ylwy-20251014/
├── backend/              # 后端Spring Boot项目
│   ├── src/
│   │   └── main/
│   │       ├── java/
│   │       │   └── com/ylwy/
│   │       │       ├── controller/  # 控制器
│   │       │       ├── service/     # 服务层
│   │       │       ├── mapper/      # 数据访问层
│   │       │       ├── entity/      # 实体类
│   │       │       ├── dto/         # 数据传输对象
│   │       │       └── common/      # 公共类
│   │       └── resources/
│   │           └── application.yml  # 配置文件
│   ├── pom.xml           # Maven配置
│   └── settings.xml      # Maven本地配置
│
├── frontend/             # 前端Vue项目
│   ├── src/
│   │   ├── views/        # 页面组件
│   │   ├── components/   # 公共组件
│   │   ├── api/          # API接口
│   │   ├── stores/       # Pinia状态管理
│   │   ├── router/       # 路由配置
│   │   └── utils/        # 工具函数
│   ├── package.json      # npm配置
│   └── vite.config.js    # Vite配置
│
└── database/             # 数据库脚本
    ├── schema.sql        # 表结构
    ├── test_data.sql     # 测试数据
    └── clear_test_data.sql  # 清空数据
```

## 联系方式

如有问题，请联系开发团队。
