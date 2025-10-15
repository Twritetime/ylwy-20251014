import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home.vue')
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue')
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/Register.vue')
  },
  {
    path: '/questions',
    name: 'QuestionList',
    component: () => import('@/views/QuestionList.vue')
  },
  {
    path: '/questions/:id',
    name: 'QuestionDetail',
    component: () => import('@/views/QuestionDetail.vue')
  },
  {
    path: '/schools',
    name: 'SchoolList',
    component: () => import('@/views/SchoolList.vue')
  },
  {
    path: '/ranking',
    name: 'Ranking',
    component: () => import('@/views/Ranking.vue')
  },
  {
    path: '/profile',
    name: 'Profile',
    component: () => import('@/views/Profile.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  
  // 需要登录的页面
  const authPages = ['/questions', '/schools', '/ranking', '/profile']
  const needAuth = authPages.some(page => to.path.startsWith(page))
  
  if (needAuth && !token) {
    next('/login')
  } else {
    next()
  }
})

export default router
