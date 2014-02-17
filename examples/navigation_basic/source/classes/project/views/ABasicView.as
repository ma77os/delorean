package project.views 
{
	import com.greensock.TweenLite;
	import delorean.navigation.View;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class ABasicView extends View 
	{
		
		public function ABasicView() 
		{
			super();
			alpha = 0;
		}
		
		
		
		override protected function _showTransition():void
		{
			TweenLite.to (this, 0.5, {alpha:1, onComplete:_transition.notifyComplete});
		}
			override protected function _hideTransition():void
			{
				TweenLite.to (this, 0.5, {alpha:0, onComplete:_transition.notifyComplete});
			}
	}

}