package com.ylwy.dto;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Email;

/**
 * 注册请求DTO
 */
@Data
public class RegisterRequest {
    
    @NotBlank(message = "用户名不能为空")
    private String username;
    
    @NotBlank(message = "密码不能为空")
    private String password;
    
    @Email(message = "邮箱格式不正确")
    private String email;
    
    private String nickname;
}
