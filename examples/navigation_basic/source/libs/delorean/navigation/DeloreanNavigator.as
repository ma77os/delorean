package delorean.navigation 
{
	import delorean.collections.TreeNode;
	import delorean.parameters.getParam;
	import delorean.parameters.setParam;
	import flash.events.Event;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class DeloreanNavigator 
	{
		public static const VERBOSE:Boolean = false;
		private static var _instance:DeloreanNavigator;
		private var _rootNode:TreeNode;
		private var _rootView:View;
		private var _destinationNode:TreeNode;
		private var _currentNode:TreeNode;
		private var _currentViewData:ViewData;
		
		public function DeloreanNavigator(singleton:Singleton) {}
		
		public static function go (id:*, dataParam:* = null):void
		{
			_instance._go (id, dataParam);
		}
		
		public function hasView (id:*):Boolean
		{
			return Boolean (_rootNode.fetch(id));
		}
		
		private function _go (id:*, dataParam:* = null):void
		{
			if (_destinationNode) return;
			
			var node:TreeNode = _rootNode.fetch (id);
			if (!node)
			{
				_log ("the view \""+id+"\"doesn't exists");
				return;
			}
			
			setParam (id + "DeloreanNavigatorParam", dataParam);
			_destinationNode = node;
			
			_manageViews ();			
		}
		
		private function _manageViews():void 
		{
			if (_destinationNode == _currentNode) 
			{
				_viewsReady();
				return;
			}
			
			if (_currentNode && !_currentNode.fetch (_destinationNode.key))
				_destroyView (_currentNode);
			else
				_createView (_destinationNode);
			
		}
		
		private function _createView (viewNode:TreeNode):void
		{
			_log ("trying to createView: " + viewNode.key);
			_currentNode = viewNode;
			var parentNode:TreeNode = _currentNode.parent || _rootNode;
			
			var parentView:View = _getViewByNode (parentNode);
			if (!parentView)
			{
				_log ("cannot create "+viewNode.key+" needs to create parent");
				_createView (parentNode);
				return;
			}
			
			_log ("ok, create view: " + viewNode);
			_currentViewData = _currentNode.data as ViewData;
			_currentViewData.dataParam = getParam (viewNode.key + "DeloreanNavigatorParam");
			setParam (viewNode.key + "DeloreanNavigatorParam", "");
			_currentViewData.addEventListener (Event.INIT, _onViewInit);
			_currentViewData.loadView (parentView);
		}
		
		private function _destroyView (viewNode:TreeNode):void
		{
			_log ("destroying view: " + viewNode);
			_currentViewData = _currentNode.data as ViewData;
			_currentViewData.addEventListener (Event.UNLOAD, _onViewUnload);
			_currentViewData.unloadView();
		}
		
		private function _onViewInit(e:Event):void 
		{
			//_log ("onviewInit:");
			_currentViewData.removeEventListener (Event.INIT, _onViewInit);
			_currentViewData = null;
			_manageViews();
		}
		
		private function _onViewUnload(e:Event):void 
		{
			//_log ("_onViewUnload")
			
			// automatic remove from tree if the view is a IModalView
			if (_currentViewData.isModal) 
				_rootNode.remove (_currentNode.key);
				
			_currentViewData.removeEventListener (Event.UNLOAD, _onViewUnload);
			_currentViewData = null;
			
			if (_currentNode.parent) 
				_currentNode = _currentNode.parent;
			
			_manageViews();
		}
		
		private function _getViewByNode(node:TreeNode):View 
		{
			var view:View = null;
			if (node.data is ViewData)
			{
				var viewData:ViewData = node.data as ViewData;
				view = viewData.view;
			}
			// TODO: tratar o rootView da mesma maneira que os outros views, evitando esse if
			else if (node.data is View)
			{
				view = node.data as View;
			}
			
			return view;
		}
		
		private function _viewsReady():void 
		{
			_log ("_viewsReady");
			_destinationNode = null;
			_currentViewData = null;
		}
		
		private function _log(...rest):void 
		{
			if (VERBOSE) log.apply (null, [this].concat (rest));
		}
		
		public function init (treeViews:TreeNode):void
		{
			_log ("init");
			_rootNode = treeViews;
			_rootView = _rootNode.data as View;
			//_log ("_rootView: " + _rootView);
		}
		
		static public function get instance():DeloreanNavigator 
		{
			if (_instance == null) _instance = new DeloreanNavigator (new Singleton());
			return _instance;
		}
		
		public function get currentNode():TreeNode 
		{
			return _currentNode;
		}
		
	}

}

class Singleton {}