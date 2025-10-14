package com.ylwy;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 研路无忧后端启动类
 */
@SpringBootApplication
@MapperScan("com.ylwy.mapper")
public class YlwyApplication {
    public static void main(String[] args) {
        SpringApplication.run(YlwyApplication.class, args);
        System.out.println("========================================");
        System.out.println("  研路无忧后端服务启动成功！");
        System.out.println("  API地址: http://localhost:8080/api");
        System.out.println("========================================");
    }
}
