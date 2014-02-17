package delorean.navigation 
{
	import delorean.dependencies.DependenciesEvent;
	import delorean.dependencies.IDependencies;
	import delorean.utils.getClass;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.setTimeout;
	
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
		
		public function ViewData(id:String, viewClassStr:String, dependencies:IDependencies = null, isModal:Boolean = false) 
		{
			super();
			this.id = id;
			this.viewClassStr = viewClassStr;
			this.dependencies = dependencies;
			this._isModal = isModal;
		}
		
		public function loadView (parentView:View):void
		{
			_parentView = parentView;
			_parentView.dispatchEvent (new ViewEvent(ViewEvent.CHILD_LOAD_START, id));
			if (dependencies)
			{
				//dependencies.load ();
				setTimeout(dependencies.load, 500)
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
			//log (this, "_onViewProgress: " + _parentView.id);
			var progressEvent:ViewEvent = new ViewEvent (ViewEvent.CHILD_LOAD_PROGRESS, id);
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
			
			_parentView.addView (view);
			_parentView.dispatchEvent (new ViewEvent(ViewEvent.CHILD_LOAD_COMPLETE, id));
		}
		
		private function _onViewShowed(...e):void 
		{
			dispatchEvent (new Event (Event.INIT));
		}
		
		private function _onViewHided(...e):void 
		{
			//log (this, "_onViewHided: " + id)
			if (dependencies)
			{
				dependencies.dispose ();
			}
			if (view)
			{
				view.dispose ();
				_parentView.dispatchEvent (new ViewEvent(ViewEvent.CHILD_DISPOSED, id));
				_parentView.removeView (view);
				view = null;
				_parentView = null;
			}
			
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
		
		public function set isModal(value:Boolean):void 
		{
			_isModal = value;
		}
		
	}

}