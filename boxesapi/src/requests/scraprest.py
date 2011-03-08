import apidocs
import request
from google.appengine.api import urlfetch

import html5lib
import urllib
from html5lib import treebuilders, treewalkers, serializer
from html5lib import sanitizer

from django.utils import simplejson as json
import model

class ScrapRestRequest(request.Request):
    """Scraps http://rest.co.il and extract business geo-locations and some information"""
    
    @classmethod
    def get_url(cls):
        return "/rest"
    
    @classmethod
    def get_usages(cls):
        return [ apidocs.UsageDoc('?q=query', sample = '?q=Search.aspx?keyword=%u05D0%u05E8%u05E7%u05E4%u05D4') ]
    
    def get(self):
        if not self.required_field('q'): return
        query = self.request.get('q')
        url = "http://www.rest.co.il/" + query;
        
        rest = urlfetch.fetch(url)
        
        parser = html5lib.HTMLParser(tree=treebuilders.getTreeBuilder("dom"))
        
        tree = parser.parse(rest.content.decode('windows-1255'))
        tree.normalize()
        
        venues = []
        
        for div in tree.getElementsByTagName('div'):
            if div.getAttribute('class') == 'details':
                
                venue = { }
                
                children = div.childNodes
                for s in children:
                    if s.nodeName == "a" and s.getAttribute('class') == 'title':
                        venue['id'] = s.getAttribute('href').strip()
                        venue['url'] = s.getAttribute('href').strip()
                        for c in s.childNodes:
                            venue['name'] = c.data.strip()
                    
                    if s.nodeName == "span" and s.getAttribute('class') == 'address':
                        for c in s.childNodes:
                            venue['address'] = c.data.strip()
                            geocodeurl = 'http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=' + urllib.quote_plus(venue['address'].encode('utf-8'))
                            venue['geocodeurl'] = geocodeurl
                            geocode_result_json = urlfetch.fetch(geocodeurl).content
                            geocode = json.loads(geocode_result_json)
                            results_array = geocode[u'results']
                            if len(results_array) > 0:
                                venue['geocode'] = {}
                                venue['geocode']['lat'] = results_array[0][u'geometry'][u'location'][u'lat']
                                venue['geocode']['lng'] = results_array[0][u'geometry'][u'location'][u'lng']

                # store venue in storage
                # check if it already exists
                
                if not model.PointOfInterest.is_exist(venue['id']):
                    poi = model.PointOfInterest(id = venue['id'])
                    poi.url = venue['url']
                    poi.name = venue['name']
                    poi.address = venue['address']
                    if 'geocode' in venue:
                        poi.location = ('%g,%g' % (venue['geocode']['lat'], venue['geocode']['lng']))
                        
                    poi.put()
                    venue['is_new'] = True
                else:
                    venue['is_new'] = False

                venues.append(venue)

        self.emit_html({ 'venues': venues }, 'scraprest.html')
