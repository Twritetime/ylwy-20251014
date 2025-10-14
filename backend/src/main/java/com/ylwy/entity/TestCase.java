package com.ylwy.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 测试用例实体类
 */
@Data
@TableName("test_cases")
public class TestCase {
    
    /**
     * 测试用例ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;
    
    /**
     * 题目ID
     */
    private Long questionId;
    
    /**
     * 输入数据
     */
    private String input;
    
    /**
     * 期望输出
     */
    private String expectedOutput;
    
    /**
     * 是否示例用例(0否/1是)
     */
    private Integer isSample;
    
    /**
     * 排序
     */
    private Integer sortOrder;
    
    /**
     * 创建时间
     */
    private LocalDateTime createdAt;
}
