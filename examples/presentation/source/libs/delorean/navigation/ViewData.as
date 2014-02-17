package delorean.navigation 
{
	import delorean.dependencies.DependenciesEvent;
	import delorean.dependencies.IDependencies;
	import delorean.utils.getClass;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 * TODO: mudar eventos INIT e UNLOAD para ViewEvents customizados
	 */
	public class ViewData extends EventDispatcher 
	{
		public var id:*;
		public var dependencies:IDependencies;
		public var dataParam:*;
		public var showDelay:Number = 0;
		public var hideDelay:Number = 0;
		private var _parentView:View;
		public var view:View;
		public var viewClassStr:String;
		private var _isModal:Boolean;
		
		public function ViewData(viewClassStr:String, dependencies:IDependencies = null) 
		{
			super();
			this.viewClassStr = viewClassStr;
			this.dependencies = dependencies;
		}
		
		public function loadView (parentView:View):void
		{
			_parentView = parentView;
			_parentView.dispatchEvent (new ViewEvent(ViewEvent.CHILD_LOAD_START));
			if (dependencies)
			{
				dependencies.load ();
				dependencies.addEventListener (DependenciesEvent.LOAD_PROGRESS, _onViewProgress);
				dependencies.addEventListener (DependenciesEvent.LOAD_COMPLETE, _onViewLoaded);
			}
			else
			{
				_onViewLoaded();
			}
		}
		
		private function _onViewProgress(e:DependenciesEvent):void 
		{
			//log (this, "_onViewProgress: " + e.pct);
			var progressEvent:ViewEvent = new ViewEvent (ViewEvent.CHILD_LOAD_PROGRESS);
			progressEvent.pct = e.pct;
			_parentView.dispatchEvent (progressEvent);
		}
		
		public function unloadView ():void
		{
			view.hide (hideDelay, _onViewHided);
		}
		
		public function dispose ():void
		{
			if (dependencies) dependencies.dispose();
		}
		
		private function _onViewLoaded(e:DependenciesEvent = null):void 
		{
			if (dependencies)
			{
				dependencies.removeEventListener (DependenciesEvent.LOAD_PROGRESS, _onViewProgress);
				dependencies.removeEventListener (DependenciesEvent.LOAD_COMPLETE, _onViewLoaded);
			}
			var viewClass:Class = getClass (viewClassStr);
			view = new viewClass ();
			view.id = id;
			view.dataParam = dataParam;
			view.dependencies = dependencies;
			view.show (showDelay, _onViewShowed);
			_isModal = view is IModalView;
			
			_parentView.addView (view);
			_parentView.dispatchEvent (new ViewEvent(ViewEvent.CHILD_LOAD_COMPLETE));
		}
		
		private function _onViewShowed():void 
		{
			dispatchEvent (new Event (Event.INIT));
		}
		
		private function _onViewHided():void 
		{
			//log (this, "_onViewHided: " + id)
			if (dependencies)
			{
				dependencies.dispose ();
			}
			view.dispose ();
			_parentView.removeView (view);
			view = null;
			_parentView = null;
			
			dispatchEvent (new Event (Event.UNLOAD));
		}
		
		public function get viewLoaded ():Boolean
		{
			return Boolean (view);
		}
		
		public function get isModal():Boolean 
		{
			return _isModal;
		}
		
	}

}