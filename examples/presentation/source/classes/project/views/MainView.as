package project.views 
{
	import delorean.navigation.View;
	import flash.display.Shape;
	import project.views.main.Bg;
	
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