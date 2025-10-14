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

// ============================================
// 代码提交相关接口
// ============================================

// 提交代码
export function submitCode(data) {
  return request({
    url: '/submissions/submit',
    method: 'post',
    data
  })
}

// 获取我的提交记录
export function getMySubmissions(params) {
  return request({
    url: '/submissions/my',
    method: 'get',
    params
  })
}

// 获取题目的提交记录
export function getQuestionSubmissions(questionId, params) {
  return request({
    url: `/submissions/question/${questionId}`,
    method: 'get',
    params
  })
}

// 获取提交详情
export function getSubmissionById(id) {
  return request({
    url: `/submissions/${id}`,
    method: 'get'
  })
}

// ============================================
// 排行榜相关接口
// ============================================

// 获取排行榜列表
export function getRankList(params) {
  return request({
    url: '/rank/list',
    method: 'get',
    params
  })
}

// 获取我的排名
export function getMyRank() {
  return request({
    url: '/rank/my',
    method: 'get'
  })
}
