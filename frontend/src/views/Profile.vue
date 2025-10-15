<template>
  <Layout>
    <div class="profile max-w-7xl mx-auto px-4 py-6 min-h-screen transition-colors duration-300">
      <h1 class="text-3xl font-bold mb-6 text-gray-800 dark:text-gray-100 animate-fade-in">个人中心</h1>
      
      <!-- 个人信息卡片 -->
      <AnimatedCard class="mb-5 dark:bg-gray-800 dark:border-gray-700 transition-all duration-300" animate>
        <template #header>
          <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <span class="text-lg font-semibold text-gray-800 dark:text-gray-100">个人信息</span>
            <div class="flex gap-2">
              <GradientButton size="small" @click="showEditDialog">编辑资料</GradientButton>
              <GradientButton size="small" type="warning" @click="passwordDialogVisible = true">修改密码</GradientButton>
            </div>
          </div>
        </template>
        
        <div v-if="loading" class="text-center py-8">
          <div class="loading-spinner mx-auto"></div>
        </div>
        
        <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-5 p-5">
          <!-- 左侧：头像和基本信息 -->
          <div class="flex flex-col sm:flex-row items-start space-y-4 sm:space-y-0 sm:space-x-5">
            <el-avatar :size="90" :src="profile.avatar || undefined" class="flex-shrink-0">
              {{ profile.username?.charAt(0).toUpperCase() }}
            </el-avatar>
            <div class="flex-1">
              <h2 class="text-2xl font-bold mb-2 text-gray-800 dark:text-gray-100">{{ profile.nickname || profile.username }}</h2>
              <p class="text-gray-600 dark:text-gray-400 mb-1">@{{ profile.username }}</p>
              <p class="text-gray-500 dark:text-gray-500 text-sm mb-3">{{ profile.signature || '这个人很懒，还没有签名~' }}</p>
              <p class="text-gray-400 dark:text-gray-600 text-sm">注册于 {{ formatDate(profile.createdAt) }}</p>
            </div>
          </div>
          
          <!-- 右侧：统计数据 -->
          <div class="grid grid-cols-2 gap-3">
            <div class="stat-card transition-all duration-300">
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">AC题目数</p>
              <p class="stat-number">{{ profile.totalAC || 0 }}</p>
            </div>
            <div class="stat-card transition-all duration-300">
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">总提交数</p>
              <p class="stat-number">{{ profile.totalSubmissions || 0 }}</p>
            </div>
            <div class="stat-card transition-all duration-300">
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">AC率</p>
              <p class="stat-number">{{ (profile.acRate || 0).toFixed(1) }}%</p>
            </div>
            <div class="stat-card transition-all duration-300">
              <p class="text-sm text-gray-600 dark:text-gray-400 mb-1">总得分</p>
              <p class="stat-number">{{ profile.totalScore || 0 }}</p>
            </div>
          </div>
        </div>
        
        <!-- 联系方式 -->
        <div class="px-5 pb-5">
          <div class="decorative-divider my-5"></div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
            <div>
              <span class="text-gray-500 dark:text-gray-400">邮箱：</span>
              <span class="text-gray-800 dark:text-gray-200">{{ profile.email || '未设置' }}</span>
            </div>
          </div>
        </div>
      </AnimatedCard>
      
      <!-- AC题目列表 -->
      <AnimatedCard class="mb-5 dark:bg-gray-800 dark:border-gray-700 transition-all duration-300" animate>
        <template #header>
          <span class="text-lg font-semibold text-gray-800 dark:text-gray-100">AC题目列表</span>
        </template>
        
        <div v-if="loadingStatistics" class="text-center py-8">
          <div class="loading-spinner mx-auto"></div>
        </div>
        
        <div v-else-if="statistics.acQuestions && statistics.acQuestions.length > 0" class="overflow-x-auto p-5">
          <el-table :data="statistics.acQuestions" stripe class="dark-table">
            <el-table-column prop="questionNo" label="编号" width="100" />
            <el-table-column prop="title" label="题目名称" />
            <el-table-column prop="difficulty" label="难度" width="100">
              <template #default="{row}">
                <el-tag :type="getDifficultyType(row.difficulty)" size="small" class="beautiful-tag">
                  {{ getDifficultyText(row.difficulty) }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="createdAt" label="AC时间" width="180">
              <template #default="{row}">
                {{ formatDateTime(row.createdAt) }}
              </template>
            </el-table-column>
          </el-table>
        </div>
        
        <el-empty v-else description="还没有AC的题目" class="dark:text-gray-400 p-5" />
      </AnimatedCard>
      
      <!-- 做题日历热力图 -->
      <AnimatedCard class="mb-5 dark:bg-gray-800 dark:border-gray-700 transition-all duration-300" animate>
        <template #header>
          <span class="text-lg font-semibold text-gray-800 dark:text-gray-100">做题日历</span>
        </template>
        <div ref="calendarChart" style="width: 100%; height: 200px;" class="p-5"></div>
      </AnimatedCard>
      
      <!-- 做题统计图表 -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
        <AnimatedCard class="dark:bg-gray-800 dark:border-gray-700 transition-all duration-300" animate>
          <template #header>
            <span class="text-lg font-semibold text-gray-800 dark:text-gray-100">科目统计</span>
          </template>
          <div ref="subjectChart" style="width: 100%; height: 300px;" class="p-5"></div>
        </AnimatedCard>
        
        <AnimatedCard class="dark:bg-gray-800 dark:border-gray-700 transition-all duration-300" animate>
          <template #header>
            <span class="text-lg font-semibold text-gray-800 dark:text-gray-100">刷题趋势（最近30天）</span>
          </template>
          <div ref="trendChart" style="width: 100%; height: 300px;" class="p-5"></div>
        </AnimatedCard>
      </div>
    </div>
    
    <!-- 编辑资料对话框 -->
    <el-dialog v-model="editDialogVisible" title="编辑资料" width="500px" class="dark:bg-gray-800">
      <el-form :model="editForm" label-width="80px">
        <el-form-item label="昵称">
          <el-input v-model="editForm.nickname" placeholder="请输入昵称" class="beautiful-input" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="editForm.email" placeholder="请输入邮箱" class="beautiful-input" />
        </el-form-item>
        <el-form-item label="个性签名">
          <el-input 
            v-model="editForm.signature" 
            type="textarea" 
            :rows="3"
            placeholder="请输入个性签名"
            class="beautiful-input"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editDialogVisible = false">取消</el-button>
        <GradientButton @click="handleUpdateProfile" :loading="updating">保存</GradientButton>
      </template>
    </el-dialog>
    
    <!-- 修改密码对话框 -->
    <el-dialog v-model="passwordDialogVisible" title="修改密码" width="500px" class="dark:bg-gray-800">
      <el-form :model="passwordForm" label-width="80px">
        <el-form-item label="旧密码">
          <el-input v-model="passwordForm.oldPassword" type="password" placeholder="请输入旧密码" class="beautiful-input" show-password />
        </el-form-item>
        <el-form-item label="新密码">
          <el-input v-model="passwordForm.newPassword" type="password" placeholder="请输入新密码" class="beautiful-input" show-password />
        </el-form-item>
        <el-form-item label="确认密码">
          <el-input v-model="passwordForm.confirmPassword" type="password" placeholder="请再次输入新密码" class="beautiful-input" show-password />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="passwordDialogVisible = false">取消</el-button>
        <GradientButton @click="handleUpdatePassword" :loading="updatingPassword">确定</GradientButton>
      </template>
    </el-dialog>
  </Layout>
</template>

<script setup>
import { ref, onMounted, nextTick, watch } from 'vue'
import { ElMessage } from 'element-plus'
import * as echarts from 'echarts'
import Layout from '@/components/Layout.vue'
import AnimatedCard from '@/components/AnimatedCard.vue'
import GradientButton from '@/components/GradientButton.vue'
import { getUserProfile, updateProfile, updatePassword, getUserStatistics } from '@/api'
import { useThemeStore } from '@/stores/theme'

// Store
const themeStore = useThemeStore()

// 数据
const loading = ref(true)
const loadingStatistics = ref(false)
const profile = ref({})
const statistics = ref({})
const editDialogVisible = ref(false)
const passwordDialogVisible = ref(false)
const updating = ref(false)
const updatingPassword = ref(false)

// ECharts实例
const calendarChart = ref(null)
const subjectChart = ref(null)
const trendChart = ref(null)
let calendarChartInstance = null
let subjectChartInstance = null
let trendChartInstance = null

const editForm = ref({
  nickname: '',
  email: '',
  signature: ''
})

const passwordForm = ref({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// 方法
const fetchProfile = async () => {
  try {
    loading.value = true
    const res = await getUserProfile()
    profile.value = res.data
  } catch (error) {
    console.error('获取个人信息失败:', error)
    ElMessage.error('获取个人信息失败')
  } finally {
    loading.value = false
  }
}

const fetchStatistics = async () => {
  try {
    loadingStatistics.value = true
    const res = await getUserStatistics()
    statistics.value = res.data
    
    // 等待DOM更新后初始化图表
    await nextTick()
    initCharts()
  } catch (error) {
    console.error('获取统计数据失败:', error)
    ElMessage.error('获取统计数据失败')
  } finally {
    loadingStatistics.value = false
  }
}

const initCharts = () => {
  initCalendarChart()
  initSubjectChart()
  initTrendChart()
}

// 初始化日历热力图
const initCalendarChart = () => {
  if (!calendarChart.value) return
  
  calendarChartInstance = echarts.init(calendarChart.value, themeStore.isDark ? 'dark' : 'light')
  
  const calendarData = statistics.value.calendarData || {}
  const data = Object.keys(calendarData).map(date => [date, calendarData[date]])
  
  const option = {
    tooltip: {
      position: 'top',
      formatter: (p) => `${p.data[0]}: ${p.data[1]}次提交`
    },
    visualMap: {
      min: 0,
      max: Math.max(...Object.values(calendarData), 1),
      calculable: true,
      orient: 'horizontal',
      left: 'center',
      top: 10,
      inRange: {
        color: ['#ebedf0', '#9be9a8', '#40c463', '#30a14e', '#216e39']
      },
      textStyle: {
        color: themeStore.isDark ? '#d1d5db' : '#6b7280'
      }
    },
    calendar: {
      top: 60,
      left: 30,
      right: 30,
      cellSize: ['auto', 13],
      range: getYearRange(),
      itemStyle: {
        borderWidth: 0.5,
        borderColor: themeStore.isDark ? '#374151' : '#e5e7eb'
      },
      yearLabel: { show: false },
      dayLabel: {
        firstDay: 1,
        nameMap: 'cn',
        color: themeStore.isDark ? '#9ca3af' : '#6b7280'
      },
      monthLabel: {
        nameMap: 'cn',
        color: themeStore.isDark ? '#9ca3af' : '#6b7280'
      }
    },
    series: {
      type: 'heatmap',
      coordinateSystem: 'calendar',
      data: data
    }
  }
  
  calendarChartInstance.setOption(option)
}

// 初始化科目统计饼图
const initSubjectChart = () => {
  if (!subjectChart.value) return
  
  subjectChartInstance = echarts.init(subjectChart.value, themeStore.isDark ? 'dark' : 'light')
  
  const subjectStats = statistics.value.subjectStats || []
  const data = subjectStats.map(item => ({
    name: item.subjectName,
    value: item.acCount
  }))
  
  const option = {
    tooltip: {
      trigger: 'item',
      formatter: '{b}: {c} ({d}%)'
    },
    legend: {
      orient: 'vertical',
      left: 'left',
      textStyle: {
        color: themeStore.isDark ? '#d1d5db' : '#374151'
      }
    },
    series: [
      {
        type: 'pie',
        radius: '50%',
        data: data,
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        },
        animationType: 'scale',
        animationEasing: 'elasticOut',
        animationDelay: () => Math.random() * 200
      }
    ]
  }
  
  subjectChartInstance.setOption(option)
}

// 初始化刷题趋势折线图
const initTrendChart = () => {
  if (!trendChart.value) return
  
  trendChartInstance = echarts.init(trendChart.value, themeStore.isDark ? 'dark' : 'light')
  
  const trendData = statistics.value.trendData || []
  const dates = trendData.map(item => item.date)
  const counts = trendData.map(item => item.acCount)
  
  const option = {
    tooltip: {
      trigger: 'axis'
    },
    xAxis: {
      type: 'category',
      data: dates,
      axisLabel: {
        rotate: 45,
        color: themeStore.isDark ? '#9ca3af' : '#6b7280'
      },
      axisLine: {
        lineStyle: {
          color: themeStore.isDark ? '#374151' : '#e5e7eb'
        }
      }
    },
    yAxis: {
      type: 'value',
      minInterval: 1,
      axisLabel: {
        color: themeStore.isDark ? '#9ca3af' : '#6b7280'
      },
      axisLine: {
        lineStyle: {
          color: themeStore.isDark ? '#374151' : '#e5e7eb'
        }
      },
      splitLine: {
        lineStyle: {
          color: themeStore.isDark ? '#374151' : '#e5e7eb'
        }
      }
    },
    series: [
      {
        data: counts,
        type: 'line',
        smooth: true,
        areaStyle: {
          opacity: 0.3
        },
        itemStyle: {
          color: '#3b82f6'
        },
        animationDuration: 800,
        animationEasing: 'cubicOut'
      }
    ]
  }
  
  trendChartInstance.setOption(option)
}

const getYearRange = () => {
  const end = new Date()
  const start = new Date()
  start.setFullYear(start.getFullYear() - 1)
  return [start.toISOString().split('T')[0], end.toISOString().split('T')[0]]
}

const getDifficultyType = (difficulty) => {
  const map = {
    'EASY': 'success',
    'MEDIUM': 'warning',
    'HARD': 'danger'
  }
  return map[difficulty] || 'info'
}

const getDifficultyText = (difficulty) => {
  const map = {
    'EASY': '简单',
    'MEDIUM': '中等',
    'HARD': '困难'
  }
  return map[difficulty] || difficulty
}

const showEditDialog = () => {
  editForm.value = {
    nickname: profile.value.nickname,
    email: profile.value.email,
    signature: profile.value.signature
  }
  editDialogVisible.value = true
}

const handleUpdateProfile = async () => {
  try {
    updating.value = true
    await updateProfile(editForm.value)
    ElMessage.success('更新成功')
    editDialogVisible.value = false
    await fetchProfile()
  } catch (error) {
    console.error('更新失败:', error)
    ElMessage.error('更新失败')
  } finally {
    updating.value = false
  }
}

const handleUpdatePassword = async () => {
  if (passwordForm.value.newPassword !== passwordForm.value.confirmPassword) {
    ElMessage.warning('两次输入的密码不一致')
    return
  }
  
  try {
    updatingPassword.value = true
    await updatePassword({
      oldPassword: passwordForm.value.oldPassword,
      newPassword: passwordForm.value.newPassword
    })
    ElMessage.success('密码修改成功')
    passwordDialogVisible.value = false
    passwordForm.value = {
      oldPassword: '',
      newPassword: '',
      confirmPassword: ''
    }
  } catch (error) {
    console.error('密码修改失败:', error)
    ElMessage.error(error.response?.data?.message || '密码修改失败')
  } finally {
    updatingPassword.value = false
  }
}

const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleDateString('zh-CN')
}

const formatDateTime = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// 生命周期
onMounted(() => {
  fetchProfile()
  fetchStatistics()
  
  // 窗口大小改变时重绘图表
  window.addEventListener('resize', () => {
    calendarChartInstance?.resize()
    subjectChartInstance?.resize()
    trendChartInstance?.resize()
  })
})

// 监听主题切换，重新初始化图表
watch(() => themeStore.isDark, () => {
  if (calendarChartInstance || subjectChartInstance || trendChartInstance) {
    // 销毁旧实例
    calendarChartInstance?.dispose()
    subjectChartInstance?.dispose()
    trendChartInstance?.dispose()
    
    // 重新初始化
    nextTick(() => {
      initCharts()
    })
  }
})
</script>

<style scoped>
.profile {
  min-height: 80vh;
}

.el-avatar {
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
}
</style>