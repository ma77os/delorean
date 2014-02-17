package delorean.assets.loaders {
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import delorean.assets.events.LoadEvent;
	
	
	/**
	 * ...
	 */
	public class FileLoader extends BasicLoader {
		
		protected var loader:Loader;
		
		
		/**
		 * Constructor, creates a new FileLoader instance.
		 */
		public function FileLoader(name:* = null) {
			super(name);
		}
		
		
		
		/*--------------------------------------------------------------------------------------------
		 * 			PUBLIC FUNCTIONS
		--------------------------------------------------------------------------------------------*/
		
		
		/**
		 * Starts loading file
		 * @param	path	<String> Path of the file.
		 */
		override public function load(path:String):BasicLoader {
			var ldc:LoaderContext;
			
			//ldc = new LoaderContext(true);
			ldc = new LoaderContext(true, ApplicationDomain.currentDomain);
			
			this.loader = new Loader();
			this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.complete);
			this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, this.progress);
			this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.loadError);
			
			this.loader.load(new URLRequest(path), ldc);
			
			return super.load(path);
		}
		
		
		/**
		 * Cancel download and remove its listeners (will check if file is currently beeing loaded).
		 */
		override public function cancel():void {
			super.cancel();
			
			if (this.isLoading) {
				
				this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.complete);
				this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.progress);
				this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.loadError);
				
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
			
			this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.complete);
			this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.progress);
			this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.loadError);
			
			this.content = ev.currentTarget.content;
			
			super.complete(ev);
		}
		
		
		
	}
	
}