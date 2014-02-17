package delorean.events
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	* This is a simple global event dispatcher
	* @author André Mattos - www.ma77os.com
	*/
	
	/**
	 [broadcast event] Dispatched when the Flash Player or AIR application operating
 loses system focus and is becoming inactive.
	 @eventType	flash.events.Event.DEACTIVATE
	 */
	[Event(name="deactivate", type="flash.events.Event")] 

	/**
	 [broadcast event] Dispatched when the Flash Player or AIR application gains  
 operating system focus and becomes active.
	 @eventType	flash.events.Event.ACTIVATE
	 */
	[Event(name="activate", type="flash.events.Event")] 
	[Event(name="activate", type="flash.events.Event")] 

	public class EventBroadcaster
	{
		private static var _eventDispatcher:EventDispatcher = new EventDispatcher ();
		
		public static function addEventListener (eventName:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			_eventDispatcher.addEventListener (eventName, listener, useCapture, priority, useWeakReference);
		}
		
		public static function removeEventListener (eventName:String, listener:Function, useCapture:Boolean = false):void
		{
			_eventDispatcher.removeEventListener (eventName, listener, useCapture);
		}
		
		public static function dispatchEvent (event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent (event);
		}
		
		public static function hasEventListener(type:String):Boolean 
		{
			return _eventDispatcher.hasEventListener (type);
		}
		
		public static function willTrigger(type:String):Boolean 
		{
			return _eventDispatcher.willTrigger (type);
		}
	}
}