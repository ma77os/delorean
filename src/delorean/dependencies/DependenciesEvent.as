package delorean.dependencies 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class DependenciesEvent extends Event 
	{
		public static const LOAD_PROGRESS:String = "loadProgress";
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		private var _pct:Number=0;
		public function DependenciesEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new DependenciesEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("DependenciesEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get pct():Number 
		{
			return _pct;
		}
		
		public function set pct(value:Number):void 
		{
			_pct = value;
		}
		
	}
	
}