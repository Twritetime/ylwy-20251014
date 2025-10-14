package com.ylwy.controller;

import com.ylwy.common.Result;
import com.ylwy.dto.UserRankDTO;
import com.ylwy.service.RankService;
import com.ylwy.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 排行榜控制器
 */
@RestController
@RequestMapping("/rank")
public class RankController {
    
    @Autowired
    private RankService rankService;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    /**
     * 获取排行榜列表（默认前100名）
     */
    @GetMapping("/list")
    public Result<List<UserRankDTO>> getRankList(
            @RequestParam(defaultValue = "100") int limit) {
        try {
            // 限制最大查询数量
            if (limit > 500) {
                limit = 500;
            }
            List<UserRankDTO> rankList = rankService.getUserRankList(limit);
            return Result.success(rankList);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取排行榜失败：" + e.getMessage());
        }
    }
    
    /**
     * 获取我的排名信息
     */
    @GetMapping("/my")
    public Result<UserRankDTO> getMyRank(
            @RequestHeader("Authorization") String token) {
        try {
            if (token.startsWith("Bearer ")) {
                token = token.substring(7);
            }
            Long userId = jwtUtil.getUserIdFromToken(token);
            
            UserRankDTO userRank = rankService.getUserRank(userId);
            if (userRank == null) {
                return Result.error("未找到用户信息");
            }
            return Result.success(userRank);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取排名失败：" + e.getMessage());
        }
    }
}
