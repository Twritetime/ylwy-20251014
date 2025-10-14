package com.ylwy.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 选择题选项实体类
 */
@Data
@TableName("question_options")
public class QuestionOption {
    
    /**
     * 选项ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 题目ID
     */
    private Long questionId;
    
    /**
     * 选项标识(A/B/C/D)
     */
    private String optionKey;
    
    /**
     * 选项内容
     */
    private String optionContent;
    
    /**
     * 是否正确答案(0否/1是)
     */
    private Integer isCorrect;
    
    /**
     * 创建时间
     */
    private LocalDateTime createdAt;
}
