package delorean.builders 
{
	import delorean.dependencies.BobDependencies;
	import delorean.navigation.config.XMLConfig;
	import delorean.navigation.View;
	import delorean.navigation.DeloreanNavigator;
	import delorean.parameters.Parameters;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class DefaultDeloreanBuilder extends EventDispatcher
	{
		private var _config:XMLConfig;
		private var _xmlLoader:URLLoader;
		private var _rootView:View;
		
		public function DefaultDeloreanBuilder (rootView:View, urlConfig:String):void
		{
			_xmlLoader = new URLLoader ();
			_xmlLoader.load (new URLRequest (urlConfig));
			_xmlLoader.addEventListener (Event.COMPLETE, _onXMLComplete);
			
			_rootView = rootView;
			
		}
		
		private function _onXMLComplete(e:Event):void 
		{
			var dataXML:XML = XML (_xmlLoader.data);
			
			Parameters.fromXML (dataXML.parameters);
			
			_config = new XMLConfig ();
			_config.parse (dataXML.navigation, BobDependencies, _rootView);
			
			DeloreanNavigator.instance.init(_config.viewsNode);
			
			dispatchEvent (new Event (Event.COMPLETE));
		}
		
	}

}