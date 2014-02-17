package delorean.events {
	
	import flash.events.Event;
	
	/**
	 * ...
	 */
	public class CustomEvent extends Event {
		
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
		
		
		public var param:*;
		
		public function CustomEvent(type:String, param:* = null, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super(type, bubbles, cancelable);
			
			this.param = param;
		}
		
	}
	
}