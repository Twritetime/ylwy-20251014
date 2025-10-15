<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <div class="container mx-auto px-4 py-8">
      <!-- 页面标题 -->
      <div class="mb-6">
        <h1 class="text-3xl font-bold text-gray-800 dark:text-gray-100">院校信息</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-2">查看各大院校考研信息</p>
      </div>

      <!-- 搜索栏 -->
      <AnimatedCard class="mb-6" shadow="never">
        <div class="p-4">
          <el-form :inline="true">
            <div class="flex flex-col md:flex-row md:items-end gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">院校名称</label>
                <el-input
                  v-model="searchKeyword"
                  placeholder="请输入院校名称"
                  clearable
                  style="width: 300px"
                  class="beautiful-input"
                  @keyup.enter="handleSearch"
                >
                  <template #append>
                    <GradientButton :icon="Search" @click="handleSearch" />
                  </template>
                </el-input>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">院校类型</label>
                <el-select
                  v-model="filterType"
                  placeholder="全部类型"
                  clearable
                  @change="handleSearch"
                  class="w-full md:w-32"
                >
                  <el-option label="985院校" value="985" />
                  <el-option label="211院校" value="211" />
                  <el-option label="双一流" value="双一流" />
                </el-select>
              </div>

              <div class="mt-6 md:mt-0">
                <GradientButton @click="handleSearch">
                  <el-icon><Search /></el-icon>
                  <span class="ml-1">搜索</span>
                </GradientButton>
              </div>
            </div>
          </el-form>
        </div>
      </AnimatedCard>

      <!-- 院校列表 -->
      <div v-loading="loading" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <AnimatedCard
          v-for="school in schoolList"
          :key="school.id"
          class="school-card text-center"
          clickable
          @click="viewDetail(school.id)"
        >
          <div class="p-6">
            <!-- 院校Logo -->
            <div class="mb-4">
              <el-avatar
                :size="80"
                :src="school.logo || '/default-school.png'"
                class="mx-auto"
              >
                {{ school.name?.charAt(0) }}
              </el-avatar>
            </div>

            <!-- 院校名称 -->
            <h3 class="text-xl font-bold text-gray-800 dark:text-gray-100 mb-3">
              {{ school.name }}
            </h3>

            <!-- 标签 -->
            <div class="flex justify-center gap-2 mb-4 flex-wrap">
              <el-tag v-if="school.is985" type="danger" size="small" class="beautiful-tag">
                985
              </el-tag>
              <el-tag v-if="school.is211" type="warning" size="small" class="beautiful-tag">
                211
              </el-tag>
              <el-tag v-if="school.isDoubleFirstClass" type="success" size="small" class="beautiful-tag">
                双一流
              </el-tag>
            </div>

            <!-- 院校信息 -->
            <div class="text-sm text-gray-600 dark:text-gray-400 space-y-2">
              <div v-if="school.province" class="flex items-center justify-center gap-1">
                <el-icon><Location /></el-icon>
                {{ school.province }} {{ school.city }}
              </div>
              <div v-if="school.type" class="flex items-center justify-center gap-1">
                <el-icon><School /></el-icon>
                {{ school.type }}
              </div>
              <div v-if="school.ranking" class="flex items-center justify-center gap-1">
                <el-icon><Trophy /></el-icon>
                排名: 第 {{ school.ranking }} 名
              </div>
            </div>

            <!-- 操作按钮 -->
            <div class="mt-6">
              <GradientButton size="small" @click.stop="viewDetail(school.id)">
                查看详情
              </GradientButton>
            </div>
          </div>
        </AnimatedCard>

        <!-- 空状态 -->
        <div v-if="!loading && schoolList.length === 0" class="col-span-full">
          <el-empty description="暂无院校信息" />
        </div>
      </div>

      <!-- 分页 -->
      <div class="mt-8 flex justify-center">
        <el-pagination
          v-model:current-page="pagination.current"
          v-model:page-size="pagination.size"
          :total="pagination.total"
          :page-sizes="[12, 24, 48]"
          layout="total, sizes, prev, pager, next, jumper"
          background
          @current-change="fetchSchools"
          @size-change="fetchSchools"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Search, Location, School, Trophy } from '@element-plus/icons-vue'
import { getSchoolList } from '@/api'
import AnimatedCard from '@/components/AnimatedCard.vue'
import GradientButton from '@/components/GradientButton.vue'

const router = useRouter()

const loading = ref(false)
const schoolList = ref([])
const searchKeyword = ref('')
const filterType = ref('')

const pagination = reactive({
  current: 1,
  size: 12,
  total: 0
})

// 获取院校列表
const fetchSchools = async () => {
  try {
    loading.value = true
    const params = {
      current: pagination.current,
      size: pagination.size,
      keyword: searchKeyword.value,
      type: filterType.value
    }
    
    const res = await getSchoolList(params)
    schoolList.value = res.data.records || []
    pagination.total = res.data.total || 0
  } catch (error) {
    console.error('获取院校列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  pagination.current = 1
  fetchSchools()
}

// 查看详情
const viewDetail = (id) => {
  // 这里可以跳转到院校详情页，暂时使用 ElMessage 提示
  ElMessage.info(`查看院校 ID: ${id} 的详情`)
}

onMounted(() => {
  fetchSchools()
})
</script>

<style scoped>
.school-card {
  transition: all 0.3s ease;
}

.school-card:hover {
  transform: translateY(-4px);
}
</style>
