package project.views 
{
	import com.greensock.TweenLite;
	import delorean.navigation.DeloreanNavigator;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class AboutView extends ABasicView 
	{
		private var _aboutContent:MovieClip;
		private var _btHome:MovieClip;
		
		public function AboutView() 
		{
			
		}
		
		override protected function _init():void 
		{
			trace ("about parametro: ", dataParam)
			_aboutContent = dependencies.getContent ("about_assets");
			addChild (_aboutContent);
			
			_btHome = _aboutContent.btHome;
			_btHome.buttonMode = true;
			_btHome.addEventListener (MouseEvent.CLICK, _clickHome)
		}
		
		private function _clickHome(e:MouseEvent):void 
		{
			DeloreanNavigator.go ("home");
		}
		
	}

}