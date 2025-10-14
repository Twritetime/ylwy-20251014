package com.ylwy.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 代码提交请求DTO
 */
@Data
public class SubmitCodeRequest {
    
    /**
     * 题目ID
     */
    @NotNull(message = "题目ID不能为空")
    private Long questionId;
    
    /**
     * 编程语言
     */
    @NotBlank(message = "编程语言不能为空")
    private String language;
    
    /**
     * 代码内容
     */
    @NotBlank(message = "代码不能为空")
    private String code;
}
