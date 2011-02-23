import model
import request
import apidocs

class BoxRequest(request.Request):
    """Query box information"""
    
    @classmethod
    def get_url(cls):
        return "/box"
    
    @classmethod
    def get_usages(cls):
        return [ apidocs.UsageDoc("?id=<i>boxid</i>", "returns information about a box with the specified <i>boxid</i>", "?id=aghib3hlc2FwaXIJCxIDQm94GEMM") ]

    def get(self):
        if not self.required_field('id'): return

        boxid = self.request.get('id')
        box = model.Box.query_by_boxid(boxid)
        self.emit_json(box.to_dict(with_key = 'boxid'))
