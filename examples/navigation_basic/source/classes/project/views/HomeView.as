package project.views 
{
	import com.greensock.TweenLite;
	import delorean.navigation.DeloreanNavigator;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import delorean.parameters.getParam;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class HomeView extends ABasicView
	{
		public var btAbout:MovieClip;
		
		public function HomeView() 
		{
			
			btAbout.buttonMode = true;
			btAbout.addEventListener (MouseEvent.CLICK, _clickAbout);
		}
		
		private function _clickAbout(e:MouseEvent):void 
		{
			DeloreanNavigator.go ("about");
		}
		
	}

}