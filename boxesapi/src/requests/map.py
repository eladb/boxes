import model
import tile
import request
import apidocs

class MapRequest(request.Request):
    """Returns a map of all the dropped boxes in a certain geo-location"""

    @classmethod
    def get_url(cls):
        return "/map"
    
    @classmethod
    def get_usages(cls):
        htmldoc = "adding the 'html=yes' attribute will return an html page with the map"
        return [
            apidocs.UsageDoc("?quad_prefix=<i>quad key prefix</i>[&html=yes]", 'queries by geo-quad-key prefix. ' + htmldoc, '?quad_prefix=1221122232311&html=yes'),
            apidocs.UsageDoc('?lat=<i>latitide</i>&long=<i>longitude</i>&zoom=<i>zoom level</i>[&html=yes]', 'queries by lat,long and zoom level. ' + htmldoc, '?lat=32.08&long=34.78&zoom=13') ]
    
    def get(self):
        # get quad prefix from parameters (either using lat,lng,zoom or quad)
        quad_prefix = self.get_quad_prefix_from_params()
        if quad_prefix is None: return

        boxes = model.DroppedBox.query_by_quadkey(quad_prefix)

        is_html = self.request.get('html') == 'yes'
        
        result = dict()
        result['quad_prefix'] = quad_prefix
        result['boxes'] = [box.to_dict() for box in boxes]
        result['count'] = boxes.count()
        
        for x in result['boxes']:
            lat_and_lon = x['drop_location'].partition(',')
            lat = lat_and_lon[0]
            lon = lat_and_lon[2]
            x['drop_location_lat'] = lat
            x['drop_location_lon'] = lon

        if not is_html:
            self.emit_json(result)
        else:
            self.emit_html(result, 'map.html')
        
    def get_quad_prefix_from_params(self):
        quad_prefix = self.request.get('quad_prefix')
        
        if quad_prefix == "":
            if self.request.get('lat') == "" or self.request.get('long') == "":
                self.bad_request("either'quad_prefix' or 'lat' and 'long' parameters should be specified (you can use 'zoom' to specify a different zoom level)")
                return None

            lat = float(self.request.get('lat'))
            long = float(self.request.get('long'))
            zoom = self.request.get('zoom')
            
            if zoom == "": zoom = 6
            else: zoom = int(zoom)
            
            quad_prefix = tile.location_to_quadtile(lat, long, zoom)

        return quad_prefix
        