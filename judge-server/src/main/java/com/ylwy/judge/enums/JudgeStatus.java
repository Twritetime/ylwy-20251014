package com.ylwy.judge.enums;

/**
 * 判题状态枚举
 */
public enum JudgeStatus {
    
    /**
     * 等待判题
     */
    PENDING("pending", "等待判题"),
    
    /**
     * 判题中
     */
    JUDGING("judging", "判题中"),
    
    /**
     * 答案正确 (Accepted)
     */
    AC("ac", "答案正确"),
    
    /**
     * 答案错误 (Wrong Answer)
     */
    WA("wa", "答案错误"),
    
    /**
     * 超时 (Time Limit Exceeded)
     */
    TLE("tle", "超时"),
    
    /**
     * 内存超限 (Memory Limit Exceeded)
     */
    MLE("mle", "内存超限"),
    
    /**
     * 运行时错误 (Runtime Error)
     */
    RE("re", "运行时错误"),
    
    /**
     * 编译错误 (Compile Error)
     */
    CE("ce", "编译错误"),
    
    /**
     * 系统错误 (System Error)
     */
    SE("se", "系统错误");
    
    private final String code;
    private final String message;
    
    JudgeStatus(String code, String message) {
        this.code = code;
        this.message = message;
    }
    
    public String getCode() {
        return code;
    }
    
    public String getMessage() {
        return message;
    }
}
