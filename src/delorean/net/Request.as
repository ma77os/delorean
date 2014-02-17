package delorean.net
{	
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	
	/**
	 * ...
	 * @author Tiago Canzian
	 */
	public class Request extends EventDispatcher {
		
		private var _json			: Object;
		private var urlLoader		: Object;
		private var urlRequest		: URLRequest;
		private var _rawContent		: String;
		
		public function Request(url : String, parameters : Object = null, encodeCall : Boolean = false, method : String = "POST") {
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			urlLoader.addEventListener(Event.OPEN, onOpen);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			urlRequest = new URLRequest(url);
			
			if(parameters) {
				
				var urlVariables:URLVariables = new URLVariables();
				

					if(encodeCall) {
						urlVariables["calls"] = JSON.encode(parameters);
						trace(JSON.encode (parameters))
						
					} else {
						for(var key:String in parameters) {
							urlVariables[key] = parameters[key];
						}
						
						urlVariables["timeRandom"] = new Date().time;
					}

				urlRequest.data = urlVariables;
			}
			
			urlRequest.method = method;
			urlLoader.load(urlRequest);
		}

		
		protected function onComplete(e:Event):void {
			rawContent = urlLoader.data;
			json = JSON.decode(rawContent);
			
			dispatchEvent(new ServiceEvent(ServiceEvent.REQUEST_COMPLETE, this));
		}
		
		protected function onOpen(e:Event):void {
//			trace("[Request] OPEN", e);
		}
		
		protected function onProgress(e:ProgressEvent):void {
			dispatchEvent(e);
		}
		
		protected function onSecurityError(e:SecurityErrorEvent):void {
			trace("[Request] Security Error", e);
			dispatchEvent(new ServiceEvent(ServiceEvent.REQUEST_ERROR, this));
		}
		
		protected function onHttpStatus(e:HTTPStatusEvent):void {
		}
		
		protected function onIOError(e:IOErrorEvent):void {
			trace("[Request] IO Error", e);
			dispatchEvent(new ServiceEvent(ServiceEvent.REQUEST_ERROR, this,e.text));
		}
		
		
		//GETTERS / SETTERS
		public function get rawContent():String {
			return _rawContent;
		}
		
		public function set rawContent(value:String):void {
			_rawContent = value;
		}
		
		public function get json():Object {
			return _json;
		}
		
		public function set json(value:Object):void {
			_json = value;
		}
		

	}
}