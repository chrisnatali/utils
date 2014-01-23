from lxml import etree
import urllib2
import urlparse
import sys

# Prevents this script from failing when output is piped
# to another process
from signal import signal, SIGPIPE, SIG_DFL
signal(SIGPIPE,SIG_DFL)

htmlparser = etree.HTMLParser()
def get_city_urls(base_url, region_url):

    region_response = urllib2.urlopen(region_url)
    region_tree = etree.parse(region_response, htmlparser)
    urls = []
    alpha_caps = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for el in region_tree.xpath("//a"):
        if el.text in alpha_caps:
            urls.append(base_url + el.values()[0])
    
    return urls
        

def print_city_data(city_url):

    city_response= urllib2.urlopen(city_url)
    city_tree = etree.parse(city_response, htmlparser)
    
    for el in city_tree.xpath("//tr/td/.."):
        city_name = el.xpath(".//a")[0].text
        fields = [e.text for e in el if e.text]
        fields.insert(0, city_name)
        if len(fields) > 0:
            sys.stdout.write(",".join(fields).encode('utf-8') + "\n")
    
if __name__ == '__main__':

    if (len(sys.argv) < 2):
        sys.stderr.write("example usage:  python scrape_falling_rain.py url\n")
        sys.exit()

    url = sys.argv[1]

    url_parts = urlparse.urlparse(url)
    base_url = url_parts[0] + "://" + url_parts[1]

    response = urllib2.urlopen(url)
    tree = etree.parse(response, htmlparser)
       
    regions = []
    for region_element in tree.xpath("//li/a"):
        region = {}
        name = region_element.text
        path  = region_element.values()[0]
        region_url = base_url + path
        city_urls = get_city_urls(base_url, region_url)
        for city_url in city_urls:
            print_city_data(city_url) 



