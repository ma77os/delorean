package delorean.navigation.config 
{
	import delorean.collections.TreeNode;
	import delorean.dependencies.IDependencies;
	import delorean.navigation.View;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class AConfig 
	{
		protected var _viewsNode:TreeNode;
		protected var _data:*;
		protected var _dependenciesClass:Class;
		
		public function AConfig() 
		{
		}
		
		public function parse(data:*, dependenciesClass:Class, rootView:View):void 
		{
			_data = data;
			_dependenciesClass = dependenciesClass;
			_viewsNode = new TreeNode ("root", rootView);
		}
		
		public function get viewsNode():TreeNode 
		{
			return _viewsNode;
		}
		
	}

}