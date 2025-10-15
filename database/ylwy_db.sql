/*
 Navicat MySQL Dump SQL

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80012 (8.0.12)
 Source Host           : localhost:3306
 Source Schema         : ylwy_db

 Target Server Type    : MySQL
 Target Server Version : 80012 (8.0.12)
 File Encoding         : 65001

 Date: 15/10/2025 18:29:02
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activities
-- ----------------------------
DROP TABLE IF EXISTS `activities`;
CREATE TABLE `activities`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '动态ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '动态类型(login/submit/exam/answer)',
  `content` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '动态内容',
  `related_id` bigint(20) NULL DEFAULT NULL COMMENT '关联ID(题目ID/考试ID等)',
  `metadata` json NULL COMMENT '元数据(扩展信息)',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_type`(`type` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` DESC) USING BTREE,
  CONSTRAINT `fk_activity_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '动态表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of activities
-- ----------------------------
INSERT INTO `activities` VALUES (1, 2, 'submit', '用户小张提交了题目A+B Problem，获得AC', 6, NULL, '2025-10-14 22:30:33');
INSERT INTO `activities` VALUES (2, 3, 'submit', '用户小李提交了题目A+B Problem，获得AC', 6, NULL, '2025-10-14 22:30:33');
INSERT INTO `activities` VALUES (3, 4, 'exam', '用户小王完成了一次智能组卷，得分90分', 3, NULL, '2025-10-14 22:30:33');
INSERT INTO `activities` VALUES (4, 5, 'answer', '用户小赵回答了选择题，正确率100%', 1, NULL, '2025-10-14 22:30:33');
INSERT INTO `activities` VALUES (5, 2, 'exam', '用户小张完成了一次智能组卷，得分85分', 1, NULL, '2025-10-14 22:30:33');

-- ----------------------------
-- Table structure for exam_records
-- ----------------------------
DROP TABLE IF EXISTS `exam_records`;
CREATE TABLE `exam_records`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '考试ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `exam_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '考试类型(智能组卷等)',
  `subject_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '科目ID列表(逗号分隔)',
  `total_score` int(11) NULL DEFAULT 0 COMMENT '总分',
  `user_score` int(11) NULL DEFAULT 0 COMMENT '用户得分',
  `total_count` int(11) NULL DEFAULT 0 COMMENT '题目总数',
  `correct_count` int(11) NULL DEFAULT 0 COMMENT '正确数量',
  `duration` int(11) NULL DEFAULT NULL COMMENT '考试时长(秒)',
  `started_at` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `finished_at` datetime NULL DEFAULT NULL COMMENT '完成时间',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` DESC) USING BTREE,
  CONSTRAINT `fk_exam_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '考试记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam_records
-- ----------------------------
INSERT INTO `exam_records` VALUES (1, 2, '智能组卷', '1,2', 100, 85, 10, 8, 1800, '2025-10-13 10:00:00', '2025-10-13 10:30:00', '2025-10-14 22:30:33');
INSERT INTO `exam_records` VALUES (2, 3, '智能组卷', '1', 100, 75, 10, 7, 2100, '2025-10-13 14:00:00', '2025-10-13 14:35:00', '2025-10-14 22:30:33');
INSERT INTO `exam_records` VALUES (3, 4, '智能组卷', '2', 100, 90, 10, 9, 1650, '2025-10-14 09:00:00', '2025-10-14 09:27:30', '2025-10-14 22:30:33');

-- ----------------------------
-- Table structure for question_categories
-- ----------------------------
DROP TABLE IF EXISTS `question_categories`;
CREATE TABLE `question_categories`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '分类名称',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父分类ID(0表示顶级)',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent`(`parent_id` ASC) USING BTREE,
  INDEX `idx_sort`(`sort_order` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '题目分类表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question_categories
-- ----------------------------
INSERT INTO `question_categories` VALUES (1, '简单模拟', 0, 1, '2025-10-14 20:48:23');
INSERT INTO `question_categories` VALUES (2, '基础算法', 0, 2, '2025-10-14 20:48:23');
INSERT INTO `question_categories` VALUES (3, '搜索', 0, 3, '2025-10-14 20:48:23');
INSERT INTO `question_categories` VALUES (4, '数学', 0, 4, '2025-10-14 20:48:23');
INSERT INTO `question_categories` VALUES (5, '数据结构', 0, 5, '2025-10-14 20:48:23');
INSERT INTO `question_categories` VALUES (6, '动态规划', 0, 6, '2025-10-14 20:48:23');
INSERT INTO `question_categories` VALUES (7, '图论', 0, 7, '2025-10-14 20:48:23');
INSERT INTO `question_categories` VALUES (8, '计算几何', 0, 8, '2025-10-14 20:48:23');

-- ----------------------------
-- Table structure for question_options
-- ----------------------------
DROP TABLE IF EXISTS `question_options`;
CREATE TABLE `question_options`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '选项ID',
  `question_id` bigint(20) NOT NULL COMMENT '题目ID',
  `option_key` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '选项标识(A/B/C/D)',
  `option_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '选项内容',
  `is_correct` tinyint(4) NULL DEFAULT 0 COMMENT '是否正确答案(0否/1是)',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_question`(`question_id` ASC) USING BTREE,
  CONSTRAINT `fk_option_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '选择题选项表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question_options
-- ----------------------------
INSERT INTO `question_options` VALUES (1, 1, 'A', '2字节', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (2, 1, 'B', '4字节', 1, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (3, 1, 'C', '8字节', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (4, 1, 'D', '不确定', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (5, 2, 'A', '数组名和指针完全等价', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (6, 2, 'B', '数组名可以被重新赋值', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (7, 2, 'C', '数组名是一个常量指针', 1, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (8, 2, 'D', '指针不能指向数组', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (9, 3, 'A', '先进先出(FIFO)', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (10, 3, 'B', '后进先出(LIFO)', 1, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (11, 3, 'C', '随机访问', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (12, 3, 'D', '顺序访问', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (13, 4, 'A', '根-左-右', 1, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (14, 4, 'B', '左-根-右', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (15, 4, 'C', '左-右-根', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (16, 4, 'D', '右-根-左', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (17, 5, 'A', 'O(n)', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (18, 5, 'B', 'O(n^2)', 1, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (19, 5, 'C', 'O(nlogn)', 0, '2025-10-14 22:30:33');
INSERT INTO `question_options` VALUES (20, 5, 'D', 'O(logn)', 0, '2025-10-14 22:30:33');

-- ----------------------------
-- Table structure for questions
-- ----------------------------
DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `question_no` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '题目编号',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '题目标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '题目内容',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '题目类型(choice/program)',
  `difficulty` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'medium' COMMENT '难度(easy/medium/hard)',
  `subject_id` bigint(20) NULL DEFAULT NULL COMMENT '科目ID',
  `category_id` bigint(20) NULL DEFAULT NULL COMMENT '分类ID',
  `school_source` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '来源学校',
  `time_limit` int(11) NULL DEFAULT 1000 COMMENT '时间限制(ms，仅编程题)',
  `memory_limit` int(11) NULL DEFAULT 256 COMMENT '内存限制(MB，仅编程题)',
  `pass_rate` decimal(5, 2) NULL DEFAULT 0.00 COMMENT '通过率(%)',
  `submit_count` int(11) NULL DEFAULT 0 COMMENT '提交次数',
  `accept_count` int(11) NULL DEFAULT 0 COMMENT '通过次数',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `question_no`(`question_no` ASC) USING BTREE,
  UNIQUE INDEX `uk_question_no`(`question_no` ASC) USING BTREE,
  INDEX `idx_type`(`type` ASC) USING BTREE,
  INDEX `idx_difficulty`(`difficulty` ASC) USING BTREE,
  INDEX `idx_subject`(`subject_id` ASC) USING BTREE,
  INDEX `idx_category`(`category_id` ASC) USING BTREE,
  INDEX `idx_pass_rate`(`pass_rate` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '题目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of questions
-- ----------------------------
INSERT INTO `questions` VALUES (1, 'Q001', 'C语言基础-数据类型', '在C语言中，int类型占用的字节数是？', 'CHOICE', 'EASY', 1, 1, '清华大学', 1000, 256, 85.50, 1000, 855, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `questions` VALUES (2, 'Q002', '数组与指针', '以下关于数组和指针的说法正确的是？', 'CHOICE', 'MEDIUM', 1, 2, '北京大学', 1000, 256, 68.30, 850, 580, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `questions` VALUES (3, 'Q003', '数据结构-栈', '栈的特点是？', 'CHOICE', 'EASY', 2, 5, '浙江大学', 1000, 256, 78.20, 920, 719, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `questions` VALUES (4, 'Q004', '二叉树遍历', '对于二叉树的前序遍历，访问顺序是？', 'CHOICE', 'MEDIUM', 2, 5, '上海交通大学', 1000, 256, 72.40, 750, 543, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `questions` VALUES (5, 'Q005', '时间复杂度', '冒泡排序的平均时间复杂度是？', 'CHOICE', 'EASY', 2, 2, '复旦大学', 1000, 256, 82.10, 980, 805, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `questions` VALUES (6, 'P001', 'A+B Problem', '输入两个整数A和B，输出它们的和。\n\n输入格式：\n一行两个整数A和B（-10^9 <= A,B <= 10^9）\n\n输出格式：\n一个整数，表示A+B的值', 'CODE', 'EASY', 1, 1, '清华大学', 1000, 256, 92.50, 2000, 1850, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `questions` VALUES (7, 'P002', '斐波那契数列', '输入一个整数n，输出斐波那契数列的第n项（n从1开始）。\n\n输入格式：\n一个整数n（1 <= n <= 40）\n\n输出格式：\n一个整数，表示斐波那契数列的第n项', 'CODE', 'MEDIUM', 1, 2, '北京大学', 1000, 256, 75.30, 1500, 1130, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `questions` VALUES (8, 'P003', '链表反转', '给定一个单链表，将其反转并输出。', 'CODE', 'MEDIUM', 2, 5, '浙江大学', 2000, 256, 68.80, 1200, 826, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `questions` VALUES (9, 'P004', '二分查找', '在一个有序数组中查找目标值的位置。', 'CODE', 'EASY', 2, 2, '南京大学', 1000, 256, 82.20, 1800, 1480, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `questions` VALUES (10, 'P005', '最大子数组和', '给定一个整数数组，找到一个具有最大和的连续子数组。', 'CODE', 'HARD', 2, 6, '复旦大学', 2000, 512, 45.60, 900, 410, '2025-10-14 22:30:33', '2025-10-14 22:30:33');

-- ----------------------------
-- Table structure for schools
-- ----------------------------
DROP TABLE IF EXISTS `schools`;
CREATE TABLE `schools`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '学校ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '学校名称',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '省份',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '城市',
  `level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学校层次(985/211/双一流)',
  `logo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学校logo',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '学校简介',
  `hot_index` int(11) NULL DEFAULT 0 COMMENT '热门指数',
  `view_count` int(11) NULL DEFAULT 0 COMMENT '浏览次数',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_name`(`name` ASC) USING BTREE,
  INDEX `idx_province`(`province` ASC) USING BTREE,
  INDEX `idx_hot_index`(`hot_index` DESC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学校表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of schools
-- ----------------------------
INSERT INTO `schools` VALUES (1, '清华大学', '北京', '北京', '985,211,双一流', NULL, '中国顶尖学府，理工科强校', 9850, 125000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (2, '北京大学', '北京', '北京', '985,211,双一流', NULL, '中国顶尖学府，综合性大学', 9820, 123000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (3, '上海交通大学', '上海', '上海', '985,211,双一流', NULL, '工科名校，综合实力强劲', 9650, 98000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (4, '复旦大学', '上海', '上海', '985,211,双一流', NULL, '综合性研究型大学', 9620, 96000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (5, '浙江大学', '浙江', '杭州', '985,211,双一流', NULL, '综合实力强劲的名校', 9580, 92000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (6, '中国科学技术大学', '安徽', '合肥', '985,211,双一流', NULL, '理工科顶尖院校', 9500, 85000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (7, '南京大学', '江苏', '南京', '985,211,双一流', NULL, '历史悠久的综合性大学', 9450, 82000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (8, '哈尔滨工业大学', '黑龙江', '哈尔滨', '985,211,双一流', NULL, '工科强校，航天特色', 9380, 78000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (9, '西安交通大学', '陕西', '西安', '985,211,双一流', NULL, '工科名校，西部第一', 9350, 75000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (10, '武汉大学', '湖北', '武汉', '985,211,双一流', NULL, '综合性大学，樱花美景', 9320, 72000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (11, '中山大学', '广东', '广州', '985,211,双一流', NULL, '华南第一学府', 9280, 70000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (12, '华中科技大学', '湖北', '武汉', '985,211,双一流', NULL, '理工医综合性大学', 9250, 68000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (13, '北京航空航天大学', '北京', '北京', '985,211,双一流', NULL, '航空航天特色高校', 9200, 65000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (14, '同济大学', '上海', '上海', '985,211,双一流', NULL, '土木工程强校', 9150, 62000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `schools` VALUES (15, '南开大学', '天津', '天津', '985,211,双一流', NULL, '文理并重的综合大学', 9100, 60000, '2025-10-14 22:30:33', '2025-10-14 22:30:33');

-- ----------------------------
-- Table structure for subjects
-- ----------------------------
DROP TABLE IF EXISTS `subjects`;
CREATE TABLE `subjects`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '科目ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '科目名称',
  `code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '科目代码',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '科目描述',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE,
  INDEX `idx_code`(`code` ASC) USING BTREE,
  INDEX `idx_sort`(`sort_order` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '科目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of subjects
-- ----------------------------
INSERT INTO `subjects` VALUES (1, 'C语言', 'C', 'C语言程序设计', 1, '2025-10-14 20:48:23');
INSERT INTO `subjects` VALUES (2, '数据结构', 'DS', '数据结构与算法', 2, '2025-10-14 20:48:23');
INSERT INTO `subjects` VALUES (3, '操作系统', 'OS', '操作系统原理', 3, '2025-10-14 20:48:23');
INSERT INTO `subjects` VALUES (4, '计算机组成原理', 'CO', '计算机组成原理', 4, '2025-10-14 20:48:23');
INSERT INTO `subjects` VALUES (5, '计算机网络', 'CN', '计算机网络', 5, '2025-10-14 20:48:23');

-- ----------------------------
-- Table structure for submissions
-- ----------------------------
DROP TABLE IF EXISTS `submissions`;
CREATE TABLE `submissions`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '提交ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `question_id` bigint(20) NOT NULL COMMENT '题目ID',
  `language` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '编程语言(cpp/java/python)',
  `code` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '提交代码',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'pending' COMMENT '判题状态(pending/judging/ac/wa/tle/mle/re/ce/se)',
  `score` int(11) NULL DEFAULT 0 COMMENT '得分',
  `time_used` int(11) NULL DEFAULT NULL COMMENT '运行时间(ms)',
  `memory_used` int(11) NULL DEFAULT NULL COMMENT '内存使用(KB)',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '错误信息',
  `pass_count` int(11) NULL DEFAULT 0 COMMENT '通过测试用例数',
  `total_count` int(11) NULL DEFAULT 0 COMMENT '总测试用例数',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_question`(`question_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` DESC) USING BTREE,
  CONSTRAINT `fk_submission_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_submission_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '代码提交记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of submissions
-- ----------------------------
INSERT INTO `submissions` VALUES (1, 2, 6, 'C', '#include <stdio.h>\nint main() {\n    int a, b;\n    scanf(\"%d %d\", &a, &b);\n    printf(\"%d\", a+b);\n    return 0;\n}', 'ACCEPTED', 100, 5, 256, NULL, 4, 4, '2025-10-14 22:30:33');
INSERT INTO `submissions` VALUES (2, 3, 6, 'Python', 'a, b = map(int, input().split())\nprint(a + b)', 'ACCEPTED', 100, 8, 512, NULL, 4, 4, '2025-10-14 22:30:33');
INSERT INTO `submissions` VALUES (3, 4, 7, 'C', '#include <stdio.h>\nint fib(int n) {\n    if(n<=2) return 1;\n    return fib(n-1)+fib(n-2);\n}\nint main() {\n    int n;\n    scanf(\"%d\", &n);\n    printf(\"%d\", fib(n));\n    return 0;\n}', 'ACCEPTED', 100, 125, 512, NULL, 4, 4, '2025-10-14 22:30:33');
INSERT INTO `submissions` VALUES (4, 5, 6, 'Java', 'import java.util.Scanner;\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int a = sc.nextInt();\n        int b = sc.nextInt();\n        System.out.println(a+b);\n    }\n}', 'ACCEPTED', 100, 15, 1024, NULL, 4, 4, '2025-10-14 22:30:33');
INSERT INTO `submissions` VALUES (5, 6, 7, 'Python', 'def fib(n):\n    if n <= 2:\n        return 1\n    return fib(n-1) + fib(n-2)\nn = int(input())\nprint(fib(n))', 'TIME_LIMIT_EXCEEDED', 0, 2001, 512, NULL, 2, 4, '2025-10-14 22:30:33');

-- ----------------------------
-- Table structure for test_cases
-- ----------------------------
DROP TABLE IF EXISTS `test_cases`;
CREATE TABLE `test_cases`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '测试用例ID',
  `question_id` bigint(20) NOT NULL COMMENT '题目ID',
  `input` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '输入数据',
  `expected_output` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '期望输出',
  `is_sample` tinyint(4) NULL DEFAULT 0 COMMENT '是否示例用例(0否/1是)',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_question`(`question_id` ASC) USING BTREE,
  INDEX `idx_sample`(`is_sample` ASC) USING BTREE,
  CONSTRAINT `fk_testcase_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '测试用例表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of test_cases
-- ----------------------------
INSERT INTO `test_cases` VALUES (1, 6, '1 2', '3', 1, 1, '2025-10-14 22:30:33');
INSERT INTO `test_cases` VALUES (2, 6, '-5 3', '-2', 1, 2, '2025-10-14 22:30:33');
INSERT INTO `test_cases` VALUES (3, 6, '0 0', '0', 0, 3, '2025-10-14 22:30:33');
INSERT INTO `test_cases` VALUES (4, 6, '1000000000 1000000000', '2000000000', 0, 4, '2025-10-14 22:30:33');
INSERT INTO `test_cases` VALUES (5, 7, '1', '1', 1, 1, '2025-10-14 22:30:33');
INSERT INTO `test_cases` VALUES (6, 7, '5', '5', 1, 2, '2025-10-14 22:30:33');
INSERT INTO `test_cases` VALUES (7, 7, '10', '55', 0, 3, '2025-10-14 22:30:33');
INSERT INTO `test_cases` VALUES (8, 7, '20', '6765', 0, 4, '2025-10-14 22:30:33');
INSERT INTO `test_cases` VALUES (9, 8, '1->2->3->4->5', '5->4->3->2->1', 1, 1, '2025-10-14 22:30:33');
INSERT INTO `test_cases` VALUES (10, 8, '1->2', '2->1', 1, 2, '2025-10-14 22:30:33');
INSERT INTO `test_cases` VALUES (11, 8, '1', '1', 0, 3, '2025-10-14 22:30:33');

-- ----------------------------
-- Table structure for user_answers
-- ----------------------------
DROP TABLE IF EXISTS `user_answers`;
CREATE TABLE `user_answers`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `question_id` bigint(20) NOT NULL COMMENT '题目ID',
  `answer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户答案',
  `is_correct` tinyint(4) NULL DEFAULT NULL COMMENT '是否正确(0错误/1正确)',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '答题时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_question`(`question_id` ASC) USING BTREE,
  INDEX `idx_created`(`created_at` DESC) USING BTREE,
  CONSTRAINT `fk_answer_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_answer_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户答题记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_answers
-- ----------------------------
INSERT INTO `user_answers` VALUES (1, 2, 1, 'B', 1, '2025-10-14 22:30:33');
INSERT INTO `user_answers` VALUES (2, 2, 2, 'C', 1, '2025-10-14 22:30:33');
INSERT INTO `user_answers` VALUES (3, 2, 3, 'B', 1, '2025-10-14 22:30:33');
INSERT INTO `user_answers` VALUES (4, 3, 1, 'B', 1, '2025-10-14 22:30:33');
INSERT INTO `user_answers` VALUES (5, 3, 2, 'A', 0, '2025-10-14 22:30:33');
INSERT INTO `user_answers` VALUES (6, 3, 3, 'B', 1, '2025-10-14 22:30:33');
INSERT INTO `user_answers` VALUES (7, 4, 1, 'A', 0, '2025-10-14 22:30:33');
INSERT INTO `user_answers` VALUES (8, 4, 4, 'A', 1, '2025-10-14 22:30:33');
INSERT INTO `user_answers` VALUES (9, 5, 1, 'B', 1, '2025-10-14 22:30:33');
INSERT INTO `user_answers` VALUES (10, 5, 5, 'B', 1, '2025-10-14 22:30:33');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码(BCrypt加密)',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '手机号',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'https://avatar.default.com/default.png' COMMENT '头像URL',
  `school_from` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '本科院校',
  `school_target` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '目标院校',
  `signature` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '个性签名',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'user' COMMENT '角色(user/admin)',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态(0禁用/1启用)',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE,
  INDEX `idx_email`(`email` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'admin@ylwy.com', NULL, '管理员', 'https://avatar.default.com/default.png', '清华大学', '清华大学', '为梦想而努力', 'admin', 1, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `users` VALUES (2, 'zhangsan', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'zhangsan@qq.com', NULL, '小张', 'https://avatar.default.com/default.png', '北京大学', '清华大学', '考研加油！', 'user', 1, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `users` VALUES (3, 'lisi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'lisi@163.com', NULL, '小李', 'https://avatar.default.com/default.png', '复旦大学', '上海交通大学', '坚持就是胜利', 'user', 1, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `users` VALUES (4, 'wangwu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'wangwu@gmail.com', NULL, '小王', 'https://avatar.default.com/default.png', '浙江大学', '北京大学', '不忘初心', 'user', 1, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `users` VALUES (5, 'zhaoliu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'zhaoliu@126.com', NULL, '小赵', 'https://avatar.default.com/default.png', '南京大学', '复旦大学', '追逐梦想', 'user', 1, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `users` VALUES (6, 'sunqi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'sunqi@qq.com', NULL, '小孙', 'https://avatar.default.com/default.png', '武汉大学', '浙江大学', '永不放弃', 'user', 1, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `users` VALUES (7, 'zhouba', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'zhouba@sina.com', NULL, '小周', 'https://avatar.default.com/default.png', '中山大学', '南京大学', '天道酬勤', 'user', 1, '2025-10-14 22:30:33', '2025-10-14 22:30:33');
INSERT INTO `users` VALUES (8, 'wujiu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'wujiu@qq.com', NULL, '小吴', 'https://avatar.default.com/default.png', '华中科技大学', '武汉大学', '厚积薄发', 'user', 1, '2025-10-14 22:30:33', '2025-10-14 22:30:33');

SET FOREIGN_KEY_CHECKS = 1;
