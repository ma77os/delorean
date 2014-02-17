package delorean.navigation 
{
	import delorean.dependencies.IDependencies;
	import delorean.transition.TransitionController;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class View extends MovieClip 
	{
		public var id:*;
		public var dataParam:*;
		public var dependencies:IDependencies;
		protected var _isModal:Boolean = false;
		protected var _modalBlockAll:Boolean = false;
		protected var _childView:View;
		protected var _rootView:View;
		protected var _parentView:View;
		protected var _childContainer:Sprite;
		protected var _transition:TransitionController;
		
		public function View() 
		{
			super();
			
			_childContainer = new Sprite();
			addChild (_childContainer);
			
			
			_transition = new TransitionController ();
			
			addEventListener (Event.ADDED_TO_STAGE, _added);
			addEventListener (Event.REMOVED_FROM_STAGE, _removed);
		}
		
		public function show (delay:Number = 0, onComplete:Function = null, ...onCompleteParams):void
		{
			_transition.call.apply (null, [_showTransition, delay, onComplete].concat(onCompleteParams));
		}
		
		public function hide (delay:Number = 0, onComplete:Function = null, ...onCompleteParams):void
		{
			_transition.call.apply (null, [_hideTransition, delay, onComplete].concat(onCompleteParams));
		}
		
		protected function _showTransition():void
		{
			_transition.notifyComplete();
		}
		
		protected function _hideTransition():void
		{
			_transition.notifyComplete();
		}
		
		public function addView (view:View):void
		{
			_childView = view;
			_childView._parentView = this;
			var container:DisplayObjectContainer = _getChildContainer (_childView);
			container.addChild (_childView);
		}
		
		public function removeView (view:View):void
		{
			var container:DisplayObjectContainer = _getChildContainer (_childView);			
			if (container.contains(_childView)) 
				container.removeChild (_childView);
			
			_childView._parentView = null;
			_childView = null;
		}
		
		protected function _added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, _added);
			stage.addEventListener (Event.RESIZE, _onResize);
			
			_init ();
			_resize();
		}
		
		private function _getChildContainer (view:View):DisplayObjectContainer
		{
			return rootView && view._isModal && view._modalBlockAll ? rootView._childContainer : _childContainer;
		}
		
		private function _removed(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, _removed);
			stage.removeEventListener (Event.RESIZE, _onResize);
		}
		
		private function _onResize(e:Event):void 
		{
			_resize();
		}
		
		protected function _init ():void { }
		public function _update ():void { }
		protected function _resize ():void { }
		public function dispose ():void{}
		
		public function get rootView():View 
		{
			if (_rootView) return _rootView;
			
			var view:View = this;
			while (view._parentView)
			{
				view = view._parentView;
			}
			
			_rootView = view;
			
			return _rootView;
		}
	}

}