package 
{
	import delorean.builders.DefaultDeloreanBuilder;
	import delorean.navigation.DeloreanNavigator;
	import delorean.navigation.View;
	import flash.events.Event;
	import project.views.AboutView;
	import project.views.HomeView;
	import project.views.MainView;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	[SWF(width='1200', height='700', backgroundColor='#FFFFFF', frameRate='60')]
	public class Main_old extends View 
	{
		private var deloreanBuilder:DefaultDeloreanBuilder;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			// CACHING CLASSES
			MainView; HomeView; AboutView;
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			deloreanBuilder = new DefaultDeloreanBuilder (this, "xml/config.xml");
			deloreanBuilder.addEventListener (Event.COMPLETE, _onBuilderComplete);
		}
		
		private function _onBuilderComplete(e:Event):void 
		{
			deloreanBuilder.removeEventListener (Event.COMPLETE, _onBuilderComplete);
			deloreanBuilder = null;
			
			DeloreanNavigator.go ("home");
		}
		
	}
	
}