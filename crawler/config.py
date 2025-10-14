"""
爬虫配置文件
"""

# 目标网站
TARGET_URL = "https://noobdream.com/"

# 数据库配置
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': 'root',
    'database': 'ylwy_db',
    'charset': 'utf8mb4'
}

# 爬虫设置
CRAWLER_CONFIG = {
    # 请求延迟（秒）
    'delay': 2,
    # 超时时间（秒）
    'timeout': 10,
    # 重试次数
    'retry': 3,
    # User-Agent
    'user_agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
}

# 数据保存路径
DATA_DIR = './data'
