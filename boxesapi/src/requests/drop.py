import request
import apidocs
import model
import tile

class DropRequest(request.Request):
    """Drops a box at a certain location"""
    
    @classmethod
    def get_url(cls):
        return "/drop"
    
    @classmethod
    def get_usages(cls):
        return [ apidocs.UsageDoc('?boxid=<i>boxid</i>&lat=<i>latitude</i>&long=<i>longitude</i>[&message=<i>message</i>]&token=<i>user token</i>', 'drops a box at the specified location, optionally including a message') ]
    
    def get(self):
        if not self.required_field('boxid'): return
        if not self.required_field('lat'): return
        if not self.required_field('long'): return
        userid = self.userid_from_token()
        if not userid: return;
        
        boxid = self.request.get('boxid')
        lat = float(self.request.get('lat'))
        long = float(self.request.get('long'))
        message = self.request.get('message')
        
        # verify last drop was picked up
        last_drop = model.History.get_last_drop(boxid)
        if not last_drop.next_picker or last_drop.next_picker == "":
            self.conflict('box already dropped')
            return
        
        new_entry = model.History(boxid = boxid)
        new_entry.drop_location = '%f,%f' % (lat, long)
        new_entry.drop_message = message
        new_entry.put()
        
        quadtile = tile.location_to_quadtile(lat, long, 18) # 18 is like in the pickup
        dropped = model.DroppedBox(quadtile = quadtile, boxid = boxid)         
        #dropped.worth = db.IntegerProperty()
        #dropped.total_distance = db.FloatProperty()
        #dropped.total_hands = db.IntegerProperty()
        dropped.drop_location = new_entry.drop_location
        dropped.drop_message = message
        dropped.put()
        
        # remove from my boxes
        myBoxes = model.MyBox.all().filter('userid =', userid).filter('boxid =', boxid)
        for b in myBoxes: b.delete()
        
        self.emit_text("box dropped")
