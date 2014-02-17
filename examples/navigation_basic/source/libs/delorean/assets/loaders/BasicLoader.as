package delorean.assets.loaders {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import delorean.assets.events.LoadEvent;
	
	
	/**
	 *  Dispatched on download progress.
	 *
	 *  @eventType vince.assets.events.LoadEvent.PROGRESS
	 */
	[Event(name = "LoadEvent_Progress", type = "vince.assets.events.LoadEvent")]
	
	/**
	 *  Dispatched when item have been downloaded.
	 *
	 *  @eventType vince.assets.events.LoadEvent.FINISH
	 */
	[Event(name = "LoadEvent_Finish", type = "vince.assets.events.LoadEvent")]
	
	/**
	 *  Dispatched when file cannot be found.
	 *
	 *  @eventType vince.assets.events.LoadEvent.ERROR
	 */
	[Event(name = "LoadEvent_Error", type = "vince.assets.events.LoadEvent")]
	
	
	/**
	 * BasicLoader is not intended to be used, it's just a class to be extended by DataLoader and FileLoader.
	 * It actually dont load anything, but help setting vars for the class that extends it.
	 */
	public class BasicLoader extends EventDispatcher {
		
		private static var itensRequested:uint = 0;
		
		public var content:*;
		private var _name:*;
		private var _path:String;
		
		public var _bytesLoaded:Number;
		public var _bytesTotal:Number;
		
		private var _callbacks:Array;
		
		// checks if file is currently beeing loaded.
		public var isLoading:Boolean;
		
		// checks if file is already fully loaded.
		public var isLoaded:Boolean;
		
		// this var is used in AssetList and store the percent the loaded file represents in all the loadable itens.
		public var ratio:Number;
		
		
		/**
		 * Constructor.
		 * @param	name	<String> Unique name for the intance.
		 */
		public function BasicLoader(name:*) {
			
			name = (name != null) ? name : "BasicLoader_" + (++BasicLoader.itensRequested);
			
			this._name = name;
			this.isLoading = false;
			this.isLoaded = false;
			this._bytesLoaded = 0;
			this._bytesTotal = 0;
			
			this._callbacks = [];
			
		}
		
		
		/**
		 * Starts loading the file.
		 * @param	path	<String> Path of the file.
		 */
		public function load(path:String):BasicLoader {
			this._path = path;
			this.isLoading = true;
			
			return this;
		}
		
		
		/**
		 * Cancels the download.
		 */
		public function cancel():void {
			this.isLoading = false;
		}
		
		
		/**
		 * Adds a listener to run when item load finishes.
		 * The listener is automatically removed when download is complete.
		 * @param	callback	<Function>
		 * @return	<BasicLoader>	Returns the element to make an easy implementation of more than one callback.
		 */
		public function onComplete(callback:Function):BasicLoader {
			this.addEventListener(LoadEvent.FINISH, callback);
			
			this._callbacks.push( { t: LoadEvent.FINISH, f: callback } );
			
			return this;
		}
		
		
		/**
		 * Adds a listener to run when item load has some progress.
		 * The listener is automatically removed when download is complete.
		 * @param	callback	<Function>
		 * @return	<BasicLoader>	Returns the element to make an easy implementation of more than one callback.
		 */
		public function onProgress(callback:Function):BasicLoader {
			this.addEventListener(LoadEvent.PROGRESS, callback);
			
			this._callbacks.push( { t: LoadEvent.PROGRESS, f: callback } );
			
			return this;
		}
		
		
		
		/*--------------------------------------------------------------------------------------------
		 * 			PRIVATE / PROTECTED FUNCTIONS
		--------------------------------------------------------------------------------------------*/
		
		
		/**
		 * Dispatches progress events.
		 * @param	ev	<Event> The event dispatched by load progress.
		 */
		protected function progress(ev:ProgressEvent):void {
			var evt:LoadEvent;
			
			this._bytesLoaded = ev.bytesLoaded;
			this._bytesTotal = ev.bytesTotal;
			
			evt = new LoadEvent(LoadEvent.PROGRESS);
			evt.bytesLoaded = ev.bytesLoaded;
			evt.bytesTotal = ev.bytesTotal;
			evt.bytesPercent = ev.bytesLoaded / ev.bytesTotal;
			
			this.dispatchEvent(evt);
		}
		
		
		/**
		 * Dispatches load error events and also trace.
		 * @param	ev	<Event>
		 */
		protected function loadError(ev:IOErrorEvent):void {
			trace("[ERROR!!] Please check the path of file -> " + this.path);
			this.dispatchEvent(new LoadEvent(LoadEvent.ERROR));
		}
		
		
		/**
		 * Dispatches load complete events.
		 */
		protected function complete(ev:Event):void {
			var i:uint;
			var o:Object;
			
			this.isLoading = false;
			this.isLoaded = true;
			
			this.dispatchEvent(new LoadEvent(LoadEvent.FINISH));
			
			for (i = 0; i < this._callbacks.length; i++) {
				o = this._callbacks[i];
				this.removeEventListener(o.t, o.f);
			}
			
			this._callbacks = null;
		}
		
		
		/*--------------------------------------------------------------------------------------------
		 * 			GETTERS / SETTERS
		--------------------------------------------------------------------------------------------*/
		
		
		/**
		 * Number of bytes already loaded.
		 */
		public function get bytesLoaded():Number {
			return this._bytesLoaded;
		}
		
		
		/**
		 * Number of total bytes.
		 */
		public function get bytesTotal():Number {
			return this._bytesTotal;
		}
		
		
		/**
		 * Percent of loaded (0 - 1).
		 */
		public function get bytesPercent():Number {
			
			if (this.bytesLoaded == 0 || this.bytesTotal == 0) {
				return 0;
			} else {
				return this.bytesLoaded / this.bytesTotal;
			}
			
		}
		
		/**
		 * Name of loader.
		 */
		public function get name():* {
			return this._name;
		}
		
		
		/**
		 * Path of loader.
		 */
		public function get path():* {
			return this._path;
		}
		
	}
	
}