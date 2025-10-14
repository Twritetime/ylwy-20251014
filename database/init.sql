-- ============================================
-- 研路无忧考研服务平台 - 数据库初始化脚本
-- ============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS ylwy_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE ylwy_db;

-- ============================================
-- 1. 用户表 (users)
-- ============================================
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
  `password` VARCHAR(255) NOT NULL COMMENT '密码(BCrypt加密)',
  `email` VARCHAR(100) COMMENT '邮箱',
  `phone` VARCHAR(20) COMMENT '手机号',
  `nickname` VARCHAR(50) COMMENT '昵称',
  `avatar` VARCHAR(255) DEFAULT 'https://avatar.default.com/default.png' COMMENT '头像URL',
  `school_from` VARCHAR(100) COMMENT '本科院校',
  `school_target` VARCHAR(100) COMMENT '目标院校',
  `signature` VARCHAR(255) COMMENT '个性签名',
  `role` VARCHAR(20) DEFAULT 'user' COMMENT '角色(user/admin)',
  `status` TINYINT DEFAULT 1 COMMENT '状态(0禁用/1启用)',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  INDEX `idx_username` (`username`),
  INDEX `idx_email` (`email`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- ============================================
-- 2. 学校表 (schools)
-- ============================================
DROP TABLE IF EXISTS `schools`;
CREATE TABLE `schools` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '学校ID',
  `name` VARCHAR(100) NOT NULL COMMENT '学校名称',
  `province` VARCHAR(50) COMMENT '省份',
  `city` VARCHAR(50) COMMENT '城市',
  `level` VARCHAR(20) COMMENT '学校层次(985/211/双一流)',
  `logo` VARCHAR(255) COMMENT '学校logo',
  `description` TEXT COMMENT '学校简介',
  `hot_index` INT DEFAULT 0 COMMENT '热门指数',
  `view_count` INT DEFAULT 0 COMMENT '浏览次数',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  INDEX `idx_name` (`name`),
  INDEX `idx_province` (`province`),
  INDEX `idx_hot_index` (`hot_index` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='学校表';

-- ============================================
-- 3. 科目表 (subjects)
-- ============================================
DROP TABLE IF EXISTS `subjects`;
CREATE TABLE `subjects` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '科目ID',
  `name` VARCHAR(50) NOT NULL COMMENT '科目名称',
  `code` VARCHAR(20) NOT NULL UNIQUE COMMENT '科目代码',
  `description` VARCHAR(255) COMMENT '科目描述',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_code` (`code`),
  INDEX `idx_sort` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='科目表';

-- ============================================
-- 4. 题目分类表 (question_categories)
-- ============================================
DROP TABLE IF EXISTS `question_categories`;
CREATE TABLE `question_categories` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` VARCHAR(50) NOT NULL COMMENT '分类名称',
  `parent_id` BIGINT DEFAULT 0 COMMENT '父分类ID(0表示顶级)',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_parent` (`parent_id`),
  INDEX `idx_sort` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='题目分类表';

-- ============================================
-- 5. 题目表 (questions)
-- ============================================
DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `question_no` VARCHAR(20) NOT NULL UNIQUE COMMENT '题目编号',
  `title` VARCHAR(255) NOT NULL COMMENT '题目标题',
  `content` TEXT NOT NULL COMMENT '题目内容',
  `type` VARCHAR(20) NOT NULL COMMENT '题目类型(choice/program)',
  `difficulty` VARCHAR(20) DEFAULT 'medium' COMMENT '难度(easy/medium/hard)',
  `subject_id` BIGINT COMMENT '科目ID',
  `category_id` BIGINT COMMENT '分类ID',
  `school_source` VARCHAR(100) COMMENT '来源学校',
  `time_limit` INT DEFAULT 1000 COMMENT '时间限制(ms，仅编程题)',
  `memory_limit` INT DEFAULT 256 COMMENT '内存限制(MB，仅编程题)',
  `pass_rate` DECIMAL(5,2) DEFAULT 0.00 COMMENT '通过率(%)',
  `submit_count` INT DEFAULT 0 COMMENT '提交次数',
  `accept_count` INT DEFAULT 0 COMMENT '通过次数',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_question_no` (`question_no`),
  INDEX `idx_type` (`type`),
  INDEX `idx_difficulty` (`difficulty`),
  INDEX `idx_subject` (`subject_id`),
  INDEX `idx_category` (`category_id`),
  INDEX `idx_pass_rate` (`pass_rate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='题目表';

-- ============================================
-- 6. 选择题选项表 (question_options)
-- ============================================
DROP TABLE IF EXISTS `question_options`;
CREATE TABLE `question_options` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '选项ID',
  `question_id` BIGINT NOT NULL COMMENT '题目ID',
  `option_key` VARCHAR(5) NOT NULL COMMENT '选项标识(A/B/C/D)',
  `option_content` TEXT NOT NULL COMMENT '选项内容',
  `is_correct` TINYINT DEFAULT 0 COMMENT '是否正确答案(0否/1是)',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_question` (`question_id`),
  CONSTRAINT `fk_option_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='选择题选项表';

-- ============================================
-- 7. 测试用例表 (test_cases)
-- ============================================
DROP TABLE IF EXISTS `test_cases`;
CREATE TABLE `test_cases` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '测试用例ID',
  `question_id` BIGINT NOT NULL COMMENT '题目ID',
  `input` TEXT NOT NULL COMMENT '输入数据',
  `expected_output` TEXT NOT NULL COMMENT '期望输出',
  `is_sample` TINYINT DEFAULT 0 COMMENT '是否示例用例(0否/1是)',
  `sort_order` INT DEFAULT 0 COMMENT '排序',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_question` (`question_id`),
  INDEX `idx_sample` (`is_sample`),
  CONSTRAINT `fk_testcase_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='测试用例表';

-- ============================================
-- 8. 代码提交记录表 (submissions)
-- ============================================
DROP TABLE IF EXISTS `submissions`;
CREATE TABLE `submissions` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '提交ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `question_id` BIGINT NOT NULL COMMENT '题目ID',
  `language` VARCHAR(20) NOT NULL COMMENT '编程语言(cpp/java/python)',
  `code` TEXT NOT NULL COMMENT '提交代码',
  `status` VARCHAR(20) DEFAULT 'pending' COMMENT '判题状态(pending/judging/ac/wa/tle/mle/re/ce/se)',
  `score` INT DEFAULT 0 COMMENT '得分',
  `time_used` INT COMMENT '运行时间(ms)',
  `memory_used` INT COMMENT '内存使用(KB)',
  `error_message` TEXT COMMENT '错误信息',
  `pass_count` INT DEFAULT 0 COMMENT '通过测试用例数',
  `total_count` INT DEFAULT 0 COMMENT '总测试用例数',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_user` (`user_id`),
  INDEX `idx_question` (`question_id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_created` (`created_at` DESC),
  CONSTRAINT `fk_submission_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_submission_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='代码提交记录表';

-- ============================================
-- 9. 用户答题记录表 (user_answers)
-- ============================================
DROP TABLE IF EXISTS `user_answers`;
CREATE TABLE `user_answers` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `question_id` BIGINT NOT NULL COMMENT '题目ID',
  `answer` VARCHAR(255) COMMENT '用户答案',
  `is_correct` TINYINT COMMENT '是否正确(0错误/1正确)',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '答题时间',
  PRIMARY KEY (`id`),
  INDEX `idx_user` (`user_id`),
  INDEX `idx_question` (`question_id`),
  INDEX `idx_created` (`created_at` DESC),
  CONSTRAINT `fk_answer_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_answer_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户答题记录表';

-- ============================================
-- 10. 考试记录表 (exam_records)
-- ============================================
DROP TABLE IF EXISTS `exam_records`;
CREATE TABLE `exam_records` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '考试ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `exam_type` VARCHAR(50) NOT NULL COMMENT '考试类型(智能组卷等)',
  `subject_ids` VARCHAR(255) COMMENT '科目ID列表(逗号分隔)',
  `total_score` INT DEFAULT 0 COMMENT '总分',
  `user_score` INT DEFAULT 0 COMMENT '用户得分',
  `total_count` INT DEFAULT 0 COMMENT '题目总数',
  `correct_count` INT DEFAULT 0 COMMENT '正确数量',
  `duration` INT COMMENT '考试时长(秒)',
  `started_at` DATETIME COMMENT '开始时间',
  `finished_at` DATETIME COMMENT '完成时间',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_user` (`user_id`),
  INDEX `idx_created` (`created_at` DESC),
  CONSTRAINT `fk_exam_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='考试记录表';

-- ============================================
-- 11. 动态表 (activities)
-- ============================================
DROP TABLE IF EXISTS `activities`;
CREATE TABLE `activities` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '动态ID',
  `user_id` BIGINT NOT NULL COMMENT '用户ID',
  `type` VARCHAR(50) NOT NULL COMMENT '动态类型(login/submit/exam/answer)',
  `content` VARCHAR(500) NOT NULL COMMENT '动态内容',
  `related_id` BIGINT COMMENT '关联ID(题目ID/考试ID等)',
  `metadata` JSON COMMENT '元数据(扩展信息)',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_user` (`user_id`),
  INDEX `idx_type` (`type`),
  INDEX `idx_created` (`created_at` DESC),
  CONSTRAINT `fk_activity_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='动态表';

-- ============================================
-- 初始化科目数据
-- ============================================
INSERT INTO `subjects` (`name`, `code`, `description`, `sort_order`) VALUES
('C语言', 'C', 'C语言程序设计', 1),
('数据结构', 'DS', '数据结构与算法', 2),
('操作系统', 'OS', '操作系统原理', 3),
('计算机组成原理', 'CO', '计算机组成原理', 4),
('计算机网络', 'CN', '计算机网络', 5);

-- ============================================
-- 初始化题目分类数据
-- ============================================
INSERT INTO `question_categories` (`name`, `parent_id`, `sort_order`) VALUES
('简单模拟', 0, 1),
('基础算法', 0, 2),
('搜索', 0, 3),
('数学', 0, 4),
('数据结构', 0, 5),
('动态规划', 0, 6),
('图论', 0, 7),
('计算几何', 0, 8);

-- ============================================
-- 完成
-- ============================================
SELECT '数据库初始化完成！' AS message;
