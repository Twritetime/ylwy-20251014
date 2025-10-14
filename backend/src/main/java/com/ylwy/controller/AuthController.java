package com.ylwy.controller;

import com.ylwy.common.Result;
import com.ylwy.dto.LoginRequest;
import com.ylwy.dto.LoginResponse;
import com.ylwy.dto.RegisterRequest;
import com.ylwy.entity.User;
import com.ylwy.service.UserService;
import com.ylwy.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

/**
 * 认证控制器
 */
@RestController
@RequestMapping("/auth")
public class AuthController {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    /**
     * 用户注册
     */
    @PostMapping("/register")
    public Result<User> register(@Valid @RequestBody RegisterRequest request) {
        try {
            User user = userService.register(request);
            // 清空密码
            user.setPassword(null);
            return Result.success("注册成功", user);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    /**
     * 用户登录
     */
    @PostMapping("/login")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        try {
            LoginResponse response = userService.login(request);
            return Result.success("登录成功", response);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    /**
     * 获取当前用户信息
     */
    @GetMapping("/current")
    public Result<User> getCurrentUser(@RequestHeader("Authorization") String token) {
        try {
            // 去掉Bearer前缀
            if (token.startsWith("Bearer ")) {
                token = token.substring(7);
            }
            
            Long userId = jwtUtil.getUserIdFromToken(token);
            User user = userService.getUserById(userId);
            
            if (user == null) {
                return Result.error("用户不存在");
            }
            
            // 清空密码
            user.setPassword(null);
            return Result.success(user);
        } catch (Exception e) {
            return Result.error("获取用户信息失败");
        }
    }
}
