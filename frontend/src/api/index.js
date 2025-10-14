import request from '@/utils/request'

// 用户注册
export function register(data) {
  return request({
    url: '/auth/register',
    method: 'post',
    data
  })
}

// 用户登录
export function login(data) {
  return request({
    url: '/auth/login',
    method: 'post',
    data
  })
}

// 获取当前用户信息
export function getCurrentUser() {
  return request({
    url: '/auth/current',
    method: 'get'
  })
}

// 获取题目列表
export function getQuestionList(params) {
  return request({
    url: '/questions/list',
    method: 'get',
    params
  })
}

// 获取题目详情
export function getQuestionById(id) {
  return request({
    url: `/questions/${id}`,
    method: 'get'
  })
}

// 获取科目列表
export function getSubjectList() {
  return request({
    url: '/subjects/list',
    method: 'get'
  })
}

// 获取学校列表
export function getSchoolList(params) {
  return request({
    url: '/schools/list',
    method: 'get',
    params
  })
}
