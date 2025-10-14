package com.ylwy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ylwy.entity.Submission;
import org.apache.ibatis.annotations.Mapper;

/**
 * 代码提交记录Mapper接口
 */
@Mapper
public interface SubmissionMapper extends BaseMapper<Submission> {
}
