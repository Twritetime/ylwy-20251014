<template>
  <div class="min-h-screen bg-gray-50">
    <div class="container mx-auto px-4 py-8">
      <!-- 页面标题 -->
      <div class="mb-6">
        <h1 class="text-3xl font-bold text-gray-800">院校信息</h1>
        <p class="text-gray-600 mt-2">查看各大院校考研信息</p>
      </div>

      <!-- 搜索栏 -->
      <el-card class="mb-6" shadow="never">
        <el-form :inline="true">
          <el-form-item label="院校名称">
            <el-input
              v-model="searchKeyword"
              placeholder="请输入院校名称"
              clearable
              style="width: 300px"
              @keyup.enter="handleSearch"
            >
              <template #append>
                <el-button :icon="Search" @click="handleSearch" />
              </template>
            </el-input>
          </el-form-item>

          <el-form-item label="院校类型">
            <el-select
              v-model="filterType"
              placeholder="全部类型"
              clearable
              @change="handleSearch"
            >
              <el-option label="985院校" value="985" />
              <el-option label="211院校" value="211" />
              <el-option label="双一流" value="双一流" />
            </el-select>
          </el-form-item>
        </el-form>
      </el-card>

      <!-- 院校列表 -->
      <div v-loading="loading" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <el-card
          v-for="school in schoolList"
          :key="school.id"
          class="school-card hover:shadow-lg transition-shadow"
          shadow="hover"
        >
          <div class="text-center">
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
            <h3 class="text-xl font-bold text-gray-800 mb-2">
              {{ school.name }}
            </h3>

            <!-- 标签 -->
            <div class="flex justify-center gap-2 mb-4">
              <el-tag v-if="school.is985" type="danger" size="small">985</el-tag>
              <el-tag v-if="school.is211" type="warning" size="small">211</el-tag>
              <el-tag v-if="school.isDoubleFirstClass" type="success" size="small">
                双一流
              </el-tag>
            </div>

            <!-- 院校信息 -->
            <div class="text-sm text-gray-600 space-y-2">
              <div v-if="school.province">
                <el-icon><Location /></el-icon>
                {{ school.province }} {{ school.city }}
              </div>
              <div v-if="school.type">
                <el-icon><School /></el-icon>
                {{ school.type }}
              </div>
              <div v-if="school.ranking">
                <el-icon><Trophy /></el-icon>
                排名: 第 {{ school.ranking }} 名
              </div>
            </div>

            <!-- 操作按钮 -->
            <div class="mt-4">
              <el-button type="primary" size="small" @click="viewDetail(school.id)">
                查看详情
              </el-button>
            </div>
          </div>
        </el-card>

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
import { Search, Location, School, Trophy } from '@element-plus/icons-vue'
import { getSchoolList } from '@/api'

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
