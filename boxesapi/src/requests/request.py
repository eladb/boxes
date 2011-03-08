import os
import apidocs

from google.appengine.ext import webapp
from google.appengine.ext.webapp import template
from django.utils import simplejson as json

class Request(webapp.RequestHandler):
    """Base class for requests"""

    def emit_text(self, message):
        self.response.headers['Content-Type'] = "text/plain"
        self.response.out.write(message)

    def emit_error(self, status, message):
        self.emit_text(message + '\n')
        self.response.set_status(status)
    
    def bad_request(self, message):
        self.emit_error(400, message)

    def conflict(self, message):
        self.emit_error(409, message)
        
    def emit_json(self, dict):
        self.response.headers['Content-Type'] = "application/json"
        self.response.out.write(json.dumps(dict))
        
    def emit_html(self, dict, html):
        path = os.path.join(os.path.dirname(__file__), html)
        self.response.out.write(template.render(path, dict))
        
    def field_provided(self, fieldname):
        fieldvalue = self.request.get(fieldname)
        return fieldvalue and fieldvalue != ""
    
    def required_field(self, fieldname):
        if not self.field_provided(fieldname):
            self.bad_request("missing parameter: %s" % fieldname)
            return False
        return True

    def userid_from_token(self):
        if not self.required_field('token'): return None
        # TODO: in the meantime, token==userid
        return self.request.get('token')

    @classmethod
    def get_apidocs(cls):
        return apidocs.RequestDoc(cls)
    
    @classmethod
    def get_url(cls):
        raise NotImplementedError("get_url must be implemented for all requests")
    
    @classmethod
    def get_usages(cls):
        return [ apidocs.UsageDoc("", "", "") ]
    