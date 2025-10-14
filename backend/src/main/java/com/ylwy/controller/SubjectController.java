package com.ylwy.controller;

import com.ylwy.common.Result;
import com.ylwy.entity.Subject;
import com.ylwy.mapper.SubjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 科目控制器
 */
@RestController
@RequestMapping("/subjects")
public class SubjectController {
    
    @Autowired
    private SubjectMapper subjectMapper;
    
    /**
     * 获取所有科目
     */
    @GetMapping("/list")
    public Result<List<Subject>> getSubjectList() {
        List<Subject> subjects = subjectMapper.selectList(null);
        return Result.success(subjects);
    }
}
