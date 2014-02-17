package delorean.controls.sliders 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 * TODO: arrumar esses scrolls....
	 */
	public class ArrowsBarSlider extends SimpleSlider
	{
		private const SCROLL_AMOUNT_DIV:Number = 100;
		private var _scrollAmount:Number;
		
		public function ArrowsBarSlider(pView:MovieClip = null) 
		{
			super(pView);
			
			view.arrowMinus.buttonMode = true;
			view.arrowMinus.addEventListener(MouseEvent.MOUSE_DOWN, _arrowDown, false, 0, true);
			view.arrowMore.buttonMode = true;
			view.arrowMore.addEventListener(MouseEvent.MOUSE_DOWN, _arrowDown, false, 0, true);
			
			_updateScrollAmount ();
			
		}
		
		private function _arrowDown(e:MouseEvent):void 
		{
			view.stage.addEventListener(MouseEvent.MOUSE_UP, _arrowUp, false, 0, true);
			view.addEventListener (Event.ENTER_FRAME, _updatePan, false, 0, true);
			_updateScrollAmount();
			_scrollAmount = e.target == view.arrowMore ? _scrollAmount : -_scrollAmount;
			_updatePan ();
		}
		
		private function _arrowUp(e:MouseEvent):void 
		{
			view.stage.removeEventListener(MouseEvent.MOUSE_UP, _arrowUp);
			view.removeEventListener (Event.ENTER_FRAME, _updatePan);
		}
		
		private function _updatePan(e:Event = null):void 
		{
			currentValue += _scrollAmount;
			dispatchEvent (new Event (Event.CHANGE));
		}
		
		private function _updateScrollAmount():void
		{
			_scrollAmount = (maxValue - minValue) / SCROLL_AMOUNT_DIV;
		}
	}

}