package com.ylwy.controller;

import com.ylwy.common.Result;
import com.ylwy.dto.UpdatePasswordRequest;
import com.ylwy.dto.UpdateProfileRequest;
import com.ylwy.dto.UserProfileDTO;
import com.ylwy.dto.UserStatisticsDTO;
import com.ylwy.entity.User;
import com.ylwy.service.UserService;
import com.ylwy.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;

/**
 * 用户个人中心Controller
 */
@RestController
@RequestMapping("/users")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    /**
     * 获取当前用户个人信息
     */
    @GetMapping("/profile")
    public Result<UserProfileDTO> getProfile(HttpServletRequest request) {
        Long userId = getUserIdFromToken(request);
        UserProfileDTO profile = userService.getUserProfile(userId);
        return Result.success(profile);
    }
    
    /**
     * 更新个人信息
     */
    @PutMapping("/profile")
    public Result<User> updateProfile(HttpServletRequest request, 
                                      @RequestBody UpdateProfileRequest updateRequest) {
        Long userId = getUserIdFromToken(request);
        User user = userService.updateProfile(userId, updateRequest);
        return Result.success(user);
    }
    
    /**
     * 修改密码
     */
    @PutMapping("/password")
    public Result<String> updatePassword(HttpServletRequest request,
                                        @RequestBody UpdatePasswordRequest updateRequest) {
        Long userId = getUserIdFromToken(request);
        userService.updatePassword(userId, updateRequest);
        return Result.success("密码修改成功");
    }
    
    /**
     * 获取用户统计数据
     */
    @GetMapping("/statistics")
    public Result<UserStatisticsDTO> getStatistics(HttpServletRequest request) {
        Long userId = getUserIdFromToken(request);
        UserStatisticsDTO statistics = userService.getUserStatistics(userId);
        return Result.success(statistics);
    }
    
    /**
     * 从Token中获取用户ID
     */
    private Long getUserIdFromToken(HttpServletRequest request) {
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        return jwtUtil.getUserIdFromToken(token);
    }
}
