package delorean.navigation 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class ModalView extends View implements IModalView
	{
		public var blockAll:Boolean = false;
		public var lockerAlpha:Number = 0;
		public var lockerColor:uint = 0;
		protected var _locker:Sprite;
		
		public function ModalView() 
		{
			super();
			// mudar opção blockAll no construtor
		}
		
		override protected function _init():void 
		{
			super._init();
			
			_buildLocker ();
		}
		
		private function _buildLocker():void 
		{
			_locker = new Sprite ();
			addChildAt (_locker, 0);
			_resizeLocker();
		}
		protected function _resizeLocker ():void
		{
			if (!_locker) return;
			_locker.graphics.clear();
			_locker.graphics.beginFill (lockerColor, lockerAlpha);
			_locker.graphics.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
			_locker.graphics.endFill();
		}
		
		override protected function _resize():void 
		{
			_resizeLocker();
		}
		
	}

}