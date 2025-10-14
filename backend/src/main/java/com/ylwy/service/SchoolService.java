package com.ylwy.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ylwy.entity.School;
import com.ylwy.mapper.SchoolMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 学校服务类
 */
@Service
public class SchoolService {
    
    @Autowired
    private SchoolMapper schoolMapper;
    
    /**
     * 分页查询学校列表
     */
    public Page<School> getSchoolList(int current, int size, String province) {
        Page<School> page = new Page<>(current, size);
        QueryWrapper<School> wrapper = new QueryWrapper<>();
        
        if (province != null && !province.isEmpty()) {
            wrapper.eq("province", province);
        }
        
        // 按热门指数倒序
        wrapper.orderByDesc("hot_index");
        
        return schoolMapper.selectPage(page, wrapper);
    }
    
    /**
     * 获取学校详情
     */
    public School getSchoolById(Long id) {
        return schoolMapper.selectById(id);
    }
}
