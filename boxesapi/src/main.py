from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

import requests.index
import requests.populate
import requests.box
import requests.drop
import requests.map
import requests.pickup
import requests.history
import requests.control

all_requests = [ requests.index.IndexRequest, 
                 requests.map.MapRequest, 
                 requests.box.BoxRequest, 
                 requests.populate.PopulateRequest,
                 requests.drop.DropRequest,
                 requests.pickup.PickupRequest,
                 requests.history.HistoryRequest,
                 requests.control.ControlRequest ]

url_mapping = [ (r.get_url(), r) for r in all_requests ] 

application = webapp.WSGIApplication(url_mapping, debug = True)

def main():
    run_wsgi_app(application)

if __name__ == "__main__":
    main()
