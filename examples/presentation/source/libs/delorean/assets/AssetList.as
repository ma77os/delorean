package delorean.assets {
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import delorean.assets.events.LoadEvent;
	import delorean.assets.loaders.BasicLoader;
	import delorean.assets.loaders.CssLoader;
	import delorean.assets.loaders.DataLoader;
	import delorean.assets.loaders.FileLoader;
	import delorean.assets.loaders.FlashLibrary;
	import delorean.assets.loaders.FontLoader;
	import delorean.assets.loaders.XmlLoader;
	
	/**
	 * ...
	 * @author Vincent Maraschin - www.vince.as
	 */
	
	/**
	 *  Dispatched on download progress.
	 *
	 *  @eventType vince.assets.events.LoadEvent.PROGRESS
	 */
	[Event(name = "LoadEvent_Progress", type = "vince.assets.events.LoadEvent")]
	
	/**
	 *  Dispatched when all itens have been downloaded.
	 *
	 *  @eventType vince.assets.events.LoadEvent.FINISH
	 */
	[Event(name = "LoadEvent_Finish", type = "vince.assets.events.LoadEvent")]
	
	/**
	 *  Dispatched when one of the itens have been downloaded.
	 *
	 *  @eventType vince.assets.events.LoadEvent.ITEM_COMPLETE
	 */
	[Event(name = "LoadEvent_ItemComplete", type = "vince.assets.events.LoadEvent")]
	
	/**
	 *  Dispatched when file cannot be found.
	 *
	 *  @eventType vince.assets.events.LoadEvent.ERROR
	 */
	[Event(name = "LoadEvent_Error", type = "vince.assets.events.LoadEvent")]
	
	/**
	 * AssetList allows you to load a sequence of assets and control the progress of them.
	 */
	public class AssetList extends EventDispatcher {
		
		private var _callbacks:Array;
		
		private var itens:Array;
		private var sum:Number;
		private var currentSum:Number;
		private var currentItem:uint;
		
		private var canceled:Boolean;
		private var _itemsDict:Dictionary;
		
		
		/**
		 * Constructor, creates a new AssetList instance.
		 */
		public function AssetList() {
			super();
			this.itens = [];
			this.sum = 0;
			this.currentSum = 0;
			this.currentItem = 0;
			this.canceled = false;
			
			this._callbacks = [];
		}
		
		
		/**
		 * Adds a CssLoader and returns it.
		 * @param	path	<String>	Path of the file to be loaded.
		 * @param	name	<String, default null> Optional name of the instance.
		 * @param	global	<Boolean, default false> If true will allow access of the instance globally.
		 * @param	estimatedRatio	<Number, default 1> Specifies the estimated percent of the file in the list. Must be bigger than 0.
		 * @return	<CssLoader>	The CssLoader object.
		 */
		public function addCss(path:String, name:String = null, global:Boolean = false, estimatedRatio:Number = 1):CssLoader {
			var css:CssLoader;
			
			css = new CssLoader(global, name);
			this.addLoadable(path, css, estimatedRatio);
			
			return css;
		}
		
		
		/**
		 * Adds a DataLoader and returns it.
		 * @param	path	<String>	Path of the file to be loaded.
		 * @param	name	<String, default null> Optional name of the instance.
		 * @param	estimatedRatio	<Number, default 1> Specifies the estimated percent of the file in the list. Must be bigger than 0.
		 * @return	<DataLoader>	The DataLoader object.
		 */
		public function addDatafile(path:String, name:String = null, estimatedRatio:Number = 1):DataLoader {
			var dl:DataLoader;
			
			dl = new DataLoader(name);
			this.addLoadable(path, dl, estimatedRatio);
			
			return dl;
		}
		
		
		/**
		 * Adds a FileLoader and returns it.
		 * @param	path	<String>	Path of the file to be loaded.
		 * @param	name	<String, default null> Optional name of the instance.
		 * @param	estimatedRatio	<Number, default 1> Specifies the estimated percent of the file in the list. Must be bigger than 0.
		 * @return	<FileLoader>	The FileLoader object.
		 */
		public function addFile(path:String, name:String = null, estimatedRatio:Number = 1):FileLoader {
			var fl:FileLoader;
			
			fl = new FileLoader(name);
			this.addLoadable(path, fl, estimatedRatio);
			
			return fl;
		}
		
		
		/**
		 * Adds a FlashLibrary and returns it.
		 * @param	path	<String>	Path of the file to be loaded.
		 * @param	name	<String, default null> Optional name of the instance.
		 * @param	global	<Boolean, default false> If true will allow access of the instance globally.
		 * @param	estimatedRatio	<Number, default 1> Specifies the estimated percent of the file in the list. Must be bigger than 0.
		 * @return	<FlashLibrary>	The FlashLibrary object.
		 */
		public function addLibrary(path:String, name:String = null, global:Boolean = false, estimatedRatio:Number = 1):FlashLibrary {
			var fl:FlashLibrary;
			
			fl = new FlashLibrary(global, name);
			this.addLoadable(path, fl, estimatedRatio);
			
			return fl;
		}
		
		
		/**
		 * Adds a FontLoader and returns it.
		 * @param	path	<String>	Path of the file to be loaded.
		 * @param	fontNameList	<Array>	Array with the names of the fonts on the library.
		 * @param	name	<String, default null> Optional name of the instance.
		 * @param	estimatedRatio	<Number, default 1> Specifies the estimated percent of the file in the list. Must be bigger than 0.
		 * @return	<FontLoader>	The FontLoader object.
		 */
		public function addFont(path:String, fontNamesList:Array, name:String = null, estimatedRatio:Number = 1):FontLoader {
			var fl:FontLoader;
			
			fl = new FontLoader(fontNamesList, name);
			this.addLoadable(path, fl, estimatedRatio);
			
			return fl;
		}
		
		
		/**
		 * Adds a XmlLoader and returns it.
		 * @param	path	<String>	Path of the file to be loaded.
		 * @param	name	<String, default null> Optional name of the instance.
		 * @param	estimatedRatio	<Number, default 1> Specifies the estimated percent of the file in the list. Must be bigger than 0.
		 * @return	<XmlLoader>	The XmlLoader object.
		 */
		public function addXml(path:String, name:* = null, estimatedRatio:Number = 1):XmlLoader {
			var xml:XmlLoader;
			
			xml = new XmlLoader(name);
			this.addLoadable(path, xml, estimatedRatio);
			
			return xml;
		}
		
		
		/**
		 * Start to load everything sequencially.
		 */
		public function start():AssetList {
			
			if (this.itens.length) {
				this.loadCurrent();
			} else {
				throw new Error("Nothing to load");
			}
			
			return this;
			
		}
		
		
		/**
		 * Cancel all downloads.
		 */
		public function cancelAll():void {
			var i:uint;
			var item:BasicLoader;
			
			this.canceled = true;
			
			for (i = 0; i < this.currentItem; i++) {
				item = this.itens[i].item;
				item.cancel();
				
				item.removeEventListener(LoadEvent.PROGRESS, this.onItemProgress);
				item.removeEventListener(LoadEvent.FINISH, this.onItemComplete);
			}
			
			this.killListeners();
		}
		
		
		/**
		 * Easier implementation of LoadEvent.FINISH. The listener is automatically removed when download is complete.
		 * @param	callback	<Function> Trigger function.
		 * @return	<AssetList> The object itself, for easier implementation of more listeners.
		 */
		public function onComplete(callback:Function):AssetList {
			this.addEventListener(LoadEvent.FINISH, callback);
			
			this._callbacks.push( { t: LoadEvent.FINISH, f: callback } );
			
			return this;
		}
		
		
		/**
		 * Easier implementation of LoadEvent.PROGRESS. The listener is automatically removed when download is complete.
		 * @param	callback	<Function> Trigger function.
		 * @return	<AssetList> The object itself, for easier implementation of more listeners.
		 */
		public function onProgress(callback:Function):AssetList {
			this.addEventListener(LoadEvent.PROGRESS, callback);
			
			this._callbacks.push( { t: LoadEvent.PROGRESS, f: callback } );
			
			return this;
		}
		
		
		public function addLoadable(path:String, item:BasicLoader, ratio:Number):void {
			
			if (ratio <= 0) {
				throw new Error("Estimated ratios must be bigger than 0");
				return;
			}
			
			this.sum += ratio;
			item.ratio = ratio;
			
			item.addEventListener(LoadEvent.PROGRESS, this.onItemProgress);
			item.addEventListener(LoadEvent.FINISH, this.onItemComplete);
			
			this.itens.push(
				{ item: item, path: path }
			);
			
			if (!_itemsDict) _itemsDict = new Dictionary (true);
			_itemsDict[item.name] = item;
		}
		
		public function getContent (name:String):*
		{
			var item:BasicLoader = _itemsDict[name];
			if (item == null) return null;
			return item.content;
		}
		
		
		private function loadCurrent():void {
			var item:BasicLoader;
			var path:String;
			
			item = this.itens[this.currentItem].item;
			path = this.itens[this.currentItem].path;
			
			this.currentItem ++;
			item.load(path);
		}
		
		
		private function onItemProgress(ev:LoadEvent):void {
			var itemPercent:Number;
			var listPercent:Number;
			var item:BasicLoader;
			var evt:LoadEvent;
			
			item = ev.currentTarget as BasicLoader;
			
			itemPercent = ev.bytesPercent;
			listPercent = (this.currentSum + itemPercent * item.ratio) / this.sum;
			
			evt = new LoadEvent(LoadEvent.PROGRESS);
			evt.bytesPercent = listPercent;
			evt.currentLoader = item;
			
			this.dispatchEvent(evt);
			
		}
		
		
		private function onItemComplete(ev:LoadEvent):void {
			var item:BasicLoader;
			var evtItem:LoadEvent;
			var evtPrg:LoadEvent;
			var listPercent:Number;
			
			if (this.canceled) return;
			
			item = ev.currentTarget as BasicLoader;
			this.currentSum += item.ratio;
			
			evtItem = new LoadEvent(LoadEvent.ITEM_COMPLETE);
			evtItem.currentLoader = item;
			this.dispatchEvent(evtItem);
			
			if (this.currentItem < this.itens.length) {
				this.loadCurrent();
				listPercent = this.currentSum / this.sum;
				
				evtPrg = new LoadEvent(LoadEvent.PROGRESS);
				evtPrg.bytesPercent = listPercent;
				
				this.dispatchEvent(evtPrg);
				
			} else {
				setTimeout(this.complete, 10);
			}
		}
		
		
		private function complete():void {
			var evtList:LoadEvent;
			
			evtList = new LoadEvent(LoadEvent.FINISH);
			this.dispatchEvent(evtList);
			
			this.killListeners();
		}
		
		
		private function killListeners():void {
			var i:uint;
			var o:Object;
			
			for (i = 0; i < this._callbacks.length; i++) {
				o = this._callbacks[i];
				this.removeEventListener(o.t, o.f);
			}
			
			this._callbacks = null;
		}
		
	}
	
}