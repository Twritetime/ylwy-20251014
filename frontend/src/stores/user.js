import { defineStore } from 'pinia'
import { getCurrentUser } from '@/api'

export const useUserStore = defineStore('user', {
  state: () => ({
    token: localStorage.getItem('token') || '',
    userInfo: null
  }),
  
  getters: {
    isLoggedIn: (state) => !!state.token
  },
  
  actions: {
    // 设置Token
    setToken(token) {
      this.token = token
      localStorage.setItem('token', token)
    },
    
    // 设置用户信息
    setUserInfo(userInfo) {
      this.userInfo = userInfo
    },
    
    // 获取用户信息
    async fetchUserInfo() {
      try {
        const res = await getCurrentUser()
        this.userInfo = res.data
        return res.data
      } catch (error) {
        console.error('获取用户信息失败:', error)
        return null
      }
    },
    
    // 登出
    logout() {
      this.token = ''
      this.userInfo = null
      localStorage.removeItem('token')
    }
  }
})
