from google.appengine.ext import db

import logging
import tile

class DictModel(db.Model):
    def to_dict(self, with_key = None):
        d = dict([(prop_name, unicode(getattr(self, prop_name))) for prop_name in self.properties()])
        if with_key: 
            d[with_key] = str(self.key())
        return d

class Box(DictModel):
    """Stores static information about a box"""
    name = db.StringProperty()
    first_location = db.GeoPtProperty()
    
    @classmethod
    def query_by_boxid(cls, boxid):
        return Box.get(boxid)
        
class DroppedBox(DictModel):
    """Stores a box that is dropped somewhere in the world"""
    quadtile = db.StringProperty(required = True)
    boxid = db.StringProperty(required = True)
    worth = db.IntegerProperty()
    total_distance = db.FloatProperty()
    total_hands = db.IntegerProperty()
    drop_location = db.GeoPtProperty()
    drop_message = db.StringProperty()
    
    @classmethod
    def query_by_quadkey(cls, quad_prefix):
        # calculate next quad prefix for query by prefix.        
        next_quad_prefix = quad_prefix[:-1] + unichr(ord(quad_prefix[-1:]) + 1)

        # query by quad prefix
        boxes = DroppedBox.all()
        boxes.filter("quadtile >=", quad_prefix)
        boxes.filter("quadtile <", next_quad_prefix)
        
        return boxes

    @classmethod
    def query_by_location(cls, lat, long, zoom):
        quad_prefix = tile.location_to_quadtile(lat, long, zoom)
        logging.info('quad_prefix = %s' % quad_prefix)
        return cls.query_by_quadkey(quad_prefix)

class History(DictModel):
    """Stores an event in the box history"""
    boxid = db.StringProperty(required = True)
    drop_timestamp = db.DateTimeProperty(required = True, auto_now_add = True)
    drop_location = db.GeoPtProperty()
    drop_message = db.StringProperty()
    drop_picture = db.URLProperty()
    next_picker = db.StringProperty()
    next_picker_timestamp = db.DateTimeProperty()
    
    @classmethod
    def query_by_boxid(cls, boxid):
        return History.all().filter('boxid =', boxid).order('-drop_timestamp')
    
    @classmethod
    def get_last_drop(cls, boxid):
        return cls.query_by_boxid(boxid).fetch(1)[0]
