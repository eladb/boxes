from google.appengine.ext import db

import model
import tile
import request

class PopulateRequest(request.Request):
    """Repopulates the storage with test boxes"""
    
    @classmethod
    def get_url(cls):
        return "/populate"
    
    def create_box(self, name, lat, long):
        latlongstring = '%f,%f' % (lat, long)

        new_box = model.Box(name = name)
        new_box.put()
        quad = tile.location_to_quadtile(lat, long, 18)
        
        dropped_box = model.DroppedBox(quadtile = quad, boxid = str(new_box.key()))
        dropped_box.drop_location = latlongstring 
        dropped_box.put()
        
        hi = model.History(boxid = str(new_box.key()))
        hi.drop_location = latlongstring
        hi.drop_message = 'initial drop'
        hi.put()
        
        self.response.out.write("box '%s' created in %f, %f quadtile '%s' (boxid: %s) drop location: %s\n" % (name, lat, long, quad, str(new_box.key()), hi.drop_location))
    
    def get(self):
        self.response.headers['Content-Type'] = "application/json"
        for d in model.Box.all(): d.delete
        for d in model.DroppedBox.all(): d.delete()
        self.create_box("mybox1", 32.089047, 34.78024)
        self.create_box("mybox2", 32.091919, 34.78130)
        self.create_box("mybox3", 32.088201, 34.78229)
        self.create_box("mybox3", 32.085847, 34.77930)
        self.response.out.write('storage re-populated.')
