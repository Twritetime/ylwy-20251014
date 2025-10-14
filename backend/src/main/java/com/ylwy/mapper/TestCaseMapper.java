package com.ylwy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ylwy.entity.TestCase;
import org.apache.ibatis.annotations.Mapper;

/**
 * 测试用例Mapper接口
 */
@Mapper
public interface TestCaseMapper extends BaseMapper<TestCase> {
}
