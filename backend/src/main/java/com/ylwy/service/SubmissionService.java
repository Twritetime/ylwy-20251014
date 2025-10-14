package com.ylwy.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ylwy.client.JudgeClient;
import com.ylwy.entity.Submission;
import com.ylwy.entity.TestCase;
import com.ylwy.mapper.SubmissionMapper;
import com.ylwy.mapper.TestCaseMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 代码提交服务类
 */
@Slf4j
@Service
public class SubmissionService {
    
    @Autowired
    private SubmissionMapper submissionMapper;
    
    @Autowired
    private TestCaseMapper testCaseMapper;
    
    @Autowired
    private JudgeClient judgeClient;
    
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
    
    /**
     * 更新提交记录的判题结果
     */
    public void updateSubmissionResult(Long submissionId, JudgeClient.JudgeResponse judgeResult) {
        Submission submission = new Submission();
        submission.setId(submissionId);
        submission.setStatus(judgeResult.getStatus().toUpperCase());
        submission.setTimeUsed(judgeResult.getTimeUsed());
        submission.setMemoryUsed(judgeResult.getMemoryUsed());
        submission.setPassCount(judgeResult.getPassCount());
        submission.setTotalCount(judgeResult.getTotalCount());
        submission.setErrorMessage(judgeResult.getErrorMessage());
        
        // 计算得分 (AC得100分，其他0分)
        if ("AC".equalsIgnoreCase(judgeResult.getStatus())) {
            submission.setScore(100);
        } else {
            submission.setScore(0);
        }
        
        submissionMapper.updateById(submission);
        log.info("更新提交记录 ID={}, 状态={}", submissionId, judgeResult.getStatus());
    }
    
    /**
     * 异步执行判题
     */
    @Async
    public void judgeSubmissionAsync(Long submissionId, Long questionId) {
        log.info("开始异步判题，提交ID: {}", submissionId);
        
        try {
            // 1. 获取提交记录
            Submission submission = submissionMapper.selectById(submissionId);
            if (submission == null) {
                log.error("提交记录不存在: {}", submissionId);
                return;
            }
            
            // 2. 更新状态为判题中
            Submission updating = new Submission();
            updating.setId(submissionId);
            updating.setStatus("JUDGING");
            submissionMapper.updateById(updating);
            
            // 3. 获取测试用例
            QueryWrapper<TestCase> wrapper = new QueryWrapper<>();
            wrapper.eq("question_id", questionId);
            wrapper.orderByAsc("sort_order");
            List<TestCase> testCases = testCaseMapper.selectList(wrapper);
            
            if (testCases == null || testCases.isEmpty()) {
                log.warn("题目 {} 没有测试用例", questionId);
                // 没有测试用例，直接标记为AC
                JudgeClient.JudgeResponse result = new JudgeClient.JudgeResponse();
                result.setSubmissionId(submissionId);
                result.setStatus("AC");
                result.setMessage("答案正确（无测试用例）");
                result.setPassCount(0);
                result.setTotalCount(0);
                result.setTimeUsed(0);
                result.setMemoryUsed(0);
                updateSubmissionResult(submissionId, result);
                return;
            }
            
            // 4. 构造判题请求
            JudgeClient.JudgeRequest judgeRequest = new JudgeClient.JudgeRequest();
            judgeRequest.setSubmissionId(submissionId);
            judgeRequest.setQuestionId(questionId);
            judgeRequest.setLanguage(submission.getLanguage());
            judgeRequest.setCode(submission.getCode());
            judgeRequest.setTimeLimit(1000);
            judgeRequest.setMemoryLimit(262144);
            
            // 转换测试用例格式
            List<JudgeClient.JudgeRequest.TestCase> judgTestCases = testCases.stream()
                .map(tc -> {
                    JudgeClient.JudgeRequest.TestCase jtc = new JudgeClient.JudgeRequest.TestCase();
                    jtc.setInput(tc.getInput());
                    jtc.setExpectedOutput(tc.getExpectedOutput());
                    return jtc;
                })
                .collect(Collectors.toList());
            judgeRequest.setTestCases(judgTestCases);
            
            // 5. 调用判题服务
            log.info("调用判题服务，提交ID: {}, 测试用例数: {}", submissionId, testCases.size());
            JudgeClient.JudgeResponse judgeResult = judgeClient.executeJudge(judgeRequest);
            
            // 6. 更新判题结果
            updateSubmissionResult(submissionId, judgeResult);
            
            log.info("判题完成，提交ID: {}, 结果: {}", submissionId, judgeResult.getStatus());
            
        } catch (Exception e) {
            log.error("判题异常，提交ID: " + submissionId, e);
            
            // 更新为系统错误
            Submission errorSubmission = new Submission();
            errorSubmission.setId(submissionId);
            errorSubmission.setStatus("SE");
            errorSubmission.setErrorMessage("系统错误: " + e.getMessage());
            errorSubmission.setScore(0);
            submissionMapper.updateById(errorSubmission);
        }
    }
}
