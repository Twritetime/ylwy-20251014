-- 清空测试数据
USE ylwy_db;

SET FOREIGN_KEY_CHECKS=0;

TRUNCATE TABLE activities;
TRUNCATE TABLE exam_records;
TRUNCATE TABLE user_answers;
TRUNCATE TABLE submissions;
TRUNCATE TABLE test_cases;
TRUNCATE TABLE question_options;
TRUNCATE TABLE questions;
TRUNCATE TABLE schools;
TRUNCATE TABLE users;

SET FOREIGN_KEY_CHECKS=1;

SELECT '数据清空完成！' AS message;
