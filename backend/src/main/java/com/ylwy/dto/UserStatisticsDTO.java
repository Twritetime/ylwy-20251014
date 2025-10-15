package com.ylwy.dto;

import lombok.Data;
import java.util.List;
import java.util.Map;

/**
 * 用户统计数据DTO
 */
@Data
public class UserStatisticsDTO {
    /**
     * 总提交数
     */
    private Integer totalSubmissions;
    
    /**
     * AC题目数
     */
    private Integer acCount;
    
    /**
     * AC率
     */
    private Double acRate;
    
    /**
     * 总得分
     */
    private Integer totalScore;
    
    /**
     * AC题目列表
     */
    private List<ACQuestionDTO> acQuestions;
    
    /**
     * 日历热力图数据 (日期 -> 提交次数)
     */
    private Map<String, Integer> calendarData;
    
    /**
     * 科目统计数据
     */
    private List<SubjectStatDTO> subjectStats;
    
    /**
     * 刷题趋势数据 (最近30天)
     */
    private List<TrendDataDTO> trendData;
    
    /**
     * AC题目内部类
     */
    @Data
    public static class ACQuestionDTO {
        private Long questionId;
        private String questionNo;
        private String title;
        private String difficulty;
        private String createdAt;
    }
    
    /**
     * 科目统计内部类
     */
    @Data
    public static class SubjectStatDTO {
        private String subjectName;
        private Integer acCount;
    }
    
    /**
     * 趋势数据内部类
     */
    @Data
    public static class TrendDataDTO {
        private String date;
        private Integer acCount;
    }
}
