package delorean.builders 
{
	import delorean.navigation.config.XMLConfig;
	import delorean.navigation.deeplink.SWFAddressDeepLink;
	import delorean.navigation.View;
	import delorean.navigation.DeloreanNavigator;
	import delorean.parameters.Parameters;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import delorean.dependencies.BulkLoaderDependencies;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class DefaultDeloreanBuilder extends EventDispatcher
	{
		private var _config:XMLConfig;
		private var _xmlLoader:URLLoader;
		private var _rootView:View;
		private var _defaultViewId:*;
		private var _useDeepLink:Boolean;
		
		public function DefaultDeloreanBuilder (rootView:View, urlConfig:String, defaultViewId:* = "main", useDeepLink:Boolean = false):void
		{
			_xmlLoader = new URLLoader ();
			_xmlLoader.load (new URLRequest (urlConfig));
			_xmlLoader.addEventListener (Event.COMPLETE, _onXMLComplete);
			
			_rootView = rootView;
			_defaultViewId = defaultViewId;
			_useDeepLink = useDeepLink;
		}
		
		private function _onXMLComplete(e:Event):void 
		{
			var dataXML:XML = XML (_xmlLoader.data);
			
			Parameters.fromXML (dataXML.parameters);
			
			_config = new XMLConfig ();
			_config.parse (dataXML.navigation, BulkLoaderDependencies, _rootView);
			
			DeloreanNavigator.instance.init(_config.viewsNode, _defaultViewId, _useDeepLink ? new SWFAddressDeepLink () : null);
			
			dispatchEvent (new Event (Event.COMPLETE));
		}
		
	}

}