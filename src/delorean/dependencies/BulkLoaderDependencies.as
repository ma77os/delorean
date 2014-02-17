package delorean.dependencies
{
	import flash.events.EventDispatcher;
	import delorean.dependencies.IDependencies;
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import delorean.dependencies.DependenciesEvent;

	public class BulkLoaderDependencies extends EventDispatcher implements IDependencies
	{
		public var _bulkLoader:BulkLoader;
		public function BulkLoaderDependencies()
		{
			super();
			
			_bulkLoader = new BulkLoader ();
			_bulkLoader.addEventListener(BulkProgressEvent.PROGRESS,_onBulkProgress,false, 0, true);
			_bulkLoader.addEventListener(BulkProgressEvent.COMPLETE,_onBulkComplete,false, 0, true);
		}
		
		public function add (id:String, url:String, type:String = "", fonts:String = "", totalBytes:Number = 0):void
		{
			var props:Object = {id:id, type:type};
			if (totalBytes > 0) props.weight = totalBytes;
			_bulkLoader.add (url, props);
		}
		
		public function load ():void
		{
			_bulkLoader.start();
		}
		
		public function getContent(id:String):*
		{
			return _bulkLoader.getContent (id);
		}
		
		public function dispose ():void
		{
			_bulkLoader.removeEventListener(BulkProgressEvent.PROGRESS,_onBulkProgress);
			_bulkLoader.removeEventListener(BulkProgressEvent.COMPLETE,_onBulkComplete);
			
			_bulkLoader.clear();
			_bulkLoader = null;
		}
		
		private function _onBulkProgress(e:BulkProgressEvent):void 
		{
			//log (this, "_onBulkProgress: " + e.weightPercent);
			var progressEvent:DependenciesEvent = new DependenciesEvent (DependenciesEvent.LOAD_PROGRESS)
			progressEvent.pct = e.weightPercent;
			dispatchEvent (progressEvent);
		}
		
		private function _onBulkComplete(e:BulkProgressEvent):void 
		{
			dispatchEvent (new DependenciesEvent (DependenciesEvent.LOAD_COMPLETE));
		}
	
	}

}