<template>
  <div class="min-h-screen bg-gray-50">
    <div v-loading="loading" class="container mx-auto px-4 py-8">
      <template v-if="question">
        <!-- 返回按钮 -->
        <div class="mb-4">
          <el-button :icon="ArrowLeft" @click="router.back()">
            返回题库
          </el-button>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <!-- 左侧：题目信息 -->
          <div class="lg:col-span-2">
            <el-card shadow="never">
              <!-- 题目标题 -->
              <div class="mb-6">
                <div class="flex items-center gap-3 mb-3">
                  <el-tag
                    :type="question.type === 'CODE' ? 'primary' : 'success'"
                    size="large"
                  >
                    {{ question.type === 'CODE' ? '编程题' : '选择题' }}
                  </el-tag>
                  <el-tag
                    :type="getDifficultyType(question.difficulty)"
                    size="large"
                  >
                    {{ getDifficultyText(question.difficulty) }}
                  </el-tag>
                  <span class="text-gray-500">{{ question.subjectName }}</span>
                </div>
                <h1 class="text-2xl font-bold text-gray-800">
                  {{ question.title }}
                </h1>
              </div>

              <!-- 题目描述 -->
              <div class="prose max-w-none mb-6">
                <h3 class="text-lg font-semibold mb-2">题目描述</h3>
                <div class="text-gray-700 whitespace-pre-wrap">
                  {{ question.description }}
                </div>
              </div>

              <!-- 输入输出示例（编程题） -->
              <div v-if="question.type === 'CODE'" class="mb-6">
                <h3 class="text-lg font-semibold mb-2">输入输出示例</h3>
                <div class="bg-gray-50 p-4 rounded">
                  <div class="mb-3">
                    <div class="font-semibold text-sm text-gray-600 mb-1">输入示例：</div>
                    <pre class="bg-white p-2 rounded border">{{ question.inputExample }}</pre>
                  </div>
                  <div>
                    <div class="font-semibold text-sm text-gray-600 mb-1">输出示例：</div>
                    <pre class="bg-white p-2 rounded border">{{ question.outputExample }}</pre>
                  </div>
                </div>
              </div>

              <!-- 选项（选择题） -->
              <div v-if="question.type === 'CHOICE' && options.length > 0" class="mb-6">
                <h3 class="text-lg font-semibold mb-3">选项</h3>
                <el-radio-group v-model="selectedOption" class="w-full">
                  <div class="space-y-3">
                    <el-radio
                      v-for="option in options"
                      :key="option.id"
                      :label="option.optionKey"
                      class="w-full"
                      border
                    >
                      <span class="font-semibold">{{ option.optionKey }}.</span>
                      {{ option.content }}
                    </el-radio>
                  </div>
                </el-radio-group>
              </div>

              <!-- 提交按钮（选择题） -->
              <div v-if="question.type === 'CHOICE'" class="mb-6">
                <el-button
                  type="primary"
                  size="large"
                  :loading="submitting"
                  :disabled="!selectedOption"
                  @click="handleSubmitChoice"
                >
                  提交答案
                </el-button>
              </div>
            </el-card>

            <!-- 代码编辑器（编程题） -->
            <el-card v-if="question.type === 'CODE'" shadow="never" class="mt-6">
              <div class="mb-4 flex items-center justify-between">
                <h3 class="text-lg font-semibold">代码编辑器</h3>
                <div class="flex items-center gap-3">
                  <el-select v-model="language" style="width: 150px">
                    <el-option label="C语言" value="c" />
                    <el-option label="C++" value="cpp" />
                    <el-option label="Java" value="java" />
                    <el-option label="Python" value="python" />
                  </el-select>
                  <el-button
                    type="primary"
                    :loading="submitting"
                    @click="handleSubmitCode"
                  >
                    提交代码
                  </el-button>
                </div>
              </div>
              <div
                ref="editorContainer"
                class="border rounded"
                style="height: 500px"
              ></div>
            </el-card>
          </div>

          <!-- 右侧：统计和提交记录 -->
          <div class="lg:col-span-1">
            <!-- 统计信息 -->
            <el-card shadow="never" class="mb-6">
              <template #header>
                <div class="font-semibold">统计信息</div>
              </template>
              <div class="space-y-3">
                <div class="flex justify-between">
                  <span class="text-gray-600">总提交数</span>
                  <span class="font-semibold">{{ question.submitCount || 0 }}</span>
                </div>
                <div class="flex justify-between">
                  <span class="text-gray-600">通过数</span>
                  <span class="font-semibold text-green-600">
                    {{ question.acceptedCount || 0 }}
                  </span>
                </div>
                <div class="flex justify-between">
                  <span class="text-gray-600">通过率</span>
                  <span class="font-semibold">
                    {{ calculateAcceptRate(question) }}
                  </span>
                </div>
              </div>
            </el-card>

            <!-- 我的提交记录 -->
            <el-card shadow="never">
              <template #header>
                <div class="font-semibold">我的提交记录</div>
              </template>
              <div class="space-y-2">
                <div
                  v-for="(record, index) in mySubmissions"
                  :key="index"
                  class="p-3 bg-gray-50 rounded hover:bg-gray-100 transition-colors"
                >
                  <div class="flex justify-between items-center mb-1">
                    <el-tag
                      :type="record.status === 'ACCEPTED' ? 'success' : 'danger'"
                      size="small"
                    >
                      {{ getStatusText(record.status) }}
                    </el-tag>
                    <span class="text-xs text-gray-500">
                      {{ formatTime(record.submitTime) }}
                    </span>
                  </div>
                  <div class="text-xs text-gray-600">
                    语言: {{ record.language }}
                  </div>
                </div>
                <el-empty
                  v-if="mySubmissions.length === 0"
                  description="暂无提交记录"
                  :image-size="60"
                />
              </div>
            </el-card>
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { ArrowLeft } from '@element-plus/icons-vue'
import { getQuestionById, submitCode, getQuestionSubmissions } from '@/api'
import * as monaco from 'monaco-editor'

