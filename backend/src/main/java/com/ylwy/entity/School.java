package com.ylwy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 学校实体类
 */
@Data
@TableName("schools")
public class School {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String name;
    
    private String province;
    
    private String city;
    
    private String level;
    
    private String logo;
    
    private String description;
    
    private Integer hotIndex;
    
    private Integer viewCount;
    
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
    
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
