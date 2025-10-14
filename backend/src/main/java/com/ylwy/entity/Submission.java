package com.ylwy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 代码提交记录实体类
 */
@Data
@TableName("submissions")
public class Submission {
    
    /**
     * 提交ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 题目ID
     */
    private Long questionId;
    
    /**
     * 编程语言(cpp/java/python)
     */
    private String language;
    
    /**
     * 提交代码
     */
    private String code;
    
    /**
     * 判题状态(pending/judging/ac/wa/tle/mle/re/ce/se)
     */
    private String status;
    
    /**
     * 得分
     */
    private Integer score;
    
    /**
     * 运行时间(ms)
     */
    private Integer timeUsed;
    
    /**
     * 内存使用(KB)
     */
    private Integer memoryUsed;
    
    /**
     * 错误信息
     */
    private String errorMessage;
    
    /**
     * 通过测试用例数
     */
    private Integer passCount;
    
    /**
     * 总测试用例数
     */
    private Integer totalCount;
    
    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
