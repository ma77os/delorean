package delorean.net
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Tiago Canzian
	 */
	public class ServiceEvent extends Event
	{
		public static const REQUEST_START:String    = "Request_Start";
		public static const REQUEST_COMPLETE:String = "Request_Complete";
		public static const REQUEST_ERROR:String    = "Request_Error";
		
		private var _request : Request;
		private var _param : String;
		
		public function ServiceEvent(type:String, request : Request = null, param : * = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			if (request) _request = request;
			if (param) _param = param; 
			super(type, bubbles, cancelable);
		}
		
		public function get request():Request {
			return _request;
		}
		
		public function get param():String {
			return _param;
		}

		public function get json():Object {
			return _request.json;
		}
		
		public function get rawContent():String {
			return _request.rawContent;
		}

	}
}