<template>
  <div class="ranking-container">
    <!-- 页面标题 -->
    <div class="page-header animate-fade-in">
      <h1 class="text-3xl font-bold text-gray-800 dark:text-gray-100">排行榜</h1>
      <p class="text-gray-500 dark:text-gray-400 mt-2">查看用户刷题排名</p>
    </div>

    <!-- 我的排名卡片 -->
    <el-card class="my-rank-card card-hover" v-if="myRank" shadow="hover">
      <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-6">
        <div class="flex items-center gap-4">
          <div class="rank-badge">
            <span class="text-2xl font-bold">{{ myRank.rank }}</span>
          </div>
          <el-avatar :size="50" :src="myRank.avatar || '/default-avatar.png'" />
          <div>
            <div class="text-lg font-semibold">{{ myRank.nickname || myRank.username }}</div>
            <div class="text-sm opacity-80">@{{ myRank.username }}</div>
          </div>
        </div>
        <div class="flex gap-4 md:gap-8 justify-around md:justify-start">
          <div class="text-center">
            <div class="text-2xl font-bold text-green-400">{{ myRank.acCount }}</div>
            <div class="text-sm opacity-80">AC题数</div>
          </div>
          <div class="text-center">
            <div class="text-2xl font-bold text-blue-400">{{ myRank.submitCount }}</div>
            <div class="text-sm opacity-80">提交数</div>
          </div>
          <div class="text-center">
            <div class="text-2xl font-bold text-purple-400">{{ myRank.acRate || 0 }}%</div>
            <div class="text-sm opacity-80">AC率</div>
          </div>
        </div>
      </div>
    </el-card>

    <!-- 排行榜列表 -->
    <el-card class="rank-list-card dark:bg-gray-800 dark:border-gray-700" shadow="never">
      <template #header>
        <div class="flex items-center justify-between">
          <span class="font-semibold text-gray-800 dark:text-gray-100">Top 100 排行榜</span>
          <el-button @click="loadRankList" :loading="loading" size="small" type="primary" plain class="btn-transition">
            <el-icon><Refresh /></el-icon>
            刷新
          </el-button>
        </div>
      </template>

      <el-table 
        :data="rankList" 
        v-loading="loading"
        stripe
        class="dark-table"
        :header-cell-style="{ background: '#f5f7fa' }">
        
        <el-table-column label="排名" width="80" align="center">
          <template #default="{ row }">
            <div class="rank-number" :class="getRankClass(row.rank)">
              <span v-if="row.rank <= 3" class="rank-icon">
                {{ row.rank === 1 ? '🥇' : row.rank === 2 ? '🥈' : '🥉' }}
              </span>
              <span v-else class="font-semibold">{{ row.rank }}</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="用户" min-width="200">
          <template #default="{ row }">
            <div class="flex items-center gap-3">
              <el-avatar :size="40" :src="row.avatar || '/default-avatar.png'" />
              <div>
                <div class="font-semibold text-gray-800 dark:text-gray-100">{{ row.nickname || row.username }}</div>
                <div class="text-xs text-gray-500 dark:text-gray-400">@{{ row.username }}</div>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="AC题数" width="120" align="center">
          <template #default="{ row }">
            <el-tag type="success" size="large">{{ row.acCount }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column label="提交数" width="120" align="center">
          <template #default="{ row }">
            <el-tag type="info" size="large">{{ row.submitCount }}</el-tag>
          </template>
        </el-table-column>

        <el-table-column label="AC率" width="150" align="center">
          <template #default="{ row }">
            <div class="text-sm">
              <el-progress 
                :percentage="parseFloat(row.acRate || 0)" 
                :color="getProgressColor(row.acRate)"
                :stroke-width="8"
                :show-text="true"
                :format="() => `${row.acRate || 0}%`"
              />
            </div>
          </template>
        </el-table-column>

      </el-table>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { getRankList, getMyRank } from '@/api/index'
import { ElMessage } from 'element-plus'
import { Refresh } from '@element-plus/icons-vue'

const rankList = ref([])
const myRank = ref(null)
const loading = ref(false)

// 加载排行榜列表
const loadRankList = async () => {
  try {
    loading.value = true
    const res = await getRankList({ limit: 100 })
    if (res.code === 200) {
      rankList.value = res.data
    }
  } catch (error) {
    console.error('获取排行榜失败:', error)
    ElMessage.error('获取排行榜失败')
  } finally {
    loading.value = false
  }
}

// 加载我的排名
const loadMyRank = async () => {
  try {
    const res = await getMyRank()
    if (res.code === 200) {
      myRank.value = res.data
    }
  } catch (error) {
    console.error('获取我的排名失败:', error)
  }
}

// 获取排名样式
const getRankClass = (rank) => {
  if (rank === 1) return 'rank-gold'
  if (rank === 2) return 'rank-silver'
  if (rank === 3) return 'rank-bronze'
  return ''
}

// 获取进度条颜色
const getProgressColor = (rate) => {
  const value = parseFloat(rate || 0)
  if (value >= 80) return '#67c23a'
  if (value >= 60) return '#409eff'
  if (value >= 40) return '#e6a23c'
  return '#f56c6c'
}

onMounted(() => {
  loadRankList()
  loadMyRank()
})
</script>

<style scoped>
.ranking-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  min-height: 100vh;
  background-color: var(--bg-secondary);
}

.page-header {
  margin-bottom: 24px;
}

.my-rank-card {
  margin-bottom: 24px;
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  color: white;
  transition: all 0.15s ease;
}

.dark .my-rank-card {
  background: linear-gradient(135deg, #1e40af 0%, #1e3a8a 100%);
}

.my-rank-card :deep(.el-card__body) {
  padding: 24px;
}

.rank-badge {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  backdrop-filter: blur(10px);
}

.rank-list-card {
  margin-top: 20px;
  transition: all 0.15s ease;
}

.rank-number {
  font-size: 18px;
}

.rank-icon {
  font-size: 24px;
}

.rank-gold {
  color: #ffd700;
}

.rank-silver {
  color: #c0c0c0;
}

.rank-bronze {
  color: #cd7f32;
}

/* 移动端优化 */
@media (max-width: 768px) {
  .ranking-container {
    padding: 12px;
  }
  
  .my-rank-card :deep(.el-card__body) {
    padding: 16px;
  }
  
  .rank-badge {
    width: 50px;
    height: 50px;
  }
}
</style>
