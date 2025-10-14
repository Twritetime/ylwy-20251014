# 判题服务器实现文档

**实现时间**: 2025-10-14  
**版本**: v1.0-基础版  
**状态**: ✅ 已完成核心功能

---

## 📊 实现概览

### 功能特性
- ✅ 支持C++、Java、Python三种语言
- ✅ 代码编译功能 (C++/Java)
- ✅ 代码运行功能
- ✅ 测试用例对比
- ✅ 运行时间统计
- ✅ 超时控制 (TLE)
- ✅ 错误处理 (CE/RE/WA)
- ✅ RESTful API接口

### 判题状态
- `PENDING` - 等待判题
- `JUDGING` - 判题中
- `AC` - 答案正确 ✅
- `WA` - 答案错误 ❌
- `TLE` - 超时 ⏱️
- `MLE` - 内存超限 💾
- `RE` - 运行时错误 💥
- `CE` - 编译错误 🔧
- `SE` - 系统错误 ⚙️

---

## 🏗️ 架构设计

### 目录结构
```
judge-server/
├── src/main/java/com/ylwy/judge/
│   ├── JudgeServerApplication.java   # 主应用类
│   ├── config/
│   │   └── JudgeConfig.java          # 判题配置
│   ├── controller/
│   │   └── JudgeController.java      # 判题控制器
│   ├── service/
│   │   └── JudgeEngine.java          # 判题引擎（核心）
│   ├── dto/
│   │   ├── JudgeRequest.java         # 判题请求DTO
│   │   └── JudgeResponse.java        # 判题响应DTO
│   └── enums/
│       └── JudgeStatus.java          # 判题状态枚举
└── src/main/resources/
    └── application.yml                # 配置文件
```

### 核心类说明

#### 1. JudgeEngine (判题引擎)
**文件**: `service/JudgeEngine.java`  
**职责**: 判题核心逻辑

**主要方法**:
- `judge(JudgeRequest)` - 执行判题
- `compile(JudgeRequest)` - 编译代码
- `runTestCase()` - 运行测试用例

**判题流程**:
```
1. 创建工作目录 (/tmp/ylwy-judge/UUID/)
2. 写入代码文件 (Main.cpp/Main.java/Main.py)
3. 编译代码 (C++/Java需要，Python跳过)
4. 对每个测试用例:
   a. 运行程序
   b. 写入输入数据
   c. 读取输出结果
   d. 对比期望输出
   e. 检查超时/错误
5. 返回判题结果
```

#### 2. JudgeController (判题控制器)
**文件**: `controller/JudgeController.java`  
**职责**: 提供RESTful API

**API接口**:
- `POST /judge/execute` - 执行判题
- `GET /judge/health` - 健康检查

---

## 🔧 技术实现

### 编译命令

#### C++
```bash
g++ -std=c++17 -O2 -o Main Main.cpp
```
- 标准: C++17
- 优化: O2
- 输出: Main可执行文件

#### Java
```bash
javac Main.java
```
- 编译: Main.java → Main.class

#### Python
```bash
python3 Main.py
```
- 解释执行，无需编译

### 运行命令

#### C++
```bash
./Main
```

#### Java
```bash
java -cp . Main
```

#### Python
```bash
python3 Main.py
```

### 超时控制
使用Java Process的 `waitFor(timeout, TimeUnit.MILLISECONDS)` 方法：
```java
boolean finished = process.waitFor(timeLimit, TimeUnit.MILLISECONDS);
if (!finished) {
    process.destroy(); // 超时则强制终止
    return TLE;
}
```

### 输入输出处理
```java
// 写入输入数据
try (OutputStream os = process.getOutputStream()) {
    os.write(testCase.getInput().getBytes());
    os.flush();
}

// 读取输出结果
String output = readStream(process.getInputStream());
String error = readStream(process.getErrorStream());
```

---

## 📝 API文档

### 执行判题

**接口**: `POST /judge/execute`  
**Content-Type**: `application/json`

