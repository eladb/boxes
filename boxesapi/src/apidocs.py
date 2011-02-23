"""Creates an HTML page that describes the API of the application"""

class RequestDoc:
    url = ''
    doc = ''
    usages = []
    
    def __init__(self, reqCls):
        self.url = reqCls.get_url()
        if reqCls.__doc__: self.doc = reqCls.__doc__
        else: self.doc = ''
        self.usages = reqCls.get_usages()

class UsageDoc:
    usage = ''
    doc = ''
    sample = ''
    def __init__(self, usage, doc = None, sample = None):
        self.usage = usage
        if doc: self.doc = doc
        else: self.doc = ''
        if sample: self.sample = sample
        else: self.sample = ''
    