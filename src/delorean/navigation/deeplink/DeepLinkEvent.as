package delorean.navigation.deeplink 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class DeepLinkEvent extends Event 
	{
		private var _id:*;
		private var _dataParam:*;
		public static const CHANGE:String = "change";
		public function DeepLinkEvent(type:String, id:*=null, dataParam:*=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			_id = id;
			_dataParam = dataParam;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DeepLinkEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DeepLinkEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get dataParam():* 
		{
			return _dataParam;
		}
		
		public function set dataParam(value:*):void 
		{
			_dataParam = value;
		}
		
		public function get id():* 
		{
			return _id;
		}
		
		public function set id(value:*):void 
		{
			_id = value;
		}
		
	}
	
}