**请求体**:
```json
{
  "submissionId": 1,
  "questionId": 6,
  "language": "cpp",
  "code": "#include <iostream>\nusing namespace std;\n\nint main() {\n    int a, b;\n    cin >> a >> b;\n    cout << a + b << endl;\n    return 0;\n}\n",
  "testCases": [
    {
      "input": "1 2",
      "expectedOutput": "3"
    },
    {
      "input": "5 10",
      "expectedOutput": "15"
    }
  ],
  "timeLimit": 1000,
  "memoryLimit": 262144
}
```

**响应体**:
```json
{
  "submissionId": 1,
  "status": "ac",
  "message": "答案正确",
  "timeUsed": 45,
  "memoryUsed": 0,
  "passCount": 2,
  "totalCount": 2,
  "errorMessage": null,
  "compileOutput": null
}
```

### 字段说明

**请求字段**:
| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| submissionId | Long | 是 | 提交ID |
| questionId | Long | 是 | 题目ID |
| language | String | 是 | 编程语言(cpp/java/python) |
| code | String | 是 | 用户代码 |
| testCases | Array | 是 | 测试用例列表 |
| timeLimit | Integer | 否 | 时间限制(ms)，默认1000 |
| memoryLimit | Integer | 否 | 内存限制(KB)，默认262144 |

**测试用例字段**:
| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| input | String | 是 | 输入数据 |
| expectedOutput | String | 是 | 期望输出 |

**响应字段**:
| 字段 | 类型 | 说明 |
|------|------|------|
| submissionId | Long | 提交ID |
| status | String | 判题状态(ac/wa/tle/mle/re/ce/se) |
| message | String | 状态消息 |
| timeUsed | Integer | 运行时间(ms) |
| memoryUsed | Integer | 内存使用(KB) |
| passCount | Integer | 通过的测试用例数 |
| totalCount | Integer | 总测试用例数 |
| errorMessage | String | 错误信息(可选) |
| compileOutput | String | 编译输出(可选) |

---

## 🧪 测试用例

### 测试C++代码(A+B问题)

**代码**:
```cpp
#include <iostream>
using namespace std;

int main() {
    int a, b;
    cin >> a >> b;
    cout << a + b << endl;
    return 0;
}
```

**测试用例**:
- 输入: `1 2`, 期望输出: `3`
- 输入: `5 10`, 期望输出: `15`

**预期结果**: ✅ AC (答案正确)

### 测试超时

**代码**:
```cpp
#include <iostream>
using namespace std;

int main() {
    while(true) {} // 无限循环
    return 0;
}
```

**预期结果**: ⏱️ TLE (超时)

### 测试编译错误

**代码**:
```cpp
#include <iostream>

int main() {
    cout << "Hello" // 缺少分号
    return 0;
}
```

**预期结果**: 🔧 CE (编译错误)

### 测试运行时错误

**代码**:
```cpp
#include <iostream>
using namespace std;

int main() {
    int arr[5];
    cout << arr[1000000] << endl; // 数组越界
    return 0;
}
```

**预期结果**: 💥 RE (运行时错误)

### 测试答案错误

**代码**:
```cpp
#include <iostream>
using namespace std;

int main() {
    int a, b;
    cin >> a >> b;
    cout << a - b << endl; // 应该是加法，写成了减法
    return 0;
}
```

**预期结果**: ❌ WA (答案错误)

---

## ⚙️ 配置说明

### application.yml

```yaml
server:
  port: 8081  # 判题服务器端口

judge:
  work-dir: D:/temp/ylwy-judge  # 工作目录
  default-time-limit: 1000      # 默认时间限制(ms)
  default-memory-limit: 262144  # 默认内存限制(KB)
  enable-docker: false          # 是否启用Docker(暂未实现)
```

### 环境要求

**必须安装**:
- ✅ JDK 17+
- ✅ Maven 3.9+
- ✅ g++ (C++编译器)
- ✅ Java JDK (javac/java)
- ✅ Python 3.x

**检查命令**:
```bash
g++ --version        # 检查C++编译器
javac -version       # 检查Java编译器
python3 --version    # 检查Python版本
```

---

## 🚀 启动指南

