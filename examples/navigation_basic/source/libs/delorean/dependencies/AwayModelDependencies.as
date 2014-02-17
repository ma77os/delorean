package delorean.dependencies 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class AwayModelDependencies extends EventDispatcher implements IDependencies 
	{
		
		public function AwayModelDependencies() 
		{
			super();
			
		}
		
		/* INTERFACE delorean.dependencies.IDependencies */
		
		public function add(id:String, url:String):void 
		{
			
		}
		
		public function load():void 
		{
			
		}
		
		public function getContent(id:String):* 
		{
			
		}
		
		public function dispose():void 
		{
			
		}
	}
}