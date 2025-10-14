-- ============================================
-- 研路无忧 - 测试数据脚本
-- ============================================

USE ylwy_db;

-- ============================================
-- 1. 用户测试数据 (users)
-- 密码统一为: 123456 (BCrypt加密)
-- ============================================
INSERT INTO `users` (`username`, `password`, `email`, `nickname`, `school_from`, `school_target`, `signature`, `role`, `status`) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'admin@ylwy.com', '管理员', '清华大学', '清华大学', '为梦想而努力', 'admin', 1),
('zhangsan', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'zhangsan@qq.com', '小张', '北京大学', '清华大学', '考研加油！', 'user', 1),
('lisi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'lisi@163.com', '小李', '复旦大学', '上海交通大学', '坚持就是胜利', 'user', 1),
('wangwu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'wangwu@gmail.com', '小王', '浙江大学', '北京大学', '不忘初心', 'user', 1),
('zhaoliu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'zhaoliu@126.com', '小赵', '南京大学', '复旦大学', '追逐梦想', 'user', 1),
('sunqi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'sunqi@qq.com', '小孙', '武汉大学', '浙江大学', '永不放弃', 'user', 1),
('zhouba', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'zhouba@sina.com', '小周', '中山大学', '南京大学', '天道酬勤', 'user', 1),
('wujiu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z2EHCr7kg/WOSqCpzgE5m2M.', 'wujiu@qq.com', '小吴', '华中科技大学', '武汉大学', '厚积薄发', 'user', 1);

-- ============================================
-- 2. 学校测试数据 (schools)
-- ============================================
INSERT INTO `schools` (`name`, `province`, `city`, `level`, `description`, `hot_index`, `view_count`) VALUES
('清华大学', '北京', '北京', '985,211,双一流', '中国顶尖学府，理工科强校', 9850, 125000),
('北京大学', '北京', '北京', '985,211,双一流', '中国顶尖学府，综合性大学', 9820, 123000),
('上海交通大学', '上海', '上海', '985,211,双一流', '工科名校，综合实力强劲', 9650, 98000),
('复旦大学', '上海', '上海', '985,211,双一流', '综合性研究型大学', 9620, 96000),
('浙江大学', '浙江', '杭州', '985,211,双一流', '综合实力强劲的名校', 9580, 92000),
('中国科学技术大学', '安徽', '合肥', '985,211,双一流', '理工科顶尖院校', 9500, 85000),
('南京大学', '江苏', '南京', '985,211,双一流', '历史悠久的综合性大学', 9450, 82000),
('哈尔滨工业大学', '黑龙江', '哈尔滨', '985,211,双一流', '工科强校，航天特色', 9380, 78000),
('西安交通大学', '陕西', '西安', '985,211,双一流', '工科名校，西部第一', 9350, 75000),
('武汉大学', '湖北', '武汉', '985,211,双一流', '综合性大学，樱花美景', 9320, 72000),
('中山大学', '广东', '广州', '985,211,双一流', '华南第一学府', 9280, 70000),
('华中科技大学', '湖北', '武汉', '985,211,双一流', '理工医综合性大学', 9250, 68000),
('北京航空航天大学', '北京', '北京', '985,211,双一流', '航空航天特色高校', 9200, 65000),
('同济大学', '上海', '上海', '985,211,双一流', '土木工程强校', 9150, 62000),
('南开大学', '天津', '天津', '985,211,双一流', '文理并重的综合大学', 9100, 60000);

-- ============================================
-- 3. 题目测试数据 (questions)
-- ============================================
-- 选择题
INSERT INTO `questions` (`question_no`, `title`, `content`, `type`, `difficulty`, `subject_id`, `category_id`, `school_source`, `pass_rate`, `submit_count`, `accept_count`) VALUES
('Q001', 'C语言基础-数据类型', '在C语言中，int类型占用的字节数是？', 'CHOICE', 'EASY', 1, 1, '清华大学', 85.50, 1000, 855),
('Q002', '数组与指针', '以下关于数组和指针的说法正确的是？', 'CHOICE', 'MEDIUM', 1, 2, '北京大学', 68.30, 850, 580),
('Q003', '数据结构-栈', '栈的特点是？', 'CHOICE', 'EASY', 2, 5, '浙江大学', 78.20, 920, 719),
('Q004', '二叉树遍历', '对于二叉树的前序遍历，访问顺序是？', 'CHOICE', 'MEDIUM', 2, 5, '上海交通大学', 72.40, 750, 543),
('Q005', '时间复杂度', '冒泡排序的平均时间复杂度是？', 'CHOICE', 'EASY', 2, 2, '复旦大学', 82.10, 980, 805);

-- 编程题
INSERT INTO `questions` (`question_no`, `title`, `content`, `type`, `difficulty`, `subject_id`, `category_id`, `school_source`, `time_limit`, `memory_limit`, `pass_rate`, `submit_count`, `accept_count`) VALUES
('P001', 'A+B Problem', '输入两个整数A和B，输出它们的和。\n\n输入格式：\n一行两个整数A和B（-10^9 <= A,B <= 10^9）\n\n输出格式：\n一个整数，表示A+B的值', 'CODE', 'EASY', 1, 1, '清华大学', 1000, 256, 92.50, 2000, 1850),
('P002', '斐波那契数列', '输入一个整数n，输出斐波那契数列的第n项（n从1开始）。\n\n输入格式：\n一个整数n（1 <= n <= 40）\n\n输出格式：\n一个整数，表示斐波那契数列的第n项', 'CODE', 'MEDIUM', 1, 2, '北京大学', 1000, 256, 75.30, 1500, 1130),
('P003', '链表反转', '给定一个单链表，将其反转并输出。', 'CODE', 'MEDIUM', 2, 5, '浙江大学', 2000, 256, 68.80, 1200, 826),
('P004', '二分查找', '在一个有序数组中查找目标值的位置。', 'CODE', 'EASY', 2, 2, '南京大学', 1000, 256, 82.20, 1800, 1480),
('P005', '最大子数组和', '给定一个整数数组，找到一个具有最大和的连续子数组。', 'CODE', 'HARD', 2, 6, '复旦大学', 2000, 512, 45.60, 900, 410);

-- ============================================
-- 4. 选择题选项 (question_options)
-- ============================================
INSERT INTO `question_options` (`question_id`, `option_key`, `option_content`, `is_correct`) VALUES
-- Q001 选项
(1, 'A', '2字节', 0),
(1, 'B', '4字节', 1),
(1, 'C', '8字节', 0),
(1, 'D', '不确定', 0),
-- Q002 选项
(2, 'A', '数组名和指针完全等价', 0),
(2, 'B', '数组名可以被重新赋值', 0),
(2, 'C', '数组名是一个常量指针', 1),
(2, 'D', '指针不能指向数组', 0),
-- Q003 选项
(3, 'A', '先进先出(FIFO)', 0),
(3, 'B', '后进先出(LIFO)', 1),
(3, 'C', '随机访问', 0),
(3, 'D', '顺序访问', 0),
-- Q004 选项
(4, 'A', '根-左-右', 1),
(4, 'B', '左-根-右', 0),
(4, 'C', '左-右-根', 0),
(4, 'D', '右-根-左', 0),
-- Q005 选项
(5, 'A', 'O(n)', 0),
(5, 'B', 'O(n^2)', 1),
(5, 'C', 'O(nlogn)', 0),
(5, 'D', 'O(logn)', 0);

-- ============================================
-- 5. 编程题测试用例 (test_cases)
-- ============================================
INSERT INTO `test_cases` (`question_id`, `input`, `expected_output`, `is_sample`, `sort_order`) VALUES
-- P001 测试用例
(6, '1 2', '3', 1, 1),
(6, '-5 3', '-2', 1, 2),
(6, '0 0', '0', 0, 3),
(6, '1000000000 1000000000', '2000000000', 0, 4),
-- P002 测试用例
(7, '1', '1', 1, 1),
(7, '5', '5', 1, 2),
(7, '10', '55', 0, 3),
(7, '20', '6765', 0, 4),
-- P003 测试用例
(8, '1->2->3->4->5', '5->4->3->2->1', 1, 1),
(8, '1->2', '2->1', 1, 2),
(8, '1', '1', 0, 3);

-- ============================================
-- 6. 代码提交记录 (submissions)
-- ============================================
INSERT INTO `submissions` (`user_id`, `question_id`, `language`, `code`, `status`, `score`, `time_used`, `memory_used`, `pass_count`, `total_count`) VALUES
(2, 6, 'C', '#include <stdio.h>\nint main() {\n    int a, b;\n    scanf("%d %d", &a, &b);\n    printf("%d", a+b);\n    return 0;\n}', 'ACCEPTED', 100, 5, 256, 4, 4),
(3, 6, 'Python', 'a, b = map(int, input().split())\nprint(a + b)', 'ACCEPTED', 100, 8, 512, 4, 4),
(4, 7, 'C', '#include <stdio.h>\nint fib(int n) {\n    if(n<=2) return 1;\n    return fib(n-1)+fib(n-2);\n}\nint main() {\n    int n;\n    scanf("%d", &n);\n    printf("%d", fib(n));\n    return 0;\n}', 'ACCEPTED', 100, 125, 512, 4, 4),
(5, 6, 'Java', 'import java.util.Scanner;\npublic class Main {\n    public static void main(String[] args) {\n        Scanner sc = new Scanner(System.in);\n        int a = sc.nextInt();\n        int b = sc.nextInt();\n        System.out.println(a+b);\n    }\n}', 'ACCEPTED', 100, 15, 1024, 4, 4),
(6, 7, 'Python', 'def fib(n):\n    if n <= 2:\n        return 1\n    return fib(n-1) + fib(n-2)\nn = int(input())\nprint(fib(n))', 'TIME_LIMIT_EXCEEDED', 0, 2001, 512, 2, 4);

-- ============================================
-- 7. 用户答题记录 (user_answers)
-- ============================================
INSERT INTO `user_answers` (`user_id`, `question_id`, `answer`, `is_correct`) VALUES
(2, 1, 'B', 1),
(2, 2, 'C', 1),
(2, 3, 'B', 1),
(3, 1, 'B', 1),
(3, 2, 'A', 0),
(3, 3, 'B', 1),
(4, 1, 'A', 0),
(4, 4, 'A', 1),
(5, 1, 'B', 1),
(5, 5, 'B', 1);

-- ============================================
-- 8. 考试记录 (exam_records)
-- ============================================
INSERT INTO `exam_records` (`user_id`, `exam_type`, `subject_ids`, `total_score`, `user_score`, `total_count`, `correct_count`, `duration`, `started_at`, `finished_at`) VALUES
(2, '智能组卷', '1,2', 100, 85, 10, 8, 1800, '2025-10-13 10:00:00', '2025-10-13 10:30:00'),
(3, '智能组卷', '1', 100, 75, 10, 7, 2100, '2025-10-13 14:00:00', '2025-10-13 14:35:00'),
(4, '智能组卷', '2', 100, 90, 10, 9, 1650, '2025-10-14 09:00:00', '2025-10-14 09:27:30');

-- ============================================
-- 9. 用户动态 (activities)
-- ============================================
INSERT INTO `activities` (`user_id`, `type`, `content`, `related_id`) VALUES
(2, 'submit', '用户小张提交了题目A+B Problem，获得AC', 6),
(3, 'submit', '用户小李提交了题目A+B Problem，获得AC', 6),
(4, 'exam', '用户小王完成了一次智能组卷，得分90分', 3),
(5, 'answer', '用户小赵回答了选择题，正确率100%', 1),
(2, 'exam', '用户小张完成了一次智能组卷，得分85分', 1);

SELECT '测试数据添加完成！' AS message;

