package com.ylwy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ylwy.entity.Question;
import org.apache.ibatis.annotations.Mapper;

/**
 * 题目Mapper接口
 */
@Mapper
public interface QuestionMapper extends BaseMapper<Question> {
}
