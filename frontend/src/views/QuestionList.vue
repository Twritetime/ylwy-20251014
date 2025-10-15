<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900 transition-colors">
    <div class="container mx-auto px-4 py-8">
      <!-- 页面标题 -->
      <div class="mb-6 animate-fade-in">
        <h1 class="text-3xl font-bold text-gray-800 dark:text-gray-100">题库</h1>
        <p class="text-gray-600 dark:text-gray-400 mt-2">选择题目开始刷题，提升编程能力</p>
      </div>

      <!-- 筛选区 -->
      <AnimatedCard class="mb-6 card-hover dark:bg-gray-800 dark:border-gray-700" shadow="never">
        <el-form :inline="true" :model="filterForm" class="filter-form p-4">
          <div class="flex flex-col md:flex-row md:items-end gap-4">
            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">题目类型</label>
              <el-select
                v-model="filterForm.type"
                placeholder="全部类型"
                clearable
                @change="handleFilter"
                class="w-full md:w-32"
              >
                <el-option label="选择题" value="CHOICE" />
                <el-option label="编程题" value="CODE" />
              </el-select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">难度</label>
              <el-select
                v-model="filterForm.difficulty"
                placeholder="全部难度"
                clearable
                @change="handleFilter"
                class="w-full md:w-32"
              >
                <el-option label="简单" value="EASY" />
                <el-option label="中等" value="MEDIUM" />
                <el-option label="困难" value="HARD" />
              </el-select>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">科目</label>
              <el-select
                v-model="filterForm.subjectId"
                placeholder="全部科目"
                clearable
                @change="handleFilter"
                class="w-full md:w-40"
              >
                <el-option
                  v-for="subject in subjects"
                  :key="subject.id"
                  :label="subject.name"
                  :value="subject.id"
                />
              </el-select>
            </div>

            <div class="mt-6 md:mt-0">
              <GradientButton @click="handleFilter" size="default">
                <el-icon><Search /></el-icon>
                <span class="ml-1">搜索</span>
              </GradientButton>
            </div>
          </div>
        </el-form>
      </AnimatedCard>

      <!-- 题目列表 -->
      <div v-loading="loading" class="space-y-4">
        <AnimatedCard
          v-for="(question, index) in questionList"
          :key="question.id"
          class="question-card cursor-pointer dark:bg-gray-800 dark:border-gray-700 stagger-item"
          :style="{ animationDelay: `${index * 50}ms` }"
          @click="goToDetail(question.id)"
        >
          <div class="p-6">
            <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
              <div class="flex-1">
                <div class="flex items-center flex-wrap gap-3 mb-3">
                  <!-- 题目编号 -->
                  <el-tag 
                    type="info" 
                    size="small" 
                    class="beautiful-tag"
                  >
                    {{ question.questionNo }}
                  </el-tag>
                  
                  <!-- 题目类型标签 -->
                  <el-tag
                    :type="question.type === 'CODE' ? 'primary' : 'success'"
                    size="small"
                    class="beautiful-tag"
                  >
                    {{ question.type === 'CODE' ? '编程题' : '选择题' }}
                  </el-tag>

                  <!-- 难度标签 -->
                  <el-tag
                    :type="getDifficultyType(question.difficulty)"
                    size="small"
                    class="beautiful-tag"
                  >
                    {{ getDifficultyText(question.difficulty) }}
                  </el-tag>

                  <!-- 科目 -->
                  <span class="text-sm text-gray-500 dark:text-gray-400 flex items-center gap-1">
                    <el-icon><Collection /></el-icon>
                    {{ question.subjectName }}
                  </span>
                </div>

                <!-- 题目标题 -->
                <h3 class="text-lg font-semibold text-gray-800 dark:text-gray-100 mb-3">
                  {{ question.title }}
                </h3>

                <!-- 统计信息 -->
                <div class="flex items-center flex-wrap gap-4 text-sm text-gray-500 dark:text-gray-400">
                  <span class="flex items-center gap-1">
                    <el-icon><Check /></el-icon>
                    AC率: {{ calculateAcceptRate(question) }}
                  </span>
                  <span class="flex items-center gap-1">
                    <el-icon><Document /></el-icon>
                    提交: {{ question.submitCount || 0 }}
                  </span>
                  <span class="flex items-center gap-1">
                    <el-icon><User /></el-icon>
                    通过: {{ question.acceptedCount || 0 }}
                  </span>
                </div>
              </div>

              <!-- 操作按钮 -->
              <div class="md:ml-4 mt-4 md:mt-0">
                <GradientButton 
                  size="small" 
                  @click.stop="goToDetail(question.id)"
                  class="w-full md:w-auto"
                >
                  开始答题
                </GradientButton>
              </div>
            </div>
          </div>
        </AnimatedCard>

        <!-- 空状态 -->
        <el-empty
          v-if="!loading && questionList.length === 0"
          description="暂无题目"
          class="dark:text-gray-400"
        />
      </div>

      <!-- 分页 -->
      <div class="mt-8 flex justify-center">
        <el-pagination
          v-model:current-page="pagination.current"
          v-model:page-size="pagination.size"
          :total="pagination.total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next, jumper"
          background
          @current-change="fetchQuestions"
          @size-change="fetchQuestions"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Check, Document, User, Search, Collection } from '@element-plus/icons-vue'
