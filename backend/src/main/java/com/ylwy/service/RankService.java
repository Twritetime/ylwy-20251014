package com.ylwy.service;

import com.ylwy.dto.UserRankDTO;
import com.ylwy.mapper.SubmissionMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 排行榜服务类
 */
@Service
public class RankService {
    
    @Autowired
    private SubmissionMapper submissionMapper;
    
    /**
     * 获取用户排行榜列表
     * @param limit 限制返回条数
     * @return 用户排行榜列表（带排名）
     */
    public List<UserRankDTO> getUserRankList(int limit) {
        List<UserRankDTO> rankList = submissionMapper.selectUserRankList(limit);
        
        // 设置排名
        for (int i = 0; i < rankList.size(); i++) {
            rankList.get(i).setRank(i + 1);
        }
        
        return rankList;
    }
    
    /**
     * 获取单个用户的排名信息
     * @param userId 用户ID
     * @return 用户排名信息
     */
    public UserRankDTO getUserRank(Long userId) {
        // 获取用户统计信息
        UserRankDTO userRank = submissionMapper.selectUserRank(userId);
        if (userRank == null) {
            return null;
        }
        
        // 获取完整排行榜计算排名
        List<UserRankDTO> allRanks = submissionMapper.selectUserRankList(10000);
        for (int i = 0; i < allRanks.size(); i++) {
            if (allRanks.get(i).getUserId().equals(userId)) {
                userRank.setRank(i + 1);
                break;
            }
        }
        
        return userRank;
    }
}
