package com.ylwy.judge;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 判题服务器启动类
 */
@SpringBootApplication
public class JudgeServerApplication {
    
    public static void main(String[] args) {
        SpringApplication.run(JudgeServerApplication.class, args);
        System.out.println("========================================");
        System.out.println("  研路无忧判题服务器启动成功！");
        System.out.println("  API地址: http://localhost:8081");
        System.out.println("========================================");
    }
}
