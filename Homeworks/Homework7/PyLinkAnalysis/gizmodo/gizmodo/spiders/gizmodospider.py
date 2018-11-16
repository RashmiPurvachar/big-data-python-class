# -*- coding: utf-8 -*-
import scrapy


class GizmodospiderSpider(scrapy.Spider):
    name = 'gizmodospider'
    allowed_domains = ['https://gizmodo.com']
    start_urls = ['http://https://gizmodo.com/']

    def parse(self, response):
        pass
