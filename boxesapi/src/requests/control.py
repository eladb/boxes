import request

class ControlRequest(request.Request):
	@classmethod
	def get_url(cls):
		return "/control"
	
	def get(self):
		self.emit_text('under construction')