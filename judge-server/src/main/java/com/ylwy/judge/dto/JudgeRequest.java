package com.ylwy.judge.dto;

import lombok.Data;

import java.util.List;

/**
 * 判题请求DTO
 */
@Data
public class JudgeRequest {
    
    /**
     * 提交ID
     */
    private Long submissionId;
    
    /**
     * 题目ID
     */
    private Long questionId;
    
    /**
     * 编程语言 (cpp/java/python)
     */
    private String language;
    
    /**
     * 用户代码
     */
    private String code;
    
    /**
     * 测试用例列表
     */
    private List<TestCase> testCases;
    
    /**
     * 时间限制 (毫秒)
     */
    private Integer timeLimit = 1000;
    
    /**
     * 内存限制 (KB)
     */
    private Integer memoryLimit = 262144; // 256MB
    
    /**
     * 测试用例内部类
     */
    @Data
    public static class TestCase {
        /**
         * 输入数据
         */
        private String input;
        
        /**
         * 期望输出
         */
        private String expectedOutput;
    }
}
