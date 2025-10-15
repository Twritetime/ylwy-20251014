package com.ylwy.dto;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 用户个人信息响应DTO
 */
@Data
public class UserProfileDTO {
    /**
     * 用户ID
     */
    private Long id;
    
    /**
     * 用户名
     */
    private String username;
    
    /**
     * 邮箱
     */
    private String email;
    
    /**
     * 昵称
     */
    private String nickname;
    
    /**
     * 个性签名
     */
    private String signature;
    
    /**
     * 头像URL
     */
    private String avatar;
    
    /**
     * 注册时间
     */
    private LocalDateTime createdAt;
    
    /**
     * 总AC题目数
     */
    private Integer totalAC;
    
    /**
     * 总提交数
     */
    private Integer totalSubmissions;
    
    /**
     * AC率
     */
    private Double acRate;
    
    /**
     * 总得分
     */
    private Integer totalScore;
}
