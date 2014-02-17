package delorean.navigation.config 
{
	import delorean.collections.TreeNode;
	import delorean.dependencies.IDependencies;
	import delorean.navigation.View;
	import delorean.navigation.ViewData;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class XMLConfig extends AConfig
	{
		public function XMLConfig() 
		{
		}
		
		override public function parse(data:*, dependenciesClass:Class, rootView:View):void 
		{
			super.parse(data, dependenciesClass, rootView);
			
			//log (this, "view: " + (data.view is XMLList));
			
			_parseView (data.view, _viewsNode);
			
			//trace ("++++++++TREE:")
			//trace (_viewsNode.toTreeString());
		}
		
		private function _parseView (xmlNode:XMLList, parentNode:TreeNode):void
		{
			for each (var childNode:XML in xmlNode)
			{
				var dependencies:IDependencies = _getDependencies(childNode.dependency);
				var viewData:ViewData = new ViewData (childNode.attribute("class"), dependencies);
				var node:TreeNode = parentNode.add (childNode.@id, viewData);
				//log (this, "child views: " + childNode.view.length());
				if (childNode.view.length() > 0)
				{
					_parseView (childNode.view, node);
				}
			}
		}
		
		private function _getDependencies(xmlNode:XMLList):IDependencies 
		{
			if (xmlNode.length() == 0) return null;
			
			var dependencies:IDependencies = new _dependenciesClass ();
			
			for each (var childNode:XML in xmlNode)
			{
				dependencies.add (childNode.@id, childNode.toString());
			}
			
			return dependencies;
		}
		
	}

}