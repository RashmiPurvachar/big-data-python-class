import scrapy
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor

class gizmodoitem(scrapy.Item):
    title = scrapy.Field()
    link = scrapy.Field()
    response = scrapy.Field()
    
class gizmodoSpider(scrapy.Spider):
    # name of the spider
    name = 'gizmodocrawler'
    # specify which domains should be accessible for this crawlwr through allowed_domains property
    allowed_domains = ['https://gizmodo.com/']  
    # specify initial URLs that to be accessed at first place
    start_urls = ['https://gizmodo.com/video/',
                  'https://gizmodo.com/c/review/',
                  'https://gizmodo.com/tag/science/',
                  'https://io9.gizmodo.com/',
                  'https://gizmodo.com/c/field-guide/',
                  'https://earther.gizmodo.com/',
                  'https://gizmodo.com/c/design/',
                  'https://paleofuture.gizmodo.com/']
    
    """
    Set rules variable, mention the rules of navigating the sites. 
    The LinkExtractor actually takes parameters to draw navigation boundaries.
    Using restrict_xpaths parameter to set the class for NEXT page.
    
    call_back parameter tells which method to use to access the page elements.
    
    Setting follow=True, allows the crawler to check the rule for Next Page and will keep navigating 
    unless it hits the last page of the listing.
    """
    rules = (Rule(SgmlLinkExtractor(allow=(),restrict_xpaths=('//a[@class="button next"]',)),
                  callback="parse", 
                  follow= True),)
    
    # parse the content of the pages being accessed
    def parse(self, response):
        hxs = scrapy.Selector(response)
        titles = hxs.xpath('//ul/li')
        item = []
        for title in titles:
            item_object = gizmodoitem()
            item_object["title"] = title.xpath("a/text()").extract()
            item_object["link"] = title.xpath("a/@href").extract()
            item_object["response"] = response
            if item_object["title"] != []:
                item.append(item_object)

        return item