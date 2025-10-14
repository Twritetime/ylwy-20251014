package com.ylwy.judge.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.boot.context.properties.ConfigurationProperties;
import lombok.Data;

/**
 * 判题配置类
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "judge")
public class JudgeConfig {
    
    /**
     * Docker主机地址
     */
    private String dockerHost = "unix:///var/run/docker.sock";
    
    /**
     * 默认时间限制 (毫秒)
     */
    private Integer defaultTimeLimit = 1000;
    
    /**
     * 默认内存限制 (KB)
     */
    private Integer defaultMemoryLimit = 262144; // 256MB
    
    /**
     * 工作目录
     */
    private String workDir = "/tmp/ylwy-judge";
    
    /**
     * 是否启用Docker
     */
    private Boolean enableDocker = false; // 默认false,后续改为true
    
    /**
     * C++编译命令
     */
    private String cppCompileCmd = "g++ -std=c++17 -O2 -o Main Main.cpp";
    
    /**
     * Java编译命令
     */
    private String javaCompileCmd = "javac Main.java";
    
    /**
     * Python执行命令
     */
    private String pythonRunCmd = "python3 Main.py";
}
