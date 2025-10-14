<template>
  <Layout>
    <div class="home">
      <!-- Hero区域 -->
      <div class="hero bg-gradient-to-r from-blue-500 to-purple-600 text-white py-20">
        <div class="max-w-7xl mx-auto px-4 text-center">
          <h1 class="text-5xl font-bold mb-4">研路无忧</h1>
          <p class="text-xl mb-8">计算机考研 · 刷题神器</p>
          <div class="space-x-4">
            <router-link to="/questions">
              <el-button type="primary" size="large">开始刷题</el-button>
            </router-link>
            <router-link to="/schools">
              <el-button type="default" size="large" plain>院校查询</el-button>
            </router-link>
          </div>
        </div>
      </div>
      
      <!-- 热门院校 -->
      <div class="max-w-7xl mx-auto px-4 py-12">
        <h2 class="text-2xl font-bold mb-6">热门院校</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div v-for="school in hotSchools" :key="school.name" 
               class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition-shadow cursor-pointer">
            <h3 class="text-xl font-semibold mb-2">{{ school.name }}</h3>
            <p class="text-gray-600">热门指数: {{ school.hotIndex }}↑</p>
          </div>
        </div>
      </div>
      
      <!-- 科目导航 -->
      <div class="max-w-7xl mx-auto px-4 py-12">
        <h2 class="text-2xl font-bold mb-6">科目分类</h2>
        <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
          <div v-for="subject in subjects" :key="subject.id"
               @click="goToQuestions(subject.id)"
               class="bg-white p-6 rounded-lg shadow text-center cursor-pointer hover:shadow-lg transition-shadow">
            <h3 class="text-lg font-semibold">{{ subject.name }}</h3>
          </div>
        </div>
      </div>
      
      <!-- 实时动态 -->
      <div class="max-w-7xl mx-auto px-4 py-12">
        <h2 class="text-2xl font-bold mb-6">实时动态</h2>
        <div class="bg-white rounded-lg shadow p-6">
          <el-empty v-if="!activities.length" description="暂无动态" />
          <div v-else class="space-y-4">
            <div v-for="(activity, index) in activities" :key="index" 
                 class="border-b pb-4 last:border-0">
              <p class="text-gray-700">{{ activity }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Layout from '@/components/Layout.vue'
import { getSubjectList } from '@/api'

const router = useRouter()

const hotSchools = ref([
  { name: '清华大学', hotIndex: 9319 },
  { name: '北京大学', hotIndex: 9288 },
  { name: '上海交通大学', hotIndex: 9013 }
])

const subjects = ref([])

const activities = ref([
  '用户小明刚刚完成了数据结构组卷，得分85分',
  '用户小红通过了C语言题目1000',
  '欢迎新用户加入研路无忧'
])

onMounted(async () => {
  try {
    const res = await getSubjectList()
    subjects.value = res.data
  } catch (error) {
    console.error('获取科目列表失败:', error)
  }
})

const goToQuestions = (subjectId) => {
  router.push({
    path: '/questions',
    query: { subjectId }
  })
}
</script>

<style scoped>
.hero {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
</style>
