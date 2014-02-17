package delorean.navigation 
{
	import delorean.data.TreeNode;
	import flash.events.Event;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class ARootView extends View 
	{
		
		public function ARootView() 
		{
			super();
			
		}
		
		override protected function _added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, _added);
			
			
		}
		
		override protected function _init():void 
		{			
			
		}
		
	}

}