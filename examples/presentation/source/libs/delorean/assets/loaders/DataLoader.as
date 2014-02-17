package delorean.assets.loaders {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import delorean.assets.events.LoadEvent;
	
	
	
	
	
	public class DataLoader extends BasicLoader {
		
		internal var loader:URLLoader;
		
		public var data:*;
		
		
		/**
		 * Constructor, creates a new DataLoader instance.
		 */
		public function DataLoader(name:* = null) {
			super(name);
		}
		
		
		/*--------------------------------------------------------------------------------------------
		 * 			PUBLIC FUNCTIONS
		--------------------------------------------------------------------------------------------*/
		
		
		/**
		 * Starts loading file.
		 * @param	path	<String> Path of file.
		 */
		override public function load(path:String):BasicLoader {
			
			this.loader = new URLLoader();
			this.loader.addEventListener(Event.COMPLETE, this.complete);
			this.loader.addEventListener(ProgressEvent.PROGRESS, this.progress);
			this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.loadError);
			
			this.loader.load(new URLRequest(path));
			
			return super.load(path);
		}
		
		
		/**
		 * Cancel download and remove its listeners (will check if file is currently beeing loaded).
		 */
		override public function cancel():void {
			super.cancel();
			
			if (this.isLoading) {
				
				this.loader.removeEventListener(Event.COMPLETE, this.complete);
				this.loader.removeEventListener(ProgressEvent.PROGRESS, this.progress);
				this.loader.removeEventListener(IOErrorEvent.IO_ERROR, this.loadError);
				
				try {
					this.loader.close();
				} catch (e:Error) { }
			}
		}
		
		
		
		/*--------------------------------------------------------------------------------------------
		 * 			PRIVATE FUNCTIONS
		--------------------------------------------------------------------------------------------*/
		
		/**
		 * Runs at download complete.
		 * @param	ev	<Event> Event dispatched by loader.
		 */
		override protected function complete(ev:Event):void {
			
			this.loader.removeEventListener(Event.COMPLETE, this.complete);
			this.loader.removeEventListener(ProgressEvent.PROGRESS, this.progress);
			this.loader.removeEventListener(IOErrorEvent.IO_ERROR, this.loadError);
			
			this.data = ev.currentTarget.data;
			
			super.complete(ev);
		}
		
	}
	
}