import { getQuestionList, getSubjectList } from '@/api'
import AnimatedCard from '@/components/AnimatedCard.vue'
import GradientButton from '@/components/GradientButton.vue'

const router = useRouter()

const loading = ref(false)
const questionList = ref([])
const subjects = ref([])

const filterForm = reactive({
  type: '',
  difficulty: '',
  subjectId: null
})

const pagination = reactive({
  current: 1,
  size: 10,
  total: 0
})

// 获取题目列表
const fetchQuestions = async () => {
  try {
    loading.value = true
    const params = {
      current: pagination.current,
      size: pagination.size,
      ...filterForm
    }
    
    const res = await getQuestionList(params)
    questionList.value = res.data.records || []
    pagination.total = res.data.total || 0
  } catch (error) {
    console.error('获取题目列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 获取科目列表
const fetchSubjects = async () => {
  try {
    const res = await getSubjectList()
    subjects.value = res.data || []
  } catch (error) {
    console.error('获取科目列表失败:', error)
  }
}

// 筛选
const handleFilter = () => {
  pagination.current = 1
  fetchQuestions()
}

// 跳转到题目详情
const goToDetail = (id) => {
  router.push(`/questions/${id}`)
}

// 获取难度类型
const getDifficultyType = (difficulty) => {
  const map = {
    EASY: 'success',
    MEDIUM: 'warning',
    HARD: 'danger'
  }
  return map[difficulty] || 'info'
}

// 获取难度文本
const getDifficultyText = (difficulty) => {
  const map = {
    EASY: '简单',
    MEDIUM: '中等',
    HARD: '困难'
  }
  return map[difficulty] || '未知'
}

// 计算AC率
const calculateAcceptRate = (question) => {
  if (!question.submitCount || question.submitCount === 0) {
    return '0%'
  }
  const rate = ((question.acceptedCount || 0) / question.submitCount * 100).toFixed(1)
  return `${rate}%`
}

onMounted(() => {
  fetchSubjects()
  fetchQuestions()
})
</script>

<style scoped>
.question-card {
  transition: all 0.15s ease;
}

.question-card:hover {
  transform: translateY(-2px);
}

.filter-form :deep(.el-form-item) {
  margin-bottom: 0;
}

/* 移动端优化 */
@media (max-width: 768px) {
  .filter-form {
    display: flex;
    flex-direction: column;
  }
  
  .filter-form :deep(.el-form-item) {
    width: 100%;
    margin-bottom: 12px;
  }
}
</style>
