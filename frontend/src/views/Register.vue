<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900 relative overflow-hidden">
    <!-- 背景装饰 -->
    <div class="background-decoration">
      <div class="decoration-circle decoration-circle-1"></div>
      <div class="decoration-circle decoration-circle-2"></div>
    </div>
    
    <div class="w-full max-w-md px-4 relative z-10">
      <!-- Logo 和标题 -->
      <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-blue-600 dark:text-blue-400 mb-2">研路无忧</h1>
        <p class="text-gray-600 dark:text-gray-400">注册账号，开启刷题之旅</p>
      </div>

      <!-- 注册表单 -->
      <AnimatedCard class="shadow-lg">
        <div class="p-8">
          <el-form
            ref="registerFormRef"
            :model="registerForm"
            :rules="rules"
            label-width="80px"
            size="large"
          >
            <div class="mb-6">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">用户名</label>
              <el-input
                v-model="registerForm.username"
                placeholder="请输入用户名（4-20位字母数字）"
                class="beautiful-input"
                clearable
              >
                <template #prefix>
                  <el-icon><User /></el-icon>
                </template>
              </el-input>
            </div>

            <div class="mb-6">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">昵称</label>
              <el-input
                v-model="registerForm.nickname"
                placeholder="请输入昵称"
                class="beautiful-input"
                clearable
              >
                <template #prefix>
                  <el-icon><Avatar /></el-icon>
                </template>
              </el-input>
            </div>

            <div class="mb-6">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">邮箱</label>
              <el-input
                v-model="registerForm.email"
                placeholder="请输入邮箱地址"
                class="beautiful-input"
                clearable
              >
                <template #prefix>
                  <el-icon><Message /></el-icon>
                </template>
              </el-input>
            </div>

            <div class="mb-6">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">密码</label>
              <el-input
                v-model="registerForm.password"
                type="password"
                placeholder="请输入密码（至少6位）"
                class="beautiful-input"
                show-password
              >
                <template #prefix>
                  <el-icon><Lock /></el-icon>
                </template>
              </el-input>
            </div>

            <div class="mb-6">
              <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">确认密码</label>
              <el-input
                v-model="registerForm.confirmPassword"
                type="password"
                placeholder="请再次输入密码"
                class="beautiful-input"
                show-password
              >
                <template #prefix>
                  <el-icon><Lock /></el-icon>
                </template>
              </el-input>
            </div>

            <div class="mb-6">
              <GradientButton
                type="primary"
                class="w-full"
                :loading="loading"
                @click="handleRegister"
              >
                注册
              </GradientButton>
            </div>

            <div class="text-center text-sm">
              <span class="text-gray-600 dark:text-gray-400">已有账号？</span>
              <el-link type="primary" @click="router.push('/login')">
                立即登录
              </el-link>
            </div>
          </el-form>
        </div>
      </AnimatedCard>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Avatar, Message, Lock } from '@element-plus/icons-vue'
import { register, login } from '@/api'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const userStore = useUserStore()

const registerFormRef = ref(null)
const loading = ref(false)

const registerForm = reactive({
  username: '',
  nickname: '',
  email: '',
  password: '',
  confirmPassword: ''
})

// 自定义验证规则
const validateUsername = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请输入用户名'))
  } else if (!/^[a-zA-Z0-9]{4,20}$/.test(value)) {
    callback(new Error('用户名为4-20位字母或数字'))
  } else {
    callback()
  }
}

const validatePassword = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请输入密码'))
  } else if (value.length < 6) {
    callback(new Error('密码至少6位'))
  } else {
    callback()
  }
}

const validateConfirmPassword = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请再次输入密码'))
  } else if (value !== registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const validateEmail = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请输入邮箱'))
  } else if (!/^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/.test(value)) {
    callback(new Error('请输入正确的邮箱格式'))
  } else {
    callback()
  }
}

const rules = {
  username: [{ validator: validateUsername, trigger: 'blur' }],
  nickname: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
  email: [{ validator: validateEmail, trigger: 'blur' }],
  password: [{ validator: validatePassword, trigger: 'blur' }],
  confirmPassword: [{ validator: validateConfirmPassword, trigger: 'blur' }]
}

const handleRegister = async () => {
  try {
    const valid = await registerFormRef.value.validate()
    if (!valid) return

    loading.value = true

    // 调用注册接口
    const { username, password, email, nickname } = registerForm
    await register({ username, password, email, nickname })

    ElMessage.success('注册成功，正在自动登录...')

    // 注册成功后自动登录
    const loginRes = await login({ username, password })
    
    userStore.setToken(loginRes.data.token)
    userStore.setUserInfo({
      id: loginRes.data.userId,
      username: loginRes.data.username,
      nickname: loginRes.data.nickname,
      avatar: loginRes.data.avatar
    })

    ElMessage.success('登录成功')
    router.push('/')
  } catch (error) {
    console.error('注册失败:', error)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
:deep(.el-form-item__label) {
  font-weight: 500;
}
</style>
