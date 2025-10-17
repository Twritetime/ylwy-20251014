import axios from 'axios'
import { ElMessage } from 'element-plus'

// 创建axios实例
const request = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080/api',
  timeout: 15000
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    // 从localStorage获取token
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  response => {
    const res = response.data
    const silent = response?.config?.silent === true
    
    // 如果返回的状态码不是200，则认为是错误
    if (res.code !== 200) {
      if (!silent) {
        ElMessage.error(res.message || '请求失败')
      }
      
      // 401: 未授权，跳转登录
      if (res.code === 401) {
        localStorage.removeItem('token')
        if (!silent) {
          window.location.href = '/login'
        }
      }
      
      return Promise.reject(new Error(res.message || '请求失败'))
    }
    
    return res
  },
  error => {
    console.error('响应错误:', error)
    const silent = error?.config?.silent === true
    
    if (error.response) {
      switch (error.response.status) {
        case 401:
          if (!silent) ElMessage.error('未授权，请登录')
          localStorage.removeItem('token')
          if (!silent) window.location.href = '/login'
          break
        case 403:
          if (!silent) ElMessage.error('拒绝访问')
          break
        case 404:
          if (!silent) ElMessage.error('请求地址不存在')
          break
        case 500:
          if (!silent) ElMessage.error('服务器错误')
          break
        default:
          if (!silent) ElMessage.error(error.message || '网络错误')
      }
    } else {
      if (!silent) ElMessage.error('网络连接失败')
    }
    
    return Promise.reject(error)
  }
)

export default request
