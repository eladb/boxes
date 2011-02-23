import request
import apidocs
import model

class HistoryRequest(request.Request):
    """Shows the history of a box"""
    
    @classmethod
    def get_url(cls): return "/history"
    
    @classmethod
    def get_usages(cls): return [ apidocs.UsageDoc('?boxid=<i>boxid</i>') ]
    
    def get(self):
        if not self.required_field('boxid'): return

        boxid = self.request.get('boxid')
        history_query = model.History.query_by_boxid(boxid)
        
        result = dict()
        result['count'] = history_query.count()
        result['history'] = [h.to_dict() for h in history_query]
        
        is_html = self.request.get('html') == 'yes'
        
        if not is_html:
            self.emit_json(result)
        else:
            self.emit_html(result, 'history.html')
            