package com.ylwy.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ylwy.common.Result;
import com.ylwy.entity.School;
import com.ylwy.service.SchoolService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 学校控制器
 */
@RestController
@RequestMapping("/schools")
public class SchoolController {
    
    @Autowired
    private SchoolService schoolService;
    
    /**
     * 分页查询学校列表
     */
    @GetMapping("/list")
    public Result<Page<School>> getSchoolList(
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String province
    ) {
        Page<School> page = schoolService.getSchoolList(current, size, province);
        return Result.success(page);
    }
    
    /**
     * 获取学校详情
     */
    @GetMapping("/{id}")
    public Result<School> getSchoolById(@PathVariable Long id) {
        School school = schoolService.getSchoolById(id);
        if (school == null) {
            return Result.error("学校不存在");
        }
        return Result.success(school);
    }
}
