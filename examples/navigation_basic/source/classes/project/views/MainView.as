package project.views 
{
	import delorean.navigation.View;
	import flash.display.Shape;
	import project.views.main.Bg;
	import flash.events.MouseEvent;
	import delorean.navigation.DeloreanNavigator;
	import delorean.navigation.ViewEvent;
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class MainView extends View 
	{
		public var bg:Bg;
		public function MainView() 
		{
			super();
			
		}
		
		
		
		
		override protected function _init():void 
		{
			bg = new Bg ();
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;
			addChild (bg);
			
			addChild (_childContainer);
		}
		
	}

}