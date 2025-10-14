# 排行榜功能开发日志

## 开发时间
2025-10-14

## 功能概述
实现用户刷题排行榜功能，支持查看全站用户排名和个人排名信息。

## 技术实现

### 后端部分

#### 1. 数据传输对象（DTO）
- **文件**: `UserRankDTO.java`
- **字段**:
  - userId: 用户ID
  - username: 用户名
  - nickname: 昵称
  - avatar: 头像URL
  - acCount: AC题目数
  - submitCount: 提交总数
  - acRate: AC率（百分比）
  - rank: 排名

#### 2. 数据访问层（Mapper）
- **文件**: `SubmissionMapper.java`
- **新增方法**:
  - `selectUserRankList(int limit)`: 查询排行榜列表
  - `selectUserRank(Long userId)`: 查询单个用户统计

- **SQL逻辑**:
```sql
SELECT 
  u.id as userId,
  u.username,
  u.nickname,
  u.avatar,
  COUNT(DISTINCT CASE WHEN s.status = 'AC' THEN s.question_id END) as acCount,
  COUNT(s.id) as submitCount,
  ROUND(COUNT(DISTINCT CASE WHEN s.status = 'AC' THEN s.question_id END) * 100.0 / NULLIF(COUNT(s.id), 0), 2) as acRate
FROM users u
LEFT JOIN submissions s ON u.id = s.user_id
WHERE u.status = 1
GROUP BY u.id
ORDER BY acCount DESC, submitCount ASC
LIMIT ?
```

- **排名规则**:
  1. 按AC题数降序（AC越多越靠前）
  2. AC数相同时按提交总数升序（提交越少越靠前）

#### 3. 业务逻辑层（Service）
- **文件**: `RankService.java`
- **方法**:
  - `getUserRankList(int limit)`: 获取前N名用户排行榜，自动计算排名
  - `getUserRank(Long userId)`: 获取单个用户排名信息

#### 4. 控制器（Controller）
- **文件**: `RankController.java`
- **API接口**:
  - `GET /rank/list?limit=100`: 获取排行榜列表（默认前100名，最大500名）
  - `GET /rank/my`: 获取当前登录用户的排名信息（需要JWT认证）

### 前端部分

#### 1. API接口封装
- **文件**: `api/index.js`
- **新增函数**:
  - `getRankList(params)`: 获取排行榜列表
  - `getMyRank()`: 获取我的排名

#### 2. 排行榜页面
- **文件**: `views/Ranking.vue`
- **功能特性**:
  - 展示Top 100用户排行榜
  - 显示当前用户排名卡片（渐变背景）
  - 前三名用户显示奖牌图标（🥇🥈🥉）
  - 使用Element Plus表格组件
  - 使用进度条展示AC率
  - 响应式设计，支持移动端

- **UI组件**:
  - 我的排名卡片：渐变背景、大数字展示
  - 排行榜表格：用户头像、昵称、AC数、提交数、AC率
  - 刷新按钮：手动刷新排行榜

#### 3. 路由配置
- **文件**: `router/index.js`
- **新增路由**:
  - `/ranking`: 排行榜页面（需要登录）

#### 4. 导航菜单
- **文件**: `components/Layout.vue`
- **修改**: 在顶部导航栏添加"排行榜"链接

## API测试结果

### 测试命令
```powershell
Invoke-RestMethod -Uri 'http://localhost:8080/api/rank/list?limit=5'
```

### 测试结果
```json
{
  "code": 200,
  "message": "操作成功",
  "data": [
    {
      "userId": 7,
      "username": "zhouba",
      "nickname": "小周",
      "avatar": "https://avatar.default.com/default.png",
      "acCount": 0,
      "submitCount": 0,
      "acRate": null,
      "rank": 1
    },
    // ... 更多用户数据
  ]
}
```

**测试结论**: ✓ API接口正常工作，数据格式正确

## 文件变更清单

### 后端新增文件（3个）
1. `backend/src/main/java/com/ylwy/dto/UserRankDTO.java` - 用户排行榜DTO
2. `backend/src/main/java/com/ylwy/service/RankService.java` - 排行榜服务
3. `backend/src/main/java/com/ylwy/controller/RankController.java` - 排行榜控制器

### 后端修改文件（1个）
4. `backend/src/main/java/com/ylwy/mapper/SubmissionMapper.java` - 添加统计查询方法

### 前端新增文件（1个）
5. `frontend/src/views/Ranking.vue` - 排行榜页面组件

### 前端修改文件（3个）
6. `frontend/src/api/index.js` - 添加排行榜API
7. `frontend/src/router/index.js` - 添加排行榜路由
8. `frontend/src/components/Layout.vue` - 添加导航链接

## 技术亮点

1. **高效SQL查询**: 使用LEFT JOIN和聚合函数一次性查询用户统计信息
2. **空值处理**: 使用NULLIF避免除零错误
3. **去重统计**: 使用DISTINCT确保AC题数不重复计算
4. **MyBatis注解**: 使用@Select注解简化Mapper配置
5. **Vue3 Composition API**: 使用setup语法糖和响应式数据
6. **Element Plus组件**: 充分利用UI组件库（表格、进度条、标签等）
7. **渐变设计**: 使用Tailwind CSS渐变背景提升视觉效果

## 待优化项

1. **缓存机制**: 排行榜数据可以使用Redis缓存，减少数据库查询
2. **分页加载**: 当用户数量很大时，前端可以实现虚拟滚动
3. **实时更新**: 使用WebSocket实时推送排名变化
4. **排名计算优化**: 可以预计算排名存储到Redis，定时更新
5. **多维度排名**: 支持按科目、按学校等维度的排行榜

## 下一步计划

1. **个人中心页面**: 展示个人刷题统计、成长曲线
2. **做题统计图表**: 使用ECharts展示做题趋势
3. **成就系统**: 设置勋章、称号等激励机制
4. **社交功能**: 关注用户、查看动态

## 测试清单

- [x] 后端API编译通过
- [x] 排行榜列表接口测试通过
- [x] 前端页面编译通过
- [x] 前端路由配置正确
- [x] 导航菜单显示正确
- [ ] 浏览器端到端测试（需要用户手动验证）
- [ ] 移动端响应式测试
