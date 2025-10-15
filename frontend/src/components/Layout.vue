<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900 transition-colors duration-300">
    <!-- 顶部导航 -->
    <header class="bg-white/90 dark:bg-gray-800/90 backdrop-blur-sm shadow-sm transition-colors duration-300 sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-14">
          <!-- Logo -->
          <div class="flex items-center">
            <router-link to="/" class="text-xl font-bold text-primary dark:text-blue-400 flex items-center gap-2">
              <div class="beautiful-icon">
                <el-icon><Collection /></el-icon>
              </div>
              <span>研路无忧</span>
            </router-link>
          </div>
          
          <!-- 桌面端导航菜单 -->
          <nav class="hidden md:flex space-x-1">
            <router-link to="/" class="nav-link flex items-center gap-1 px-3 py-2 rounded-lg text-sm">
              <el-icon><HomeFilled /></el-icon>
              <span>首页</span>
            </router-link>
            <router-link to="/questions" class="nav-link flex items-center gap-1 px-3 py-2 rounded-lg text-sm">
              <el-icon><Document /></el-icon>
              <span>题库</span>
            </router-link>
            <router-link to="/schools" class="nav-link flex items-center gap-1 px-3 py-2 rounded-lg text-sm">
              <el-icon><School /></el-icon>
              <span>院校</span>
            </router-link>
            <router-link to="/ranking" class="nav-link flex items-center gap-1 px-3 py-2 rounded-lg text-sm">
              <el-icon><Trophy /></el-icon>
              <span>排行榜</span>
            </router-link>
          </nav>
          
          <!-- 移动端汉堡菜单按钮 -->
          <div class="md:hidden">
            <el-button 
              @click="mobileMenuOpen = !mobileMenuOpen" 
              circle 
              size="small"
              class="btn-transition bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600"
            >
              <el-icon><Menu /></el-icon>
            </el-button>
          </div>
          
          <!-- 用户信息和主题切换 -->
          <div class="hidden md:flex items-center space-x-2">
            <!-- 暗色模式切换按钮 -->
            <el-button 
              @click="themeStore.toggleTheme" 
              circle
              size="small"
              class="btn-transition bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600"
            >
              <el-icon v-if="themeStore.isDark"><Moon /></el-icon>
              <el-icon v-else><Sunny /></el-icon>
            </el-button>
            
            <template v-if="userStore.isLoggedIn">
              <el-dropdown @command="handleCommand">
                <span class="el-dropdown-link cursor-pointer flex items-center gap-2">
                  <el-avatar :size="28" :src="userStore.userInfo?.avatar" />
                  <span class="text-gray-700 dark:text-gray-200 hidden sm:block text-sm">{{ userStore.userInfo?.nickname || userStore.userInfo?.username }}</span>
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
                <GradientButton size="small">登录</GradientButton>
              </router-link>
              <router-link to="/register">
                <el-button size="small" class="bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600">注册</el-button>
              </router-link>
            </template>
          </div>
        </div>
      </div>
      
      <!-- 移动端菜单 -->
      <transition name="slide-fade">
        <div v-if="mobileMenuOpen" class="md:hidden bg-white dark:bg-gray-800 border-t dark:border-gray-700">
          <nav class="px-4 py-3 space-y-1">
            <router-link to="/" class="mobile-nav-link" @click="mobileMenuOpen = false">
              <el-icon><HomeFilled /></el-icon>
              <span class="ml-2">首页</span>
            </router-link>
            <router-link to="/questions" class="mobile-nav-link" @click="mobileMenuOpen = false">
              <el-icon><Document /></el-icon>
              <span class="ml-2">题库</span>
            </router-link>
            <router-link to="/schools" class="mobile-nav-link" @click="mobileMenuOpen = false">
              <el-icon><School /></el-icon>
              <span class="ml-2">院校</span>
            </router-link>
            <router-link to="/ranking" class="mobile-nav-link" @click="mobileMenuOpen = false">
              <el-icon><Trophy /></el-icon>
              <span class="ml-2">排行榜</span>
            </router-link>
            
            <div class="pt-3 border-t dark:border-gray-700 flex items-center justify-between">
              <span class="text-gray-700 dark:text-gray-200 text-sm">暗色模式</span>
              <el-button @click="themeStore.toggleTheme" circle size="small" class="btn-transition bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600">
                <el-icon v-if="themeStore.isDark"><Moon /></el-icon>
                <el-icon v-else><Sunny /></el-icon>
              </el-button>
            </div>
            
            <template v-if="userStore.isLoggedIn">
              <div class="pt-3 border-t dark:border-gray-700">
                <div class="flex items-center gap-3 mb-3">
                  <el-avatar :size="32" :src="userStore.userInfo?.avatar" />
                  <span class="text-gray-700 dark:text-gray-200">{{ userStore.userInfo?.nickname || userStore.userInfo?.username }}</span>
                </div>
                <div class="space-y-1">
                  <router-link to="/profile" class="mobile-nav-link" @click="mobileMenuOpen = false">
                    <el-icon><User /></el-icon>
                    <span class="ml-2">个人中心</span>
                  </router-link>
                  <button @click="handleLogout" class="mobile-nav-link w-full text-left text-red-600 dark:text-red-400">
                    <el-icon><SwitchButton /></el-icon>
                    <span class="ml-2">退出登录</span>
                  </button>
                </div>
              </div>
            </template>
            <template v-else>
              <div class="pt-3 border-t dark:border-gray-700 space-y-2">
                <router-link to="/login" class="block">
                  <GradientButton class="w-full" size="small">登录</GradientButton>
                </router-link>
                <router-link to="/register" class="block">
                  <el-button class="w-full bg-gray-100 dark:bg-gray-700 hover:bg-gray-200 dark:hover:bg-gray-600" size="small">注册</el-button>
                </router-link>
              </div>
            </template>
          </nav>
        </div>
      </transition>
    </header>
    
    <!-- 主内容区 -->
    <main class="pb-12">
      <slot />
    </main>
    
    <!-- 底部 -->
    <footer class="bg-white/90 dark:bg-gray-800/90 backdrop-blur-sm border-t dark:border-gray-700 transition-colors duration-300">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <div class="text-center text-gray-500 dark:text-gray-400 text-sm">
          <p>© 2025 研路无忧. All rights reserved.</p>
          <p class="mt-1">计算机考研必备神器</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { useThemeStore } from '@/stores/theme'
