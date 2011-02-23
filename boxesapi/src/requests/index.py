import os
import request
import main

from google.appengine.ext.webapp import template

class IndexRequest(request.Request):
    """Index page"""
    
    @classmethod
    def get_url(cls):
        return "/"
    
    def get(self):
        reqs = [ r.get_apidocs() for r in main.all_requests ]
        template_values = { 'reqs': reqs } 
        path = os.path.join(os.path.dirname(__file__), 'index.html')
        self.response.out.write(template.render(path, template_values))
