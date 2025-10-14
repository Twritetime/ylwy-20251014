package com.ylwy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ylwy.dto.UserRankDTO;
import com.ylwy.entity.Submission;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 代码提交记录Mapper接口
 */
@Mapper
public interface SubmissionMapper extends BaseMapper<Submission> {
    
    /**
     * 查询用户排行榜列表
     * @param limit 限制返回条数
     * @return 用户排行榜列表
     */
    @Select("SELECT " +
            "u.id as userId, " +
            "u.username, " +
            "u.nickname, " +
            "u.avatar, " +
            "COUNT(DISTINCT CASE WHEN s.status = 'AC' THEN s.question_id END) as acCount, " +
            "COUNT(s.id) as submitCount, " +
            "ROUND(COUNT(DISTINCT CASE WHEN s.status = 'AC' THEN s.question_id END) * 100.0 / NULLIF(COUNT(s.id), 0), 2) as acRate " +
            "FROM users u " +
            "LEFT JOIN submissions s ON u.id = s.user_id " +
            "WHERE u.status = 1 " +
            "GROUP BY u.id " +
            "ORDER BY acCount DESC, submitCount ASC " +
            "LIMIT #{limit}")
    List<UserRankDTO> selectUserRankList(int limit);
    
    /**
     * 查询单个用户的排名统计信息
     * @param userId 用户ID
     * @return 用户排名统计
     */
    @Select("SELECT " +
            "u.id as userId, " +
            "u.username, " +
            "u.nickname, " +
            "u.avatar, " +
            "COUNT(DISTINCT CASE WHEN s.status = 'AC' THEN s.question_id END) as acCount, " +
            "COUNT(s.id) as submitCount, " +
            "ROUND(COUNT(DISTINCT CASE WHEN s.status = 'AC' THEN s.question_id END) * 100.0 / NULLIF(COUNT(s.id), 0), 2) as acRate " +
            "FROM users u " +
            "LEFT JOIN submissions s ON u.id = s.user_id " +
            "WHERE u.id = #{userId} AND u.status = 1 " +
            "GROUP BY u.id")
    UserRankDTO selectUserRank(Long userId);
}