import { Menu, Moon, Sunny, HomeFilled, Document, School, Trophy, User, SwitchButton, Collection } from '@element-plus/icons-vue'

const router = useRouter()
const userStore = useUserStore()
const themeStore = useThemeStore()
const mobileMenuOpen = ref(false)

onMounted(() => {
  // 如果已登录,获取用户信息
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

const handleLogout = () => {
  mobileMenuOpen.value = false
  userStore.logout()
  router.push('/login')
}
</script>

<style scoped>
.nav-link {
  @apply text-gray-700 dark:text-gray-200 hover:text-primary dark:hover:text-blue-400 transition-colors flex items-center gap-1 py-2 px-3 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700;
}
.nav-link.router-link-active {
  @apply text-primary dark:text-blue-400 font-medium bg-blue-50 dark:bg-blue-900/30;
}

.mobile-nav-link {
  @apply block px-4 py-2 rounded-lg text-gray-700 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors flex items-center text-sm;
}
.mobile-nav-link.router-link-active {
  @apply bg-blue-50 dark:bg-blue-900/30 text-primary dark:text-blue-400 font-medium;
}

/* 滑动动画 */
.slide-fade-enter-active {
  transition: all 0.3s ease-out;
}
.slide-fade-leave-active {
  transition: all 0.3s cubic-bezier(1, 0.5, 0.8, 1);
}
.slide-fade-enter-from,
.slide-fade-leave-to {
  transform: translateY(-10px);
  opacity: 0;
}
</style>