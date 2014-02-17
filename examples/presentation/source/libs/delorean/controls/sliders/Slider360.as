package delorean.controls.sliders
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.andremattos.math.TrigoBasic;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class Slider360 extends ASlider
	{
		private var _radiusX:Number = 100;
		private var _radiusY:Number = 100;
		private var _angle:Number = 0;
		private var _drawedTrack:Boolean = true;
		private var _initAngle:Number = 0;
		private var _initAnglePositive:Number = 0;
		private var _endAngle:Number = 0;
		private var _piPlus2:Number = Math.PI * 2;
		private var _middleGapAngle:Number;
		
		public function Slider360(pView:MovieClip = null) 
		{
			super (pView);
			_trackLenght = _piPlus2;
			_adjustEndAngle ();
			
			_adjustPanPosition ();
			_drawTrack ();
			
			view.pan.buttonMode = true;
			view.pan.addEventListener (MouseEvent.MOUSE_DOWN, _dragPan);
		}
		
		override protected function _movePan (evt:Event):void
		{
			_angle = Math.atan2 (view.mouseY, view.mouseX);
			_correctAndLimitAngle ();
			
			// updating value
			super.currentValue = _maxValue + (_angle - _endAngle) * (_maxValue - _minValue) / (_endAngle - _initAngle);
			
			_adjustPanPosition ();
		}
		
		private function _correctAndLimitAngle ():void
		{
			// correcting angle to be positive from 0 to Math.PI * 2
			if (_angle < _initAngle ) _angle += _piPlus2;
			
			// limiting angle to drag only between _initAngle and _endAngle
			if (_angle > _endAngle)
			{
				if (_angle <= _middleGapAngle) _angle = _endAngle;
				else _angle = _initAngle;
			}
		}
		
		private function _adjustPanPosition ():void
		{
			view.pan.x = Math.cos (_angle) * _radiusX;
			view.pan.y = Math.sin (_angle) * _radiusY;
			super._movePan (null)
			
		}
		
		private function _adjustAngleByParam ():void
		{
			_angle = _endAngle + (super.currentValue - _maxValue) * (_endAngle - _initAngle) / (_maxValue - _minValue);

			_adjustPanPosition ();
		}
		
		private function _adjustEndAngle ():void
		{
			_endAngle = _initAngle + _trackLenght;
			_middleGapAngle = _endAngle + (_piPlus2 + _initAngle - _endAngle) / 2;
		}
		
		private function _drawTrack():void
		{
			if (!_drawedTrack) return;
			
			if (view.track == null)
			{
				view.track = new Sprite ();
				view.addChildAt (view.track, 0)
			}
			else
				view.track.graphics.clear ();
				
			view.track.graphics.lineStyle (5, 0xFF0000, 1);
			view.track.graphics.moveTo (Math.cos (_initAngle) * _radiusX, Math.sin (_initAngle) * _radiusY);
			for (var a:Number = _initAngle + 0.01; a < _endAngle; a += 0.01)
			{
				var x:Number = Math.cos (a) * _radiusX;
				var y:Number = Math.sin (a) * _radiusY;
				view.track.graphics.lineTo (x, y);
			}
			
			view.track.cacheAsBitmap = true;
		}
		
		override public function set trackLenght(value:Number):void 
		{
			_trackLenght = TrigoBasic.degreesToRadians(value);
			_adjustEndAngle ();
			_drawTrack ();
			_adjustAngleByParam ();
		}
		
		override public function set currentValue(value:Number):void 
		{
			super.currentValue = value;
			_adjustAngleByParam ();
		}
		
		public function get radiusX():Number { return _radiusX; }
		
		public function set radiusX(value:Number):void 
		{
			_radiusX = value;
			_drawTrack ()
		}
		
		public function get radiusY():Number { return _radiusY; }
		
		public function set radiusY(value:Number):void
		{
			_radiusY = value;
			_drawTrack ()
		}
		
		public function get drawedTrack():Boolean { return _drawedTrack; }
		
		public function set drawedTrack(value:Boolean):void 
		{
			_drawedTrack = value;
			if (_drawedTrack) 
				_drawTrack ();
			else
			{
				if (view.track != null) view.track.visible = false;
			}
		}
		
		public function get initAngle():Number { return _initAngle; }
		
		public function set initAngle(value:Number):void 
		{
			_initAngle = TrigoBasic.degreesToRadians(value);
			_initAnglePositive = _initAngle < 0 ? _initAngle + _piPlus2 : _initAngle;
			_adjustEndAngle ();
			_adjustAngleByParam ();
			
		}
		
	}
	
}