### 编译项目
```bash
cd judge-server
mvn clean compile
```

### 启动服务
```bash
mvn spring-boot:run
```

### 验证运行
```bash
curl http://localhost:8081/judge/health
# 预期输出: Judge Server is running!
```

---

## 📊 当前限制

### 已实现 ✅
- [x] 基本编译运行功能
- [x] 超时控制
- [x] 测试用例对比
- [x] 多种判题状态
- [x] C++/Java/Python支持

### 未实现 ❌
- [ ] Docker沙箱隔离
- [ ] 内存限制检测
- [ ] 进程资源限制
- [ ] 安全沙箱环境
- [ ] 并发判题处理
- [ ] 判题队列管理

---

## 🔒 安全风险

### 当前风险
1. **⚠️ 无沙箱隔离** - 代码直接在宿主机运行
2. **⚠️ 无资源限制** - 可能消耗过多CPU/内存
3. **⚠️ 文件系统访问** - 可访问系统文件
4. **⚠️ 网络访问** - 可发起网络请求

### 缓解措施
- 🔧 仅在开发环境使用
- 🔧 不对外暴露端口
- 🔧 限制代码执行时间
- 🔧 定期清理工作目录

### 后续优化
1. **Docker沙箱** - 使用Docker容器隔离
2. **cgroups限制** - CPU/内存限制
3. **seccomp过滤** - 系统调用过滤
4. **网络隔离** - 禁止网络访问

---

## 📈 性能指标

### 当前性能
- **编译时间**: < 2秒 (C++/Java)
- **运行时间**: < 1秒 (默认限制)
- **并发能力**: 单线程 (暂不支持并发)

### 优化方向
1. **编译缓存** - 相同代码避免重复编译
2. **异步处理** - 使用线程池并发判题
3. **资源池化** - 复用Docker容器
4. **结果缓存** - 缓存判题结果

---

## 🎯 下一步计划

### Phase 1: Docker沙箱集成 (优先级: 高🔥)
- [ ] 安装Docker Desktop
- [ ] 创建判题镜像(C++/Java/Python)
- [ ] 实现Docker容器创建和销毁
- [ ] 配置资源限制(CPU/内存)
- [ ] 测试沙箱隔离性

### Phase 2: 后端集成 (优先级: 高🔥)
- [ ] 安装RabbitMQ或配置Redis队列
- [ ] SubmissionController调用判题服务
- [ ] 异步判题任务处理
- [ ] 判题结果回写数据库
- [ ] WebSocket实时推送结果

### Phase 3: 性能优化 (优先级: 中⚡)
- [ ] 线程池并发判题
- [ ] 编译结果缓存
- [ ] 工作目录清理策略
- [ ] 监控和日志完善

### Phase 4: 功能增强 (优先级: 低⭐)
- [ ] 更多语言支持(Go, Rust等)
- [ ] Special Judge支持
- [ ] 交互题支持
- [ ] 判题机集群

---

## 📚 参考资料

### 开源OJ系统
- [Judge0](https://github.com/judge0/judge0) - 开源判题系统
- [DMOJ](https://github.com/DMOJ/judge-server) - Python判题服务器
- [HUSTOJ](https://github.com/zhblue/hustoj) - 中文OJ系统

### 技术文档
- [Docker Java API](https://github.com/docker-java/docker-java)
- [Spring Boot](https://spring.io/projects/spring-boot)
- [Process管理](https://docs.oracle.com/javase/8/docs/api/java/lang/Process.html)

---

## 🎊 总结

**判题服务器v1.0基础版**已经实现并成功运行！

**主要成果**:
- ✅ 7个核心类文件
- ✅ 支持3种编程语言
- ✅ 完整的判题流程
- ✅ RESTful API接口
- ✅ 服务正常运行(端口8081)

**下一步**:
1. 🔥 集成Docker沙箱(安全性)
2. 🔥 对接后端服务(实际使用)
3. ⚡ 性能优化(并发处理)

**服务状态**: 🟢 运行中 (http://localhost:8081)

**继续加油，完善判题系统！** 💪🚀
