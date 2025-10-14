<template>
  <div class="min-h-screen bg-gray-50">
    <!-- 顶部导航 -->
    <header class="bg-white shadow">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
          <!-- Logo -->
          <div class="flex items-center">
            <router-link to="/" class="text-2xl font-bold text-primary">
              研路无忧
            </router-link>
          </div>
          
          <!-- 导航菜单 -->
          <nav class="hidden md:flex space-x-8">
            <router-link to="/" class="nav-link">首页</router-link>
            <router-link to="/questions" class="nav-link">题库</router-link>
            <router-link to="/schools" class="nav-link">院校</router-link>
            <router-link to="/ranking" class="nav-link">排行榜</router-link>
          </nav>
          
          <!-- 用户信息 -->
          <div class="flex items-center space-x-4">
            <template v-if="userStore.isLoggedIn">
              <el-dropdown @command="handleCommand">
                <span class="el-dropdown-link cursor-pointer">
                  <el-avatar :size="32" :src="userStore.userInfo?.avatar" />
                  <span class="ml-2">{{ userStore.userInfo?.nickname || userStore.userInfo?.username }}</span>
                </span>
                <template #dropdown>
                  <el-dropdown-menu>
                    <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                    <el-dropdown-item command="logout" divided>退出登录</el-dropdown-item>
                  </el-dropdown-menu>
                </template>
              </el-dropdown>
            </template>
            <template v-else>
              <router-link to="/login">
                <el-button type="primary">登录</el-button>
              </router-link>
              <router-link to="/register">
                <el-button>注册</el-button>
              </router-link>
            </template>
          </div>
        </div>
      </div>
    </header>
    
    <!-- 主内容区 -->
    <main>
      <slot />
    </main>
    
    <!-- 底部 -->
    <footer class="bg-white border-t mt-12">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="text-center text-gray-500">
          <p>© 2025 研路无忧. All rights reserved.</p>
          <p class="mt-2">计算机考研必备神器</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'

const router = useRouter()
const userStore = useUserStore()

onMounted(() => {
  // 如果已登录，获取用户信息
  if (userStore.isLoggedIn && !userStore.userInfo) {
    userStore.fetchUserInfo()
  }
})

const handleCommand = (command) => {
  if (command === 'logout') {
    userStore.logout()
    router.push('/login')
  } else if (command === 'profile') {
    router.push('/profile')
  }
}
</script>

<style scoped>
.nav-link {
  @apply text-gray-700 hover:text-primary transition-colors;
}
.nav-link.router-link-active {
  @apply text-primary font-medium;
}
</style>
