package delorean.navigation 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class ViewEvent extends Event 
	{
		public static const DELOREAN_GO:String = "deloreanGo";
		public static const CHILD_LOAD_START:String = "childLoadStart";
		public static const CHILD_LOAD_PROGRESS:String = "childLoadProgress";
		public static const CHILD_LOAD_COMPLETE:String = "childLoadComplete";
		public static const CHILD_DISPOSED:String = "childDisposed";
		
		private var _pct:Number;
		private var _viewId:String;
		
		public function ViewEvent(type:String, id:String = null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			_viewId = id;
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ViewEvent(type, _viewId, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ViewEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get pct():Number 
		{
			return _pct;
		}
		
		public function set pct(value:Number):void 
		{
			_pct = value;
		}
		
		public function get viewId():String { return _viewId; }
		
		public function set viewId(value:String):void 
		{
			_viewId = value;
		}
		
	}
	
}