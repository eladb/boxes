import request
import apidocs
import model

class MyRequest(request.Request):
    """Returns my boxes"""
    
    @classmethod
    def get_url(cls):
        return "/my"
    
    @classmethod
    def get_usages(cls):
        return [ apidocs.UsageDoc('?token=<i>user token</i>', 'returns my boxes') ]
    
    def get(self):
        userid = self.userid_from_token()
        if not userid: return
        
        myboxes = model.MyBox.all().filter('userid =', userid)
        
        result = { }
        result['boxes'] = [mybox.to_dict() for mybox in myboxes]
        self.emit_json(result)
  