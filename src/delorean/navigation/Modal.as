package delorean.navigation 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class Modal extends View 
	{
		protected var _locker:Sprite;
		private var _lockerColor:uint = 0;
		private var _lockerAlpha:Number = 0;
		private var _blockBehind:Boolean;
		
		public function Modal() 
		{
			super();
			
		}
		
		public function close (...e):void
		{
			DeloreanNavigator.closeModal (id);
		}
		
		override protected function _init():void 
		{
			super._init();
			
			if (_blockBehind) _buildLocker();
		}
		
		private function _buildLocker():void 
		{
			_locker = new Sprite ();
			parent.addChildAt (_locker, 0);
			_resizeLocker();
		}
		protected function _resizeLocker ():void
		{
			if (!_locker || !stage) return;
			_locker.graphics.clear();
			_locker.graphics.beginFill (_lockerColor, _lockerAlpha);
			_locker.graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
			_locker.graphics.endFill();
		}
		
		override protected function _resize():void 
		{
			_resizeLocker();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (_locker && parent)
			{
				if (parent.contains(_locker)) parent.removeChild (_locker);
				_locker = null;
			}
			
		}
		
		public function get blockBehind():Boolean 
		{
			return _blockBehind;
		}
		
		public function set blockBehind(value:Boolean):void 
		{
			_blockBehind = value;
			if (!parent) return;
			if (!_locker) _buildLocker();
			_locker.visible = value;
		}
		
		public function get lockerAlpha():Number 
		{
			return _lockerAlpha;
		}
		
		public function set lockerAlpha(value:Number):void 
		{
			_lockerAlpha = value;
		}
		
		public function get lockerColor():uint 
		{
			return _lockerColor;
		}
		
		public function set lockerColor(value:uint):void 
		{
			_lockerColor = value;
		}
		
	}

}