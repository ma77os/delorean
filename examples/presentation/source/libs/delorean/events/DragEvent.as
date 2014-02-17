package delorean.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class DragEvent extends Event 
	{
		public static const DRAG:String = "drag";
		public static const DROP:String = "drop";
		public static const MOVE:String = "move";
		
		public function DragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DragEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DragEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}