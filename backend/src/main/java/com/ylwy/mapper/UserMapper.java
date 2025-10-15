package com.ylwy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ylwy.dto.UserStatisticsDTO;
import com.ylwy.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

/**
 * 用户Mapper接口
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {
    
    /**
     * 查询用户AC的题目列表
     */
    @Select("SELECT " +
            "s.question_id as questionId, " +
            "q.question_no as questionNo, " +
            "q.title, " +
            "q.difficulty, " +
            "MIN(s.created_at) as createdAt " +
            "FROM submissions s " +
            "INNER JOIN questions q ON s.question_id = q.id " +
            "WHERE s.user_id = #{userId} AND s.status = 'AC' " +
            "GROUP BY s.question_id, q.question_no, q.title, q.difficulty " +
            "ORDER BY MIN(s.created_at) DESC")
    List<UserStatisticsDTO.ACQuestionDTO> selectACQuestions(Long userId);
    
    /**
     * 查询用户日历热力图数据（最近一年）
     */
    @Select("SELECT " +
            "DATE(created_at) as date, " +
            "COUNT(*) as count " +
            "FROM submissions " +
            "WHERE user_id = #{userId} " +
            "AND created_at >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR) " +
            "GROUP BY DATE(created_at)")
    List<Map<String, Object>> selectCalendarData(Long userId);
    
    /**
     * 查询用户按科目统计的AC数量
     */
    @Select("SELECT " +
            "sub.name as subjectName, " +
            "COUNT(DISTINCT s.question_id) as acCount " +
            "FROM submissions s " +
            "INNER JOIN questions q ON s.question_id = q.id " +
            "INNER JOIN subjects sub ON q.subject_id = sub.id " +
            "WHERE s.user_id = #{userId} AND s.status = 'AC' " +
            "GROUP BY sub.id, sub.name")
    List<UserStatisticsDTO.SubjectStatDTO> selectSubjectStats(Long userId);
    
    /**
     * 查询用户最近30天的AC趋势
     */
    @Select("SELECT " +
            "DATE(s.created_at) as date, " +
            "COUNT(DISTINCT s.question_id) as acCount " +
            "FROM submissions s " +
            "WHERE s.user_id = #{userId} " +
            "AND s.status = 'AC' " +
            "AND s.created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) " +
            "GROUP BY DATE(s.created_at) " +
            "ORDER BY DATE(s.created_at)")
    List<UserStatisticsDTO.TrendDataDTO> selectTrendData(Long userId);
}
