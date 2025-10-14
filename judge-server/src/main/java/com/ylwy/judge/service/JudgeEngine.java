package com.ylwy.judge.service;

import com.ylwy.judge.config.JudgeConfig;
import com.ylwy.judge.dto.JudgeRequest;
import com.ylwy.judge.dto.JudgeResponse;
import com.ylwy.judge.enums.JudgeStatus;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * 判题引擎服务
 */
@Slf4j
@Service
public class JudgeEngine {
    
    @Autowired
    private JudgeConfig judgeConfig;
    
    /**
     * 执行判题
     */
    public JudgeResponse judge(JudgeRequest request) {
        log.info("开始判题，提交ID: {}, 语言: {}", request.getSubmissionId(), request.getLanguage());
        
        JudgeResponse.JudgeResponseBuilder responseBuilder = JudgeResponse.builder()
                .submissionId(request.getSubmissionId())
                .totalCount(request.getTestCases().size())
                .passCount(0)
                .timeUsed(0)
                .memoryUsed(0);
        
        try {
            // 1. 编译代码
            CompileResult compileResult = compile(request);
            if (!compileResult.success) {
                return responseBuilder
                        .status(JudgeStatus.CE.getCode())
                        .message(JudgeStatus.CE.getMessage())
                        .errorMessage(compileResult.errorMessage)
                        .compileOutput(compileResult.output)
                        .build();
            }
            
            // 2. 运行测试用例
            int passCount = 0;
            int maxTimeUsed = 0;
            int maxMemoryUsed = 0;
            
            for (JudgeRequest.TestCase testCase : request.getTestCases()) {
                RunResult runResult = runTestCase(request, testCase, compileResult.workDir);
                
                if (!runResult.success) {
                    // 运行失败（TLE, MLE, RE等）
                    return responseBuilder
                            .status(runResult.status.getCode())
                            .message(runResult.status.getMessage())
                            .errorMessage(runResult.errorMessage)
                            .timeUsed(runResult.timeUsed)
                            .memoryUsed(runResult.memoryUsed)
                            .passCount(passCount)
                            .build();
                }
                
                // 对比输出
                String actualOutput = runResult.output.trim();
                String expectedOutput = testCase.getExpectedOutput().trim();
                
                if (actualOutput.equals(expectedOutput)) {
                    passCount++;
                } else {
                    // 答案错误
                    return responseBuilder
                            .status(JudgeStatus.WA.getCode())
                            .message(JudgeStatus.WA.getMessage())
                            .errorMessage("Expected: " + expectedOutput + ", but got: " + actualOutput)
                            .timeUsed(runResult.timeUsed)
                            .memoryUsed(runResult.memoryUsed)
                            .passCount(passCount)
                            .build();
                }
                
                maxTimeUsed = Math.max(maxTimeUsed, runResult.timeUsed);
                maxMemoryUsed = Math.max(maxMemoryUsed, runResult.memoryUsed);
            }
            
            // 3. 所有测试用例通过
            return responseBuilder
                    .status(JudgeStatus.AC.getCode())
                    .message(JudgeStatus.AC.getMessage())
                    .timeUsed(maxTimeUsed)
                    .memoryUsed(maxMemoryUsed)
                    .passCount(passCount)
                    .build();
            
        } catch (Exception e) {
            log.error("判题系统错误", e);
            return responseBuilder
                    .status(JudgeStatus.SE.getCode())
                    .message(JudgeStatus.SE.getMessage())
                    .errorMessage(e.getMessage())
                    .build();
        }
    }
    
    /**
     * 编译代码
     */
    private CompileResult compile(JudgeRequest request) {
        String language = request.getLanguage().toLowerCase();
        String workDir = judgeConfig.getWorkDir() + "/" + UUID.randomUUID();
        
        try {
            // 创建工作目录
            Files.createDirectories(Paths.get(workDir));
            
            // 写入代码文件
            String fileName = getFileName(language);
            Path codePath = Paths.get(workDir, fileName);
            Files.writeString(codePath, request.getCode());
            
            // Python不需要编译
            if ("python".equals(language)) {
                return new CompileResult(true, "", "", workDir);
            }
            
            // 编译命令
            String compileCmd = getCompileCommand(language, workDir);
            if (compileCmd == null) {
                return new CompileResult(false, "不支持的语言: " + language, "", workDir);
            }
            
            // 执行编译
            log.info("编译命令: {}", compileCmd);
            Process process = Runtime.getRuntime().exec(compileCmd, null, new File(workDir));
            
            // 等待编译完成（最多10秒）
            boolean finished = process.waitFor(10, TimeUnit.SECONDS);
            if (!finished) {
                process.destroy();
                return new CompileResult(false, "编译超时", "", workDir);
            }
            
            // 读取编译输出
            String output = readStream(process.getInputStream());
            String error = readStream(process.getErrorStream());
            
            if (process.exitValue() != 0) {
                return new CompileResult(false, error, output, workDir);
            }
            
            return new CompileResult(true, "", output, workDir);
            
        } catch (Exception e) {
            log.error("编译失败", e);
            return new CompileResult(false, e.getMessage(), "", workDir);
        }
    }
    
