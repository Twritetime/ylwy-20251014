package com.ylwy.controller;

import com.ylwy.common.Result;
import com.ylwy.entity.Subject;
import com.ylwy.mapper.SubjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 测试控制器
 */
@RestController
@RequestMapping("/test")
public class TestController {
    
    @Autowired
    private SubjectMapper subjectMapper;
    
    /**
     * 测试接口
     */
    @GetMapping("/hello")
    public Result<String> hello() {
        return Result.success("Hello, YLWY!");
    }
    
    /**
     * 测试数据库连接
     */
    @GetMapping("/db")
    public Result<List<Subject>> testDb() {
        List<Subject> subjects = subjectMapper.selectList(null);
        return Result.success("数据库连接成功", subjects);
    }
}
