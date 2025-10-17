package com.ylwy.config;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

/**
 * MyBatis Plus 审计字段自动填充处理器
 * 统一在插入/更新时填充 createdAt / updatedAt
 */
@Component
public class AuditMetaObjectHandler implements MetaObjectHandler {

    @Override
    public void insertFill(MetaObject metaObject) {
        LocalDateTime now = LocalDateTime.now();
        // createdAt 仅在为空时填充
        if (getFieldValByName("createdAt", metaObject) == null) {
            setFieldValByName("createdAt", now, metaObject);
        }
        // updatedAt 兼容存在该字段的实体
        if (hasSetter(metaObject, "updatedAt") && getFieldValByName("updatedAt", metaObject) == null) {
            setFieldValByName("updatedAt", now, metaObject);
        }
    }

    @Override
    public void updateFill(MetaObject metaObject) {
        LocalDateTime now = LocalDateTime.now();
        if (hasSetter(metaObject, "updatedAt")) {
            setFieldValByName("updatedAt", now, metaObject);
        }
    }

    private boolean hasSetter(MetaObject metaObject, String fieldName) {
        try {
            return metaObject.hasSetter(fieldName);
        } catch (Exception ignored) {
            return false;
        }
    }
}