import globalmaptiles as tilesystem

def location_to_quadtile(lat, long, zoom):
    """Converts a location given by latitude and longitude coordinates into a 
    quad-tile with a specific zoom level
    @param lat: latitude coordinate
    @param long: longitude coordinate
    @param zoom: the zoom level to use
    @return: the quad tile string
    """ 
    m = tilesystem.GlobalMercator()
    mx, my = m.LatLonToMeters(lat, long)
    tx, ty = m.MetersToTile(mx, my, zoom)
    quad = m.QuadTree(tx, ty, zoom)
    return quad