const route = useRoute()
const router = useRouter()

const loading = ref(false)
const submitting = ref(false)
const question = ref(null)
const options = ref([])
const selectedOption = ref('')
const language = ref('c')
const editorContainer = ref(null)
let editor = null

const mySubmissions = ref([])

// 获取题目详情
const fetchQuestionDetail = async () => {
  try {
    loading.value = true
    const id = route.params.id
    const res = await getQuestionById(id)
    question.value = res.data

    // 如果是选择题，获取选项
    if (question.value.type === 'CHOICE' && question.value.options) {
      options.value = question.value.options
    }

    // 如果是编程题，初始化编辑器
    if (question.value.type === 'CODE') {
      await nextTick()
      initEditor()
    }
    
    // 获取提交记录
    fetchMySubmissions()
  } catch (error) {
    console.error('获取题目详情失败:', error)
    ElMessage.error('获取题目详情失败')
  } finally {
    loading.value = false
  }
}

// 获取我的提交记录
const fetchMySubmissions = async () => {
  try {
    const res = await getQuestionSubmissions(question.value.id, {
      current: 1,
      size: 10
    })
    if (res.data && res.data.records) {
      mySubmissions.value = res.data.records.map(item => ({
        ...item,
        submitTime: item.createdAt
      }))
    }
  } catch (error) {
    console.error('获取提交记录失败:', error)
  }
}

// 初始化Monaco编辑器
const initEditor = () => {
  if (!editorContainer.value) return

  editor = monaco.editor.create(editorContainer.value, {
    value: getDefaultCode(),
    language: language.value,
    theme: 'vs-dark',
    automaticLayout: true,
    minimap: { enabled: false },
    fontSize: 14,
    lineNumbers: 'on',
    scrollBeyondLastLine: false,
    wordWrap: 'on'
  })
}

// 获取默认代码模板
const getDefaultCode = () => {
  const templates = {
    c: '#include <stdio.h>\n\nint main() {\n    // 在这里编写你的代码\n    \n    return 0;\n}',
    cpp: '#include <iostream>\nusing namespace std;\n\nint main() {\n    // 在这里编写你的代码\n    \n    return 0;\n}',
    java: 'public class Main {\n    public static void main(String[] args) {\n        // 在这里编写你的代码\n        \n    }\n}',
    python: '# 在这里编写你的代码\n\n'
  }
  return templates[language.value] || ''
}

// 提交选择题答案
const handleSubmitChoice = async () => {
  if (!selectedOption.value) {
    ElMessage.warning('请选择一个选项')
    return
  }

  try {
    submitting.value = true
    // TODO: 调用提交答案API
    ElMessage.success('答案已提交')
    
    // 模拟添加提交记录
    mySubmissions.value.unshift({
      status: 'ACCEPTED',
      submitTime: new Date(),
      language: '选择题'
    })
  } catch (error) {
    console.error('提交答案失败:', error)
    ElMessage.error('提交答案失败')
  } finally {
    submitting.value = false
  }
}

// 提交编程题代码
const handleSubmitCode = async () => {
  if (!editor) return

  const code = editor.getValue()
  if (!code.trim()) {
    ElMessage.warning('请输入代码')
    return
  }

  try {
    submitting.value = true
    
    // 调用提交代码API
    const res = await submitCode({
      questionId: question.value.id,
      language: language.value.toUpperCase(),
      code: code
    })
    
    ElMessage.success('代码已提交，正在判题...')
    
    // 刷新提交记录
    fetchMySubmissions()
  } catch (error) {
    console.error('提交代码失败:', error)
    ElMessage.error('提交代码失败')
  } finally {
    submitting.value = false
  }
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

// 获取状态文本
const getStatusText = (status) => {
  const map = {
    ACCEPTED: '通过',
    WRONG_ANSWER: '答案错误',
    TIME_LIMIT_EXCEEDED: '超时',
    MEMORY_LIMIT_EXCEEDED: '内存超限',
    RUNTIME_ERROR: '运行错误',
    COMPILE_ERROR: '编译错误'
  }
  return map[status] || '未知'
}

// 格式化时间
const formatTime = (time) => {
  const date = new Date(time)
  const now = new Date()
  const diff = now - date
  
  if (diff < 60000) return '刚刚'
  if (diff < 3600000) return `${Math.floor(diff / 60000)}分钟前`
  if (diff < 86400000) return `${Math.floor(diff / 3600000)}小时前`
  
  return `${date.getMonth() + 1}-${date.getDate()} ${date.getHours()}:${String(date.getMinutes()).padStart(2, '0')}`
}

onMounted(() => {
  fetchQuestionDetail()
})

onUnmounted(() => {
  // 销毁编辑器
  if (editor) {
    editor.dispose()
  }
})
</script>

<style scoped>
.prose {
  line-height: 1.8;
}

pre {
  font-family: 'Courier New', monospace;
}
</style>
