package com.ylwy.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.ylwy.dto.*;
import com.ylwy.entity.Submission;
import com.ylwy.entity.User;
import com.ylwy.mapper.SubmissionMapper;
import com.ylwy.mapper.UserMapper;
import com.ylwy.util.JwtUtil;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 用户服务类
 */
@Service
public class UserService {
    
    @Autowired
    private UserMapper userMapper;
    
    @Autowired
    private SubmissionMapper submissionMapper;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    /**
     * 用户注册
     */
    public User register(RegisterRequest request) {
        // 检查用户名是否已存在
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        wrapper.eq("username", request.getUsername());
        if (userMapper.selectOne(wrapper) != null) {
            throw new RuntimeException("用户名已存在");
        }
        
        // 创建用户
        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setEmail(request.getEmail());
        user.setNickname(request.getNickname() != null ? request.getNickname() : request.getUsername());
        user.setRole("user");
        user.setStatus(1);
        
        userMapper.insert(user);
        return user;
    }
    
    /**
     * 用户登录
     */
    public LoginResponse login(LoginRequest request) {
        // 查询用户
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        wrapper.eq("username", request.getUsername());
        User user = userMapper.selectOne(wrapper);
        
        if (user == null) {
            throw new RuntimeException("用户名或密码错误");
        }
        
        // 验证密码
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("用户名或密码错误");
        }
        
        // 检查用户状态
        if (user.getStatus() == 0) {
            throw new RuntimeException("账号已被禁用");
        }
        
        // 生成Token
        String token = jwtUtil.generateToken(user.getId(), user.getUsername());
        
        return new LoginResponse(
                token,
                user.getId(),
                user.getUsername(),
                user.getNickname(),
                user.getAvatar()
        );
    }
    
    /**
     * 根据ID获取用户信息
     */
    public User getUserById(Long userId) {
        return userMapper.selectById(userId);
    }
    
    /**
     * 根据用户名获取用户
     */
    public User getUserByUsername(String username) {
        QueryWrapper<User> wrapper = new QueryWrapper<>();
        wrapper.eq("username", username);
        return userMapper.selectOne(wrapper);
    }
    
    /**
     * 获取用户个人信息
     */
    public UserProfileDTO getUserProfile(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        
        UserProfileDTO profile = new UserProfileDTO();
        BeanUtils.copyProperties(user, profile);
        
        // 查询统计数据
        QueryWrapper<Submission> wrapper = new QueryWrapper<>();
        wrapper.eq("user_id", userId);
        
        // 总提交数
        Long totalSubmissions = submissionMapper.selectCount(wrapper);
        profile.setTotalSubmissions(totalSubmissions.intValue());
        
        // AC题目数
        wrapper.clear();
        wrapper.eq("user_id", userId);
        wrapper.eq("status", "AC");
        wrapper.select("DISTINCT question_id");
        Long acCount = submissionMapper.selectCount(wrapper);
        profile.setTotalAC(acCount.intValue());
        
        // AC率
        if (totalSubmissions > 0) {
            profile.setAcRate(acCount * 100.0 / totalSubmissions);
        } else {
            profile.setAcRate(0.0);
        }
        
        // 总得分
        wrapper.clear();
        wrapper.eq("user_id", userId);
        wrapper.eq("status", "AC");
        wrapper.select("SUM(score) as totalScore");
        List<Submission> submissions = submissionMapper.selectList(wrapper);
        int totalScore = submissions.stream()
                .mapToInt(s -> s.getScore() != null ? s.getScore() : 0)
                .sum();
        profile.setTotalScore(totalScore);
        
        return profile;
    }
    
    /**
     * 更新个人信息
     */
    public User updateProfile(Long userId, UpdateProfileRequest request) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        
        if (request.getNickname() != null) {
            user.setNickname(request.getNickname());
        }
        if (request.getSignature() != null) {
            user.setSignature(request.getSignature());
        }
        if (request.getEmail() != null) {
            user.setEmail(request.getEmail());
        }
        
        userMapper.updateById(user);
        return user;
    }
    
    /**
     * 修改密码
     */
    public void updatePassword(Long userId, UpdatePasswordRequest request) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        
        // 验证旧密码
        if (!passwordEncoder.matches(request.getOldPassword(), user.getPassword())) {
            throw new RuntimeException("旧密码错误");
        }
        
        // 设置新密码
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userMapper.updateById(user);
    }
    
    /**
     * 获取用户统计数据
     */
    public UserStatisticsDTO getUserStatistics(Long userId) {
        UserStatisticsDTO statistics = new UserStatisticsDTO();
        
        // 总提交数
        QueryWrapper<Submission> wrapper = new QueryWrapper<>();
        wrapper.eq("user_id", userId);
        Long totalSubmissions = submissionMapper.selectCount(wrapper);
        statistics.setTotalSubmissions(totalSubmissions.intValue());
        
        // AC题目数
        wrapper.clear();
        wrapper.eq("user_id", userId);
        wrapper.eq("status", "AC");
        wrapper.select("DISTINCT question_id");
        Long acCount = submissionMapper.selectCount(wrapper);
        statistics.setAcCount(acCount.intValue());
        
        // AC率
        if (totalSubmissions > 0) {
            statistics.setAcRate(acCount * 100.0 / totalSubmissions);
        } else {
            statistics.setAcRate(0.0);
        }
        
        // 总得分
        wrapper.clear();
        wrapper.eq("user_id", userId);
        wrapper.eq("status", "AC");
        List<Submission> submissions = submissionMapper.selectList(wrapper);
        int totalScore = submissions.stream()
                .mapToInt(s -> s.getScore() != null ? s.getScore() : 0)
                .sum();
        statistics.setTotalScore(totalScore);
        
        // AC题目列表
        List<UserStatisticsDTO.ACQuestionDTO> acQuestions = userMapper.selectACQuestions(userId);
        statistics.setAcQuestions(acQuestions);
        
        // 日历热力图数据
        List<Map<String, Object>> calendarDataList = userMapper.selectCalendarData(userId);
        Map<String, Integer> calendarData = new HashMap<>();
        for (Map<String, Object> item : calendarDataList) {
            String date = item.get("date").toString();
            Integer count = ((Number) item.get("count")).intValue();
            calendarData.put(date, count);
        }
        statistics.setCalendarData(calendarData);
        
        // 科目统计
        List<UserStatisticsDTO.SubjectStatDTO> subjectStats = userMapper.selectSubjectStats(userId);
        statistics.setSubjectStats(subjectStats);
        
        // 刷题趋势
        List<UserStatisticsDTO.TrendDataDTO> trendData = userMapper.selectTrendData(userId);
        statistics.setTrendData(trendData);
        
        return statistics;
    }
}
