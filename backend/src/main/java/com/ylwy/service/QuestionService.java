package com.ylwy.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ylwy.entity.Question;
import com.ylwy.mapper.QuestionMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 题目服务类
 */
@Service
public class QuestionService {
    
    @Autowired
    private QuestionMapper questionMapper;
    
    /**
     * 分页查询题目列表
     */
    public Page<Question> getQuestionList(int current, int size, String type, String difficulty, Long subjectId) {
        Page<Question> page = new Page<>(current, size);
        QueryWrapper<Question> wrapper = new QueryWrapper<>();
        
        // 条件筛选
        if (type != null && !type.isEmpty()) {
            wrapper.eq("type", type);
        }
        if (difficulty != null && !difficulty.isEmpty()) {
            wrapper.eq("difficulty", difficulty);
        }
        if (subjectId != null) {
            wrapper.eq("subject_id", subjectId);
        }
        
        // 按创建时间倒序
        wrapper.orderByDesc("created_at");
        
        return questionMapper.selectPage(page, wrapper);
    }
    
    /**
     * 根据ID获取题目详情
     */
    public Question getQuestionById(Long id) {
        return questionMapper.selectById(id);
    }
    
    /**
     * 根据题目编号获取题目
     */
    public Question getQuestionByNo(String questionNo) {
        QueryWrapper<Question> wrapper = new QueryWrapper<>();
        wrapper.eq("question_no", questionNo);
        return questionMapper.selectOne(wrapper);
    }
}
