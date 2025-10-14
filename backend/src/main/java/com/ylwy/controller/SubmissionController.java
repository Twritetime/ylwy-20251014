package com.ylwy.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ylwy.common.Result;
import com.ylwy.dto.SubmitCodeRequest;
import com.ylwy.entity.Submission;
import com.ylwy.service.SubmissionService;
import com.ylwy.util.JwtUtil;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 代码提交控制器
 */
@RestController
@RequestMapping("/submissions")
public class SubmissionController {
    
    @Autowired
    private SubmissionService submissionService;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    /**
     * 提交代码
     */
    @PostMapping("/submit")
    public Result<Submission> submitCode(
            @RequestHeader("Authorization") String token,
            @Valid @RequestBody SubmitCodeRequest request) {
        try {
            // 解析token获取用户ID
            if (token.startsWith("Bearer ")) {
                token = token.substring(7);
            }
            Long userId = jwtUtil.getUserIdFromToken(token);
            
            // 创建提交记录
            Submission submission = submissionService.createSubmission(
                userId,
                request.getQuestionId(),
                request.getLanguage(),
                request.getCode()
            );
            
            // TODO: 异步发送到判题队列
            // 这里先返回PENDING状态，后续实现判题服务
            
            return Result.success("提交成功", submission);
        } catch (Exception e) {
            return Result.error("提交失败：" + e.getMessage());
        }
    }
    
    /**
     * 获取我的提交记录
     */
    @GetMapping("/my")
    public Result<Page<Submission>> getMySubmissions(
            @RequestHeader("Authorization") String token,
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size) {
        try {
            if (token.startsWith("Bearer ")) {
                token = token.substring(7);
            }
            Long userId = jwtUtil.getUserIdFromToken(token);
            
            Page<Submission> page = submissionService.getUserSubmissions(userId, current, size);
            return Result.success(page);
        } catch (Exception e) {
            return Result.error("获取提交记录失败");
        }
    }
    
    /**
     * 获取题目的提交记录
     */
    @GetMapping("/question/{questionId}")
    public Result<Page<Submission>> getQuestionSubmissions(
            @PathVariable Long questionId,
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size) {
        Page<Submission> page = submissionService.getQuestionSubmissions(questionId, current, size);
        return Result.success(page);
    }
    
    /**
     * 获取提交详情
     */
    @GetMapping("/{id}")
    public Result<Submission> getSubmissionById(@PathVariable Long id) {
        Submission submission = submissionService.getSubmissionById(id);
        if (submission == null) {
            return Result.error("提交记录不存在");
        }
        return Result.success(submission);
    }
}
