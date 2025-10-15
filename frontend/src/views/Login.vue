<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900 py-12 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
    <!-- 背景装饰 -->
    <div class="background-decoration">
      <div class="decoration-circle decoration-circle-1"></div>
      <div class="decoration-circle decoration-circle-2"></div>
    </div>
    
    <div class="max-w-md w-full relative z-10">
      <div class="text-center mb-8">
        <h2 class="text-3xl font-bold text-gray-900 dark:text-white">研路无忧</h2>
        <p class="mt-2 text-sm text-gray-600 dark:text-gray-400">登录您的账号</p>
      </div>
      
      <AnimatedCard class="shadow-lg">
        <div class="p-8">
          <el-form
            ref="loginFormRef"
            :model="loginForm"
            :rules="rules"
            label-width="0"
          >
            <div class="mb-6">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">用户名</label>
              <el-input
                v-model="loginForm.username"
                placeholder="请输入用户名"
                size="large"
                class="beautiful-input"
                prefix-icon="User"
              />
            </div>
            
            <div class="mb-6">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">密码</label>
              <el-input
                v-model="loginForm.password"
                type="password"
                placeholder="请输入密码"
                size="large"
                class="beautiful-input"
                prefix-icon="Lock"
                show-password
                @keyup.enter="handleLogin"
              />
            </div>
            
            <div class="mb-6">
              <GradientButton
                type="primary"
                size="large"
                :loading="loading"
                @click="handleLogin"
                class="w-full"
              >
                登录
              </GradientButton>
            </div>
            
            <div class="text-center text-sm">
              <span class="text-gray-600 dark:text-gray-400">还没有账号？</span>
              <router-link to="/register" class="text-primary hover:underline ml-1 dark:text-blue-400">
                立即注册
              </router-link>
            </div>
          </el-form>
        </div>
      </AnimatedCard>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import AnimatedCard from '@/components/AnimatedCard.vue'
import GradientButton from '@/components/GradientButton.vue'
import { useUserStore } from '@/stores/user'
import { login } from '@/api'

const router = useRouter()
const userStore = useUserStore()

const loginFormRef = ref(null)
const loading = ref(false)

const loginForm = ref({
  username: '',
  password: ''
})

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' }
  ]
}

const handleLogin = async () => {
  try {
    const valid = await loginFormRef.value.validate()
    if (!valid) return
    
    loading.value = true
    
    const res = await login(loginForm.value)
    
    // 保存token和用户信息
    userStore.setToken(res.data.token)
    userStore.setUserInfo({
      id: res.data.userId,
      username: res.data.username,
      nickname: res.data.nickname,
      avatar: res.data.avatar
    })
    
    ElMessage.success('登录成功')
    
    // 跳转到首页
    router.push('/profile')
  } catch (error) {
    console.error('登录失败:', error)
    ElMessage.error('登录失败，请检查用户名和密码')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
</style>
