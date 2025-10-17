<template>
  <Layout>
    <div class="home relative">
      <!-- 背景装饰移除：极简纯净 -->
      
      <!-- Hero区域（Apple 风：纯白、留白、克制） -->
      <div class="hero bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100 py-20 relative">
        <div class="max-w-7xl mx-auto px-4 text-center">
          <h1 class="text-display mb-4 animate-fade-in">研路无忧</h1>
          <p class="text-h4 mb-8 opacity-90">计算机考研 · 刷题神器</p>
          <div class="flex flex-col sm:flex-row justify-center gap-4">
            <router-link to="/questions">
              <GradientButton size="large">开始刷题</GradientButton>
            </router-link>
            <router-link to="/schools">
              <el-button size="large" plain class="border-gray-300 dark:border-gray-700 text-gray-900 dark:text-gray-100 hover:bg-gray-100 dark:hover:bg-gray-800 transition-all duration-200">
                院校查询
              </el-button>
            </router-link>
          </div>
        </div>
      </div>
      
      <!-- 热门院校 -->
      <div class="max-w-7xl mx-auto px-4 py-8">
        <h2 class="section-title">热门院校</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
          <AnimatedCard 
            v-for="school in hotSchools" 
            :key="school.name" 
            clickable
            @click="goToSchool(school.name)"
            class="p-5 transition-all duration-300"
          >
            <h3 class="text-h3 mb-2">{{ school.name }}</h3>
            <div class="flex items-center justify-between">
              <p class="text-gray-600 dark:text-gray-400">热门指数</p>
              <el-tag type="primary" effect="dark">{{ school.hotIndex }}↑</el-tag>
            </div>
          </AnimatedCard>
        </div>
      </div>
      
      <!-- 科目导航 -->
      <div class="max-w-7xl mx-auto px-4 py-8 bg-gray-50 dark:bg-gray-800/50 rounded-2xl my-6 transition-colors duration-300">
        <h2 class="section-title">科目分类</h2>
        <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
          <AnimatedCard 
            v-for="subject in subjects" 
            :key="subject.id"
            clickable
            @click="goToQuestions(subject.id)"
            class="p-5 text-center transition-all duration-300"
          >
            <div class="beautiful-icon mx-auto mb-3">
              <el-icon><Collection /></el-icon>
            </div>
            <h3 class="text-h4">{{ subject.name }}</h3>
          </AnimatedCard>
        </div>
      </div>
      
      <!-- 实时动态 -->
      <div class="max-w-7xl mx-auto px-4 py-8">
        <h2 class="section-title">实时动态</h2>
        <AnimatedCard class="p-5 transition-all duration-300">
          <el-empty v-if="!activities.length" description="暂无动态" />
          <div v-else class="space-y-4">
            <div v-for="(activity, index) in activities" :key="index" 
                 class="border-b border-gray-200 dark:border-gray-700 pb-4 last:border-0 animate-slide-up stagger-item"
                 :style="{ animationDelay: `${index * 100}ms` }">
              <div class="flex items-start gap-3">
                <div class="beautiful-icon flex-shrink-0 mt-1">
                  <el-icon><Bell /></el-icon>
                </div>
                <p class="text-gray-700 dark:text-gray-300">{{ activity }}</p>
              </div>
            </div>
          </div>
        </AnimatedCard>
      </div>
    </div>
  </Layout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Collection, Bell } from '@element-plus/icons-vue'
import Layout from '@/components/Layout.vue'
import AnimatedCard from '@/components/AnimatedCard.vue'
import GradientButton from '@/components/GradientButton.vue'
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
  '欢迎新用户加入研路无忧',
  '用户小李在算法题上连续AC5题，获得学霸称号',
  '系统更新：新增100道操作系统练习题'
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

const goToSchool = (schoolName) => {
  console.log(`查看院校: ${schoolName}`)
}
</script>

<style scoped>
.hero {
  transition: all var(--transition-normal) ease;
}

@media (max-width: 768px) {
  .hero {
    padding-top: 1.5rem;
    padding-bottom: 1.5rem;
  }
  
  .hero h1 {
    font-size: 2.5rem;
  }
  
  .hero p {
    font-size: 1.2rem;
  }
  
  .gradient-button {
    width: 100%;
    margin-bottom: 1rem;
  }
  
  .gradient-button:last-child {
    margin-bottom: 0;
  }
}
</style>