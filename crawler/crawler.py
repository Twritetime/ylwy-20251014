"""
NoobDream 数据爬虫主程序
"""

import requests
from bs4 import BeautifulSoup
import time
import json
import os
from config import TARGET_URL, CRAWLER_CONFIG, DATA_DIR

class NoobDreamCrawler:
    def __init__(self):
        self.base_url = TARGET_URL
        self.headers = {
            'User-Agent': CRAWLER_CONFIG['user_agent']
        }
        self.session = requests.Session()
        
        # 创建数据目录
        if not os.path.exists(DATA_DIR):
            os.makedirs(DATA_DIR)
    
    def fetch_page(self, url):
        """获取页面内容"""
        try:
            response = self.session.get(
                url,
                headers=self.headers,
                timeout=CRAWLER_CONFIG['timeout']
            )
            response.raise_for_status()
            response.encoding = 'utf-8'
            return response.text
        except Exception as e:
            print(f"获取页面失败: {url}, 错误: {e}")
            return None
    
    def crawl_schools(self):
        """爬取学校信息"""
        print("开始爬取学校信息...")
        # TODO: 实现学校信息爬取逻辑
        schools = []
        
        # 保存到文件
        with open(f'{DATA_DIR}/schools.json', 'w', encoding='utf-8') as f:
            json.dump(schools, f, ensure_ascii=False, indent=2)
        
        print(f"学校信息爬取完成，共 {len(schools)} 条")
        return schools
    
    def crawl_questions(self):
        """爬取题目信息"""
        print("开始爬取题目信息...")
        # TODO: 实现题目爬取逻辑
        questions = []
        
        # 保存到文件
        with open(f'{DATA_DIR}/questions.json', 'w', encoding='utf-8') as f:
            json.dump(questions, f, ensure_ascii=False, indent=2)
        
        print(f"题目信息爬取完成，共 {len(questions)} 条")
        return questions
    
    def run(self):
        """运行爬虫"""
        print("="*50)
        print("  NoobDream 数据爬虫启动")
        print("="*50)
        print("\n⚠️  注意：爬取的数据仅供学习研究使用")
        print("⚠️  请遵守目标网站的 robots.txt 规则")
        print("⚠️  建议设置合理的延迟，避免对服务器造成压力\n")
        
        # 爬取学校信息
        time.sleep(CRAWLER_CONFIG['delay'])
        self.crawl_schools()
        
        # 爬取题目信息
        time.sleep(CRAWLER_CONFIG['delay'])
        self.crawl_questions()
        
        print("\n爬虫任务完成！")

if __name__ == '__main__':
    crawler = NoobDreamCrawler()
    crawler.run()
