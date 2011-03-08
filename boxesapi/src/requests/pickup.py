import request
import apidocs
import model
import datetime
import logging

class PickupRequest(request.Request):
    """Pick up a dropped box"""
    
    @classmethod
    def get_url(cls):
        return "/pickup"
    
    @classmethod
    def get_usages(cls):
        return [ apidocs.UsageDoc('?boxid=<i>boxid</i>&token=<i>token</i>', 'pick up a dropped box', '?boxid=aghib3hlc2FwaXIJCxIDQm94GEMM&token=1234') ]
    
    def find_my_dropped_box(self, boxes_by_location, boxid):
        for dropped_box in boxes_by_location:
            if dropped_box.boxid == boxid:
                return dropped_box
        
        return None
    
    def get(self):
        if not self.required_field('boxid'): return

        # validate token
        userid = self.userid_from_token()
        if not userid: return

        # make sure last drop is still not picked up already
        boxid = self.request.get('boxid')
        
        last_drop = model.History.get_last_drop(boxid)
        
        # if the next picker timestamp exist, return an error
        if last_drop.next_picker_timestamp:
            self.conflict("box was already picked up")
            return

        last_drop.next_picker_timestamp = datetime.datetime.utcnow()
        last_drop.next_picker = userid
        last_drop.put()

        # add to my boxes
        mybox = model.MyBox(userid = userid, boxid = boxid, picked_at = last_drop.drop_location, drop_message = last_drop.drop_message)
        mybox.put()
        
        boxes_by_location = model.DroppedBox.query_by_location(last_drop.drop_location.lat, last_drop.drop_location.lon, 18)
        
        logging.info(boxes_by_location)
        
        if boxes_by_location.count() == 0:
            self.conflict("unable to find box in map")
            return
        
        # remove the dropped box from the map
        my_dropped_box = self.find_my_dropped_box(boxes_by_location, boxid)
        my_dropped_box.delete()
        
        # we are done. send 200 ok
        self.emit_text("box picked up successfuly")
