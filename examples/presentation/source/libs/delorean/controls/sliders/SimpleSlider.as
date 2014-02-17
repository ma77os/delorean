package delorean.controls.sliders 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author André Mattos - www.andremattos.net
	 */
	public class SimpleSlider extends ASlider
	{
		public static const TYPE_HOR:String = "typeHor";
		public static const TYPE_VER:String = "typeVer";
		
		protected var _areaRect:Rectangle;
		protected var _type:String;
		protected var _propPos:String;
		protected var _propSize:String;
		protected var _minPan:Number;
		protected var _maxPan:Number;
		protected var _originalTrackW:Number;
		protected var _originalTrackH:Number;
		protected var _minTrackLenght:Number;
		protected var _propMouse:String;
		protected var _panPosDest:Number;
		
		
		public function SimpleSlider(pView:MovieClip = null) 
		{
			super (pView || new SimpleSliderDefaultView());
			
			view.pan.buttonMode = true;
			view.pan.addEventListener (MouseEvent.MOUSE_DOWN, _dragPan, false, 0, true);
			view.track.addEventListener (MouseEvent.MOUSE_DOWN, _movePan, false, 0, true);
			
			_getOriginalOrientation ();
			_adjustOrientation ();
		}
		
		override protected function _movePan (e:Event):void
		{
			_panPosDest = view[_propMouse] + _mouseOffsetPosOnDrag[_propPos];
			
			if (_panPosDest < _minPan) _panPosDest = _minPan;
			else if (_panPosDest > _maxPan) _panPosDest = _maxPan;
			
			view.pan[_propPos] = _panPosDest;
			
			super.currentValue = _maxValue + (_panPosDest - _maxPan) * (_maxValue - _minValue) / (_maxPan-_minPan);
			super._movePan (e);
		}
		
		protected function _adjustOrientation():void
		{
			switch (_type)
			{
				case TYPE_VER:
					_propPos = "y";
					_propSize = "height";
					_propMouse = "mouseY"
					view.track.width = _minTrackLenght;
					view.track.height = _trackLenght;
					break;
				case TYPE_HOR:
					_propPos = "x";
					_propSize = "width";
					_propMouse = "mouseX"
					view.track.width = _trackLenght;
					view.track.height = _minTrackLenght;
					break;
			}
			_minPan = view.track[_propPos];
			_maxPan = _minPan + view.track[_propSize] - view.pan[_propSize];
			_areaRect = new Rectangle (view.track.x, view.track.y, view.track.width - view.pan.width, view.track.height - view.pan.height);
			
		}
		
		private function _getOriginalOrientation ():void
		{
			_originalTrackW = view.track.width;
			_originalTrackH = view.track.height;
			
			if (_originalTrackW < _originalTrackH)
			{
				_type = TYPE_VER;
				_minTrackLenght = _originalTrackW;
			}
			else
			{
				_type = TYPE_HOR;
				_minTrackLenght = _originalTrackH;
			}
		}
		
		override public function set currentValue(value:Number):void 
		{
			super.currentValue = value;
			view.pan[_propPos] = _maxPan + (super.currentValue - _maxValue) * (_maxPan - _minPan) / (_maxValue - _minValue);
		}
		
		override public function set trackLenght(value:Number):void 
		{
			super.trackLenght = value;
			_adjustOrientation ();
		}
		
		public function get type():String { return _type; }
		
		public function set type(value:String):void 
		{
			if (value != TYPE_VER && value != TYPE_HOR) return;
			_type = value;
			_adjustOrientation ();
		}
	}
	
}
import flash.display.MovieClip;
import flash.display.Sprite;

class SimpleSliderDefaultView extends MovieClip
{
	public var pan:Sprite;
	public var track:Sprite;
	public function SimpleSliderDefaultView()
	{
		track = new Sprite ();
		track.graphics.beginFill (0x777777);
		track.graphics.drawRect (0, 0, 15, 160);
		track.graphics.endFill ();
		addChild (track);
		
		pan = new Sprite ();
		pan.graphics.beginFill (0xCCCCCC);
		pan.graphics.drawRect (0, 0, 15, 20);
		pan.graphics.endFill ();
		addChild (pan);
	}
}