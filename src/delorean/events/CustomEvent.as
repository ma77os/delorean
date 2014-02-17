package delorean.events {
	
	import flash.events.Event;
	
	
	public class CustomEvent extends Event {
		
		public static const NEXT:String = "CustomEvent_Next";
		public static const PREV:String = "CustomEvent_Prev";
		public static const SHOW:String = "CustomEvent_Show";
		public static const HIDE:String = "CustomEvent_Hide";
		public static const SELECT:String = "CustomEvent_Select";
		public static const UNSELECT:String = "CustomEvent_Unselect";
		public static const REMOVED:String = "CustomEvent_Removed";
		public static const REMOVE:String = "CustomEvent_Remove";
		public static const ENABLE:String = "CustomEvent_Enable";
		public static const DISABLE:String = "CustomEvent_Disable";
		public static const UPDATE:String = "CustomEvent_Update";
		public static const FILTER:String = "CustomEvent_Filter";
		public static const OPEN:String = "CustomEvent_Open";
		public static const CLOSE:String = "CustomEvent_Close";
		public static const ADDED:String = "CustomEvent_Added";
		public static const REFRESH:String = "CustomEvent_Refresh";
		public static const PROGRESS:String = "CustomEvent_Progress";
		public static const ERROR:String = "CustomEvent_Error";
		public static const FINISH:String = "CustomEvent_Finish";
		
		
		public var param:*;
		
		public function CustomEvent(type:String, param:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.param = param;
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event 
		{ 
			return new CustomEvent(type, param, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CustomEvent", "param", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}