package com.ylwy.dto;

import lombok.Data;

/**
 * 用户排行榜数据传输对象
 */
@Data
public class UserRankDTO {
    
    /**
     * 用户ID
     */
    private Long userId;
    
    /**
     * 用户名
     */
    private String username;
    
    /**
     * 昵称
     */
    private String nickname;
    
    /**
     * 头像URL
     */
    private String avatar;
    
    /**
     * AC题目数
     */
    private Integer acCount;
    
    /**
     * 提交总数
     */
    private Integer submitCount;
    
    /**
     * AC率(百分比)
     */
    private Double acRate;
    
    /**
     * 排名
     */
    private Integer rank;
}
