package com.ylwy.client;

import com.google.gson.Gson;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.List;

/**
 * 判题服务HTTP客户端
 */
@Slf4j
@Component
public class JudgeClient {
    
    @Value("${judge.server.url:http://localhost:8081}")
    private String judgeServerUrl;
    
    private final RestTemplate restTemplate = new RestTemplate();
    private final Gson gson = new Gson();
    
    /**
     * 执行判题
     */
    public JudgeResponse executeJudge(JudgeRequest request) {
        try {
            String url = judgeServerUrl + "/judge/execute";
            log.info("调用判题服务: {}", url);
            
            return restTemplate.postForObject(url, request, JudgeResponse.class);
        } catch (Exception e) {
            log.error("调用判题服务失败", e);
            
            // 返回系统错误
            JudgeResponse errorResponse = new JudgeResponse();
            errorResponse.setSubmissionId(request.getSubmissionId());
            errorResponse.setStatus("se");
            errorResponse.setMessage("系统错误");
            errorResponse.setErrorMessage(e.getMessage());
            errorResponse.setTotalCount(request.getTestCases().size());
            errorResponse.setPassCount(0);
            return errorResponse;
        }
    }
    
    /**
     * 健康检查
     */
    public boolean isHealthy() {
        try {
            String url = judgeServerUrl + "/judge/health";
            String response = restTemplate.getForObject(url, String.class);
            return response != null && response.contains("running");
        } catch (Exception e) {
            log.warn("判题服务器不可用: {}", e.getMessage());
            return false;
        }
    }
    
    /**
     * 判题请求DTO
     */
    @Data
    public static class JudgeRequest {
        private Long submissionId;
        private Long questionId;
        private String language;
        private String code;
        private List<TestCase> testCases;
        private Integer timeLimit = 1000;
        private Integer memoryLimit = 262144;
        
        @Data
        public static class TestCase {
            private String input;
            private String expectedOutput;
        }
    }
    
    /**
     * 判题响应DTO
     */
    @Data
    public static class JudgeResponse {
        private Long submissionId;
        private String status;
        private String message;
        private Integer timeUsed;
        private Integer memoryUsed;
        private Integer passCount;
        private Integer totalCount;
        private String errorMessage;
        private String compileOutput;
    }
}
