package delorean.net
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;

	/**
	 * ...
	 * @author Tiago Canzian
	 */
	public class Service extends EventDispatcher {
		
		private var _id 		: String;
		private var _url		: String;
		private var _params		: Object;
		private var _method		: String;
		private var _data		: Object;
		private var _rawContent	: String;
		private var _encode		: Boolean = false;
		private var _callback	: Function;
		private var _error		: Function;
		public var errorType	: String;
		
		public function Service(serviceId:String,serviceURL:String,serviceParams:Object = null,serviceMethod:String = 'POST') {
			_id = serviceId;
			_url = serviceURL;
			_params = serviceParams;
			_method = serviceMethod;
			_encode = encode;
		}
		
		
		
		public function onComplete(callback:Function):Service {
			_callback = callback;
			
			return this;
		}
		
		public function onError(callback:Function):Service {
			_error = callback;
			
			return this;
		}
		
		public function complete() : void {
  			if (_callback != null) _callback(this);
		}
		
		public function error() : void {
			
			if (_error != null) _error(this);
		}

		
		public function get method():String {
			return _method;
		}

		
		public function get params():Object {
			return _params;
		}


		public function get url():String {
			return _url;
		}


		public function get id():String {
			return _id;
		}
		
		
		public function get data():Object {
			return _data;
		}
		
		public function set data(value:Object):void {
			_data = value;
		}
		
		
		public function get rawContent():String {
			return _rawContent;
		}
		
		public function set rawContent(value:String):void {
			_rawContent = value;
		}
		
		public function get encode():Boolean {
			return _encode;
		}
		
		public function set encode(value:Boolean):void {
			_encode = value;
		}
		
		

	}
}