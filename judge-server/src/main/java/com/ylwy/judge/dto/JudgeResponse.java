package com.ylwy.judge.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 判题响应DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class JudgeResponse {
    
    /**
     * 提交ID
     */
    private Long submissionId;
    
    /**
     * 判题状态 (ac/wa/tle/mle/re/ce/se)
     */
    private String status;
    
    /**
     * 状态消息
     */
    private String message;
    
    /**
     * 运行时间 (毫秒)
     */
    private Integer timeUsed;
    
    /**
     * 内存使用 (KB)
     */
    private Integer memoryUsed;
    
    /**
     * 通过的测试用例数
     */
    private Integer passCount;
    
    /**
     * 总测试用例数
     */
    private Integer totalCount;
    
    /**
     * 错误信息
     */
    private String errorMessage;
    
    /**
     * 编译输出
     */
    private String compileOutput;
}
