package com.ylwy.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ylwy.entity.Question;
import com.ylwy.entity.QuestionOption;
import com.ylwy.entity.TestCase;
import com.ylwy.mapper.QuestionMapper;
import com.ylwy.mapper.QuestionOptionMapper;
import com.ylwy.mapper.TestCaseMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 题目服务类
 */
@Service
public class QuestionService {
    
    @Autowired
    private QuestionMapper questionMapper;
    
    @Autowired
    private QuestionOptionMapper questionOptionMapper;
    
    @Autowired
    private TestCaseMapper testCaseMapper;
    
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
     * 根据ID获取题目详情（包含选项和测试用例）
     */
    public Question getQuestionById(Long id) {
        Question question = questionMapper.selectById(id);
        if (question == null) {
            return null;
        }
        
        // 如果是选择题，查询选项
        if ("CHOICE".equals(question.getType())) {
            QueryWrapper<QuestionOption> optionWrapper = new QueryWrapper<>();
            optionWrapper.eq("question_id", id);
            optionWrapper.orderByAsc("option_key");
            List<QuestionOption> options = questionOptionMapper.selectList(optionWrapper);
            question.setOptions(options);
        }
        
        // 如果是编程题，查询测试用例（只返回示例用例）
        if ("CODE".equals(question.getType())) {
            QueryWrapper<TestCase> testCaseWrapper = new QueryWrapper<>();
            testCaseWrapper.eq("question_id", id);
            testCaseWrapper.eq("is_sample", 1); // 只返回示例用例
            testCaseWrapper.orderByAsc("sort_order");
            List<TestCase> testCases = testCaseMapper.selectList(testCaseWrapper);
            question.setTestCases(testCases);
        }
        
        return question;
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
