package delorean.navigation 
{
	import delorean.collections.TreeNode;
	import delorean.navigation.deeplink.DeepLinkEvent;
	import delorean.navigation.deeplink.IDeepLink;
	import delorean.parameters.getParam;
	import delorean.parameters.setParam;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class DeloreanNavigator extends EventDispatcher
	{
		public static const VERBOSE:Boolean = false;
		private static var _instance:DeloreanNavigator;
		private var _rootNode:TreeNode;
		private var _rootView:View;
		private var _destinationNode:TreeNode;
		private var _currentNode:TreeNode;
		private var _currentViewData:ViewData;
		private var _deepLink:IDeepLink;
		private var _defaultViewId:*;
		private var _history:Array;
		private var _modalOpened:Boolean;
		
		public function DeloreanNavigator(singleton:Singleton) {}
		
		public static function go (id:*, dataParam:* = null):void
		{
			if (_instance._deepLink)
				_instance._deepLink.go (id, dataParam);
			else
				_instance._go (id, dataParam);
		}
		
		public static function back ():void
		{
			_instance._back();
		}
		
		public static function up (fromId:*=null):void
		{
			_instance._up(fromId);
		}
		
		public static function closeModal (fromId:*=null):void
		{
			_instance._modalOpened = false;
			_instance._up(fromId);
		}
		
		public function hasView (id:*):Boolean
		{
			return Boolean (_rootNode.fetch(id));
		}
		
		private function _go (id:*, dataParam:* = null):void
		{
			//if (_destinationNode) return;
			_log ("go \""+id+"\"");
			
			var node:TreeNode = _rootNode.fetch (id);
			if (!node)
			{
				_log ("the view \""+id+"\" doesn't exist");
				return;
			}
			
			dispatchEvent (new ViewEvent (ViewEvent.DELOREAN_GO, id));
			setParam (id + "DeloreanNavigatorParam", dataParam);
			_destinationNode = node;
			_history.push (_destinationNode.key);
			
			_manageViews ();			
		}
		
		private function _back():void
		{
			if (_history.length == 1) return;
			_history.pop();
			DeloreanNavigator.go (_history[_history.length-1]);
		}
		
		private function _up (fromId:* = null):void
		{
			var fromNode:TreeNode = _currentNode;
			
			if (fromId)
			{
				var node:TreeNode = _rootNode.fetch (fromId);
				if (node) fromNode = node;
			}
			
			DeloreanNavigator.go (fromNode.parent.key);
		}
		
		private function _forward ():void
		{
			//TODO: implement!
		}
		
		private function _manageViews():void 
		{
			if (_destinationNode == _currentNode) 
			{
				_viewsReady();
				return;
			}
			
			// TODO: validate first when a view requested is a child from a modal, need to inject the whole modal branch
			// inject modal branch inside currentNode, to make sure modal always be above currentView
			if (ViewData(_destinationNode.data).isModal && !_modalOpened)
			{
				_modalOpened = true;
				_injectNode (_destinationNode, _currentNode);
			}
			
			if (_currentNode && !_currentNode.fetch (_destinationNode.key))
				_destroyView (_currentNode);
			else
				_createView (_destinationNode);
			
		}
		
		private function _injectNode(viewNode:TreeNode, parentNode:TreeNode):void 
		{
			// first, clear the node from tree
			if (_rootNode.fetch (viewNode.key))
				_rootNode.remove (viewNode.key);
				
			// inject modal node inside currentNode
			parentNode.addChild (viewNode);
		}
		
		private function _createView (viewNode:TreeNode):void
		{
			_log ("trying to createView: " + viewNode.key);
			
			var parentNode:TreeNode = viewNode.parent || _rootNode;
			_currentNode = viewNode;
			
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
		
		public function init (treeViews:TreeNode, defaultViewId:* = null, deepLink:IDeepLink = null):void
		{
			_log ("init");
			_rootNode = treeViews;
			_rootView = _rootNode.data as View;
			
			_defaultViewId = defaultViewId;
			
			_history = [];
			_history.push (_rootNode.key);
			
			if (deepLink) _initDeepLink(deepLink);
			else if (_defaultViewId) DeloreanNavigator.go (_defaultViewId);
			
			//_log ("_rootView: " + _rootView);
		}
		
		private function _initDeepLink(deepLink:IDeepLink):void 
		{
			_log ("_initDeepLink: " + deepLink);
			_deepLink = deepLink;
			_deepLink.addEventListener (DeepLinkEvent.CHANGE, _onDeepLinkChange);
		}
		
		private function _onDeepLinkChange(e:DeepLinkEvent):void 
		{
			_log (this, "_onDeepLinkChange: " + e.id);
			if (!e.id) 
			{
				DeloreanNavigator.go (_defaultViewId);
				return 
			}
			_go (e.id, e.dataParam);
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
		
		public function getCurrentView():View
		{
			return _getViewByNode(currentNode);
		}
		
	}

}

class Singleton {}