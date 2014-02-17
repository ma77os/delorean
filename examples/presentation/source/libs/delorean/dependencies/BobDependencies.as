package delorean.dependencies 
{
	import delorean.assets.AssetList;
	import delorean.assets.events.LoadEvent;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public class BobDependencies extends EventDispatcher implements IDependencies
	{
		private var _assetList:AssetList;
		
		private var tempFiles : Array = [];
		
		public function BobDependencies() 
		{
			
		}
		
		public function add (id:String, url:String):void
		{
			this.tempFiles.push({url: url, id: id});
		}
		
		public function load ():void
		{
			//log (this, "load");
			_assetList = new AssetList ();
			
			for (var i:int = 0; i < tempFiles.length; i++) 
			{
				_assetList.addFile (tempFiles[i].url, tempFiles[i].id);
			}
			
			
			_assetList.onComplete (_onAssetListComplete);
			_assetList.onProgress (_onAssetListProgress);
			_assetList.start ();
		}
		
		public function getContent(id:String):*
		{
			return _assetList.getContent(id);
		}
		
		public function dispose ():void
		{
			_assetList = null;
			//_assetList.cancelAll ();
		}
		
		private function _onAssetListProgress(e:LoadEvent):void 
		{
			//log (this, "progress: " + e.bytesPercent);
			var progressEvent:DependenciesEvent = new DependenciesEvent (DependenciesEvent.LOAD_PROGRESS)
			progressEvent.pct = e.bytesPercent;
			dispatchEvent (progressEvent);
		}
		
		private function _onAssetListComplete(e:LoadEvent):void 
		{
			//log (this, "complete");
			dispatchEvent (new DependenciesEvent (DependenciesEvent.LOAD_COMPLETE));
		}
		
	}

}