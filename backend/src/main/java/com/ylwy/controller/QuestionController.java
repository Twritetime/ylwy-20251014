package com.ylwy.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ylwy.common.Result;
import com.ylwy.entity.Question;
import com.ylwy.service.QuestionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 题目控制器
 */
@RestController
@RequestMapping("/questions")
public class QuestionController {
    
    @Autowired
    private QuestionService questionService;
    
    /**
     * 分页查询题目列表
     */
    @GetMapping("/list")
    public Result<Page<Question>> getQuestionList(
            @RequestParam(defaultValue = "1") int current,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) String difficulty,
            @RequestParam(required = false) Long subjectId
    ) {
        Page<Question> page = questionService.getQuestionList(current, size, type, difficulty, subjectId);
        return Result.success(page);
    }
    
    /**
     * 获取题目详情
     */
    @GetMapping("/{id}")
    public Result<Question> getQuestionById(@PathVariable Long id) {
        Question question = questionService.getQuestionById(id);
        if (question == null) {
            return Result.error("题目不存在");
        }
        return Result.success(question);
    }
}
