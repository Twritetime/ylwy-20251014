# UI/UX 优化计划

## 📋 项目概览

**优化目标**：提升用户体验，实现暗色模式、轻微动画效果和响应式优化

**开始时间**：2025-10-15  
**预计完成**：Day 2（2天）

---

## 🎯 Day 1 核心任务

### 1. 暗色模式支持 ✅

**技术方案**：
- Tailwind CSS `dark:` 类名系统
- localStorage 持久化用户偏好
- 系统偏好检测 (`prefers-color-scheme`)
- Element Plus 暗色主题适配

**实现文件**：
- `frontend/src/composables/useDarkMode.js` - 暗色模式组合式函数
- `frontend/src/stores/theme.js` - 主题状态管理
- `frontend/tailwind.config.js` - 启用 darkMode: 'class'
- `frontend/src/style.css` - 暗色变量定义

**配色方案**：
```css
/* 浅色模式 */
--bg-primary: #ffffff
--bg-secondary: #f9fafb
--text-primary: #1f2937
--text-secondary: #6b7280

/* 暗色模式 */
--bg-primary: #1f2937
--bg-secondary: #111827
--text-primary: #f9fafb
--text-secondary: #d1d5db
```

---

### 2. 轻微动画效果 ✅

**设计原则**：subtle（轻微），符合用户偏好

**动画清单**：

#### 页面切换动画
- 淡入淡出：200ms
- 缓动函数：ease-in-out

#### 卡片/按钮交互
- 悬停上浮：2px
- 阴影变化：subtle
- 过渡时间：150ms

#### 列表加载
- 交错淡入：stagger 50ms
- 从下到上：translateY(10px) → 0

#### 图表动画
- 初始化延迟：300ms
- 数据更新：800ms smooth

**CSS 配置**：
```css
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease-in-out;
}

.card-hover {
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}

.card-hover:hover {
  transform: translateY(-2px);
}
```

---

### 3. 响应式优化 ✅

**断点设计**：
- `sm`: 640px（手机横屏）
- `md`: 768px（平板）
- `lg`: 1024px（桌面）
- `xl`: 1280px（大屏）

**优化策略**：
- Mobile First 设计
- 触摸友好按钮（最小 44px）
- 移动端侧边栏抽屉
- 表格响应式（横向滚动）

**布局调整**：
```html
<!-- 桌面：2列，移动：1列 -->
<div class="grid grid-cols-1 md:grid-cols-2 gap-6">

<!-- 桌面：显示，移动：隐藏 -->
<div class="hidden md:block">

<!-- 移动：显示，桌面：隐藏 -->
<div class="block md:hidden">
```

---

## 📁 文件变更清单

### 新增文件（3个）

1. **frontend/src/composables/useDarkMode.js**
   - 暗色模式组合式函数
   - 约 50 行

2. **frontend/src/stores/theme.js**
   - Pinia 主题状态管理
   - 约 45 行

3. **UI_UX_OPTIMIZATION_PLAN.md**
   - 本文档
   - 约 300 行

---

### 修改文件（7个）

#### 1. frontend/tailwind.config.js
**变更内容**：
- 启用 `darkMode: 'class'`
- 添加自定义动画配置
- 扩展颜色主题

**关键代码**：
```javascript
export default {
  darkMode: 'class',
  theme: {
    extend: {
      animation: {
        'fade-in': 'fadeIn 0.2s ease-in-out',
        'slide-up': 'slideUp 0.3s ease-out',
      },
    },
  },
}
```

---

#### 2. frontend/src/style.css
**变更内容**：
- 清理冲突的默认样式
- 添加 CSS 变量（浅色/暗色）
- 添加动画关键帧
- 优化全局字体

**关键样式**：
```css
:root {
  --bg-primary: #ffffff;
  --text-primary: #1f2937;
}

.dark {
  --bg-primary: #1f2937;
  --text-primary: #f9fafb;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
```

---

#### 3. frontend/src/components/Layout.vue
**变更内容**：
- 添加暗色模式切换按钮（顶部导航栏）
- 应用暗色样式类
- 移动端汉堡菜单
- 响应式导航

**新增功能**：
```vue
<el-button 
  @click="themeStore.toggleTheme" 
  circle
  :icon="isDark ? Moon : Sunny"
/>
```

---

#### 4. frontend/src/views/Profile.vue
**变更内容**：
- 适配暗色模式样式
- 图表主题切换
- 响应式布局调整

**示例**：
```vue
<div class="bg-white dark:bg-gray-800">
  <h2 class="text-gray-800 dark:text-gray-100">
```

---

#### 5. frontend/src/views/QuestionList.vue
**变更内容**：
- 添加暗色模式样式
- 卡片悬停动画
- 响应式表格

---

#### 6. frontend/src/views/Ranking.vue
**变更内容**：
- 暗色模式适配
- 渐变背景暗色版本
- 列表交错动画

---

#### 7. frontend/src/main.js
**变更内容**：
- 导入 theme store
- 应用初始化主题

**新增代码**：
```javascript
import { useThemeStore } from '@/stores/theme'

const themeStore = useThemeStore()
themeStore.initTheme()
```

---

## 🎨 设计规范

### 颜色系统

**主色调**：蓝色系（用户偏好）
```css
--primary: #3b82f6
--primary-dark: #2563eb
```

**语义颜色**：
- Success: #10b981
- Warning: #f59e0b
- Danger: #ef4444
- Info: #6b7280

---

### 间距规范

**Tailwind Spacing**：
- `p-2`: 8px
- `p-4`: 16px
- `p-6`: 24px
- `p-8`: 32px

---

### 圆角规范

- 按钮：`rounded-lg` (8px)
- 卡片：`rounded-xl` (12px)
- 头像：`rounded-full`

---

## 📊 代码统计

| 文件类型 | 新增文件 | 修改文件 | 代码行数 |
|---------|---------|---------|---------|
| JS/TS   | 2       | 1       | ~120    |
| Vue     | 0       | 4       | ~300    |
| CSS     | 0       | 1       | ~100    |
| Config  | 0       | 1       | ~20     |
| 文档    | 1       | 0       | ~300    |
| **总计** | **3**   | **7**   | **~840** |

---

## ✅ Day 1 验收标准

### 功能测试

1. **暗色模式切换**
   - [ ] 点击切换按钮正常工作
   - [ ] 刷新页面保持主题
   - [ ] 所有页面样式正确

2. **动画效果**
   - [ ] 页面切换流畅
   - [ ] 卡片悬停自然
   - [ ] 列表加载优雅

3. **响应式布局**
   - [ ] 移动端（375px）正常
   - [ ] 平板端（768px）正常
   - [ ] 桌面端（1920px）正常

---

## 🚀 Day 2 计划

### 1. 性能优化
- 路由懒加载
- 组件按需引入
- 图片懒加载
- 代码分割

### 2. 交互优化
- 骨架屏加载
- 加载状态优化
- 错误提示优化
- 空状态设计

### 3. 无障碍优化
- 键盘导航
- ARIA 标签
- 对比度检查
- 屏幕阅读器支持

---

## 📝 备注

- 所有动画遵循 `subtle` 原则
- 主色调使用蓝色系（替代蓝紫色渐变）
- Element Plus 组件自动适配暗色主题
- 图表（ECharts）需手动切换主题

---

## 🔗 相关文档

- [Tailwind CSS Dark Mode](https://tailwindcss.com/docs/dark-mode)
- [Element Plus Theme](https://element-plus.org/zh-CN/guide/dark-mode.html)
- [Vue 3 Composition API](https://vuejs.org/api/composition-api-setup.html)
