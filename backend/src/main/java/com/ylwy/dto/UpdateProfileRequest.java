package com.ylwy.dto;

import lombok.Data;

/**
 * 更新个人信息请求DTO
 */
@Data
public class UpdateProfileRequest {
    /**
     * 昵称
     */
    private String nickname;
    
    /**
     * 个性签名
     */
    private String signature;
    
    /**
     * 邮箱
     */
    private String email;
}
