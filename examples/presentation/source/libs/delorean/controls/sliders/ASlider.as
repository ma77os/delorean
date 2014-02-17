package delorean.controls.sliders
{
	import delorean.events.DragEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author André Mattos - www.andremattos.net
	 */
	public class ASlider extends EventDispatcher
	{
		public var view:MovieClip;
		protected var _minValue:Number = 1;
		protected var _maxValue:Number = 2;
		protected var _roundedValues:Boolean = false;
		protected var _isDragging:Boolean = false;
		protected var _trackLenght:Number;
		protected var _mouseOffsetPosOnDrag:Point = new Point ();
		
		private var _currentValue:Number = 1;
		private var _oldValue:Number = _currentValue;
		
		
		public function ASlider(pView:MovieClip) 
		{
			super ();
			view = pView;
		}
		
		public function reset():void
		{
			currentValue = minValue;
		}
		
		protected function _dragPan (evt:MouseEvent):void
		{
			_mouseOffsetPosOnDrag.x = view.pan.x - view.mouseX;
			_mouseOffsetPosOnDrag.y = view.pan.y - view.mouseY;
			
			view.stage.addEventListener (MouseEvent.MOUSE_UP, _dropPan);
			view.addEventListener (Event.ENTER_FRAME, _movePan);
			
			_isDragging = true;
			dispatchEvent (new DragEvent (DragEvent.DRAG));
		}
		
		protected function _dropPan (evt:MouseEvent):void
		{
			view.stage.removeEventListener (MouseEvent.MOUSE_UP, _dropPan);
			view.removeEventListener (Event.ENTER_FRAME, _movePan);
			_movePan (null)
			_isDragging = false;
			dispatchEvent (new DragEvent (DragEvent.DROP));
		}
		
		protected function _movePan (evt:Event):void
		{
			if (_currentValue == _oldValue) return
			
			dispatchEvent (new Event (Event.CHANGE));
			
			_oldValue = _currentValue
		}
		
		private function get invertedMinMax ():Boolean
		{
			return _minValue > _maxValue;
		}
		
		public function get minValue():Number { return _minValue; }
		
		public function set minValue(value:Number):void 
		{
			_minValue = value;
		}
		
		public function get maxValue():Number { return _maxValue; }
		
		public function set maxValue(value:Number):void 
		{
			_maxValue = value;
		}
		
		public function get currentValue():Number { return  _currentValue; }
		
		public function set currentValue(value:Number):void 
		{
			if (invertedMinMax) 
			{
				if (value > _minValue) value = _minValue;
				else if (value < _maxValue) value = _maxValue;
			}
			else
			{
				if (value < _minValue) value = _minValue;
				else if (value > _maxValue) value = _maxValue;
			};
				
			_currentValue = _roundedValues ? Math.round(value) : value;
		}
		
		public function get roundedValues():Boolean { return _roundedValues; }
		
		public function set roundedValues(value:Boolean):void 
		{
			_roundedValues = value;
		}
		
		public function get trackLenght():Number { return _trackLenght; }
		
		public function set trackLenght(value:Number):void 
		{
			_trackLenght = value;
		}
		
		public function get isDragging():Boolean 
		{
			return _isDragging;
		}
		
	}
	
}