package com.ylwy.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ylwy.entity.Submission;
import com.ylwy.mapper.SubmissionMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 代码提交服务类
 */
@Service
public class SubmissionService {
    
    @Autowired
    private SubmissionMapper submissionMapper;
    
    /**
     * 创建提交记录
     */
    public Submission createSubmission(Long userId, Long questionId, String language, String code) {
        Submission submission = new Submission();
        submission.setUserId(userId);
        submission.setQuestionId(questionId);
        submission.setLanguage(language);
        submission.setCode(code);
        submission.setStatus("PENDING"); // 初始状态为pending
        submission.setScore(0);
        submission.setPassCount(0);
        submission.setTotalCount(0);
        
        submissionMapper.insert(submission);
        return submission;
    }
    
    /**
     * 查询用户的提交记录
     */
    public Page<Submission> getUserSubmissions(Long userId, int current, int size) {
        Page<Submission> page = new Page<>(current, size);
        QueryWrapper<Submission> wrapper = new QueryWrapper<>();
        wrapper.eq("user_id", userId);
        wrapper.orderByDesc("created_at");
        return submissionMapper.selectPage(page, wrapper);
    }
    
    /**
     * 查询题目的提交记录
     */
    public Page<Submission> getQuestionSubmissions(Long questionId, int current, int size) {
        Page<Submission> page = new Page<>(current, size);
        QueryWrapper<Submission> wrapper = new QueryWrapper<>();
        wrapper.eq("question_id", questionId);
        wrapper.orderByDesc("created_at");
        return submissionMapper.selectPage(page, wrapper);
    }
    
    /**
     * 根据ID获取提交详情
     */
    public Submission getSubmissionById(Long id) {
        return submissionMapper.selectById(id);
    }
}
