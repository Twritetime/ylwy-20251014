package com.ylwy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 题目实体类
 */
@Data
@TableName("questions")
public class Question {
    
    /**
     * 题目ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 题目编号
     */
    private String questionNo;
    
    /**
     * 题目标题
     */
    private String title;
    
    /**
     * 题目内容
     */
    private String content;
    
    /**
     * 题目类型(choice/program)
     */
    private String type;
    
    /**
     * 难度(easy/medium/hard)
     */
    private String difficulty;
    
    /**
     * 科目ID
     */
    private Long subjectId;
    
    /**
     * 分类ID
     */
    private Long categoryId;
    
    /**
     * 来源学校
     */
    private String schoolSource;
    
    /**
     * 时间限制(ms，仅编程题)
     */
    private Integer timeLimit;
    
    /**
     * 内存限制(MB，仅编程题)
     */
    private Integer memoryLimit;
    
    /**
     * 通过率(%)
     */
    private BigDecimal passRate;
    
    /**
     * 提交次数
     */
    private Integer submitCount;
    
    /**
     * 通过次数
     */
    private Integer acceptCount;
    
    /**
     * 创建时间
     */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
    
    /**
     * 更新时间
     */
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
