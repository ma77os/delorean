package delorean.assets.loaders {
	
	import flash.text.Font;
	import delorean.assets.events.LoadEvent;
	
	/**
	 * FontLoader is kind of a FlashLibrary for fonts.
	 */
	public class FontLoader extends FlashLibrary {
		
		private var fontList:Array;
		
		
		/**
		 * Constructor, creates a new FontLoader instance.
		 * @param	fontList	<Array> Array with the names of the fonts on the library.
		 */
		public function FontLoader(fontList:Array, name:String = null) {
			super(false, name);
			this.fontList = fontList;
			this.addEventListener(LoadEvent.FINISH, this.registerFonts);
		}
		
		
		/**
		 * Will register all the fonts of the fontlist informed in the constructor.
		 * @param	ev	<Event> (no use).
		 */
		private function registerFonts(ev:LoadEvent = null):void {
			var i:uint;
			var FontClass:Class;
			
			this.removeEventListener(LoadEvent.FINISH, this.registerFonts);
			
			for (i = 0; i < this.fontList.length; i++) {
				FontClass = this.takeClass(this.fontList[i]);
				
				try {
					Font.registerFont(FontClass);
				} catch (e:Error) {
					trace("Font could not be registred: " + this.fontList[i]);
				}
				
			}
		}
		
		
		public function traceRegistredFonts():void {
			var i:uint;
			var f:Font;
			
			trace("-----------------------------------------");
			trace("AVAILABLE FONTS:");
			trace("-----------------------------------------");
			
			for (i = 0; i < Font.enumerateFonts().length; i++) {
				f = Font.enumerateFonts()[i] as Font;
				trace(f.fontName + " / " + f.fontStyle);
			}
			
			trace("-----------------------------------------");
		}
		
		
	}
	
}