    /**
     * 运行测试用例
     */
    private RunResult runTestCase(JudgeRequest request, JudgeRequest.TestCase testCase, String workDir) {
        String language = request.getLanguage().toLowerCase();
        
        try {
            // 运行命令
            String runCmd = getRunCommand(language, workDir);
            if (runCmd == null) {
                return new RunResult(false, JudgeStatus.SE, "不支持的语言", "", 0, 0);
            }
            
            log.info("运行命令: {}", runCmd);
            Process process = Runtime.getRuntime().exec(runCmd, null, new File(workDir));
            
            // 写入输入数据
            if (testCase.getInput() != null && !testCase.getInput().isEmpty()) {
                try (OutputStream os = process.getOutputStream()) {
                    os.write(testCase.getInput().getBytes());
                    os.flush();
                }
            }
            
            // 等待运行完成（带超时）
            long startTime = System.currentTimeMillis();
            int timeLimit = request.getTimeLimit();
            boolean finished = process.waitFor(timeLimit, TimeUnit.MILLISECONDS);
            long endTime = System.currentTimeMillis();
            int timeUsed = (int) (endTime - startTime);
            
            if (!finished) {
                // 超时
                process.destroy();
                return new RunResult(false, JudgeStatus.TLE, "运行超时", "", timeUsed, 0);
            }
            
            // 检查退出码
            if (process.exitValue() != 0) {
                String error = readStream(process.getErrorStream());
                return new RunResult(false, JudgeStatus.RE, error, "", timeUsed, 0);
            }
            
            // 读取输出
            String output = readStream(process.getInputStream());
            
            return new RunResult(true, JudgeStatus.AC, "", output, timeUsed, 0);
            
        } catch (Exception e) {
            log.error("运行失败", e);
            return new RunResult(false, JudgeStatus.RE, e.getMessage(), "", 0, 0);
        }
    }
    
    /**
     * 获取文件名
     */
    private String getFileName(String language) {
        switch (language) {
            case "cpp":
                return "Main.cpp";
            case "java":
                return "Main.java";
            case "python":
                return "Main.py";
            default:
                return "Main.txt";
        }
    }
    
    /**
     * 获取编译命令
     */
    private String getCompileCommand(String language, String workDir) {
        switch (language) {
            case "cpp":
                return "g++ -std=c++17 -O2 -o " + workDir + "/Main " + workDir + "/Main.cpp";
            case "java":
                return "javac " + workDir + "/Main.java";
            default:
                return null;
        }
    }
    
    /**
     * 获取运行命令
     */
    private String getRunCommand(String language, String workDir) {
        switch (language) {
            case "cpp":
                return workDir + "/Main";
            case "java":
                return "java -cp " + workDir + " Main";
            case "python":
                return "python3 " + workDir + "/Main.py";
            default:
                return null;
        }
    }
    
    /**
     * 读取流内容
     */
    private String readStream(InputStream is) throws IOException {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line).append("\n");
            }
            return sb.toString();
        }
    }
    
    /**
     * 编译结果内部类
     */
    private static class CompileResult {
        boolean success;
        String errorMessage;
        String output;
        String workDir;
        
        CompileResult(boolean success, String errorMessage, String output, String workDir) {
            this.success = success;
            this.errorMessage = errorMessage;
            this.output = output;
            this.workDir = workDir;
        }
    }
    
    /**
     * 运行结果内部类
     */
    private static class RunResult {
        boolean success;
        JudgeStatus status;
        String errorMessage;
        String output;
        int timeUsed;
        int memoryUsed;
        
        RunResult(boolean success, JudgeStatus status, String errorMessage, String output, int timeUsed, int memoryUsed) {
            this.success = success;
            this.status = status;
            this.errorMessage = errorMessage;
            this.output = output;
            this.timeUsed = timeUsed;
            this.memoryUsed = memoryUsed;
        }
    }
}
