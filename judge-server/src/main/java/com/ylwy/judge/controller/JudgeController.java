package com.ylwy.judge.controller;

import com.ylwy.judge.dto.JudgeRequest;
import com.ylwy.judge.dto.JudgeResponse;
import com.ylwy.judge.service.JudgeEngine;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 判题控制器
 */
@Slf4j
@RestController
@RequestMapping("/judge")
public class JudgeController {
    
    @Autowired
    private JudgeEngine judgeEngine;
    
    /**
     * 执行判题
     */
    @PostMapping("/execute")
    public JudgeResponse execute(@RequestBody JudgeRequest request) {
        log.info("收到判题请求，提交ID: {}, 语言: {}", request.getSubmissionId(), request.getLanguage());
        return judgeEngine.judge(request);
    }
    
    /**
     * 健康检查
     */
    @GetMapping("/health")
    public String health() {
        return "Judge Server is running!";
    }
}
