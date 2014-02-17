package delorean.assets.loaders {
	
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import delorean.assets.events.LoadEvent;
	import delorean.utils.StringUtil;
	
	/**
	 * CssLoader loads css files and parse them.
	 */
	public class CssLoader extends DataLoader {
		
		/// internal use.
		private static const libraries:Array = [];
		
		/// The StyleSheet object created with loaded css.
		public var sheet:StyleSheet;
		
		
		/**
		 * Constructor, creates a new CssLoader instance.
		 * @param	global	<Boolean> If true the library will be global and can be found be the static method "find".
		 * @param	name	<String> Name of the object to be found later.
		 */
		public function CssLoader(global:Boolean = false, name:String = null) {
			
			name = (name != null && name.length) ? name : "CssLoader_" + CssLoader.libraries.length;
			super(name);
			
			this.addEventListener(LoadEvent.FINISH, this.parseData);
			
			if (global) {
				CssLoader.libraries.push(this);
			}
			
		}
		
		
		/**
		 * Gets the style object with the styleName informed.
		 * @param	styleName	<String> The name of the style class.
		 * @return	<Object>	The object with all style properties.
		 */
		public function getStyle(styleName:String):Object {
			return this.sheet.getStyle(styleName);
		}
		
		
		/**
		 * Gets the style class informed converted in a TextFormat.
		 * @param	styleName	<String> The name of the style class.
		 * @return	<TextFormat> The TextFormat with all the properties from css.
		 */
		public function getFormat(styleName:String):TextFormat { 
			var format:TextFormat;
			var style:Object;
			var sColor:String;
			
			format = null;
			style = this.getStyle(styleName);
			
			try {
				
				if (style) {
					
					format = new TextFormat(
						style.fontFamily,
						style.fontSize,
						(style.color) ? StringUtil.toHex(style.color) : null,
						StringUtil.caseInsensitivyCompare(style.fontWeight, "bold"),
						StringUtil.caseInsensitivyCompare(style.fontStyle, "italic"),
						StringUtil.caseInsensitivyCompare(style.textDecoration, "underline"),
						style.url,
						style.target,
						style.textAlign,
						style.marginLeft,
						style.marginRight,
						style.indent,
						style.leading
					);
					
					if (style.hasOwnProperty("letterSpacing")) { 
						format.letterSpacing = style.letterSpacing; 
					}
				}
				
			} catch (e:Error) {
				return null;
			}
			
			return format;
		}
		
		
		/*--------------------------------------------------------------------------------------------
		 * 			PRIVATE
		--------------------------------------------------------------------------------------------*/
		
		/**
		 * Parses the css.
		 * @param	ev <LoadEvent> (no use).
		 */
		private function parseData(ev:LoadEvent = null):void {
			
			this.removeEventListener(LoadEvent.FINISH, this.parseData);
			
			this.sheet = new StyleSheet();
			this.sheet.parseCSS(this.data);
			
		}
		
		
		/*--------------------------------------------------------------------------------------------
		 * 			STATIC
		--------------------------------------------------------------------------------------------*/
		
		
		/**
		 * Finds a csslibrary by its name.
		 * @param	libraryName	<String> The name of the library.
		 * @return	
		 */
		public static function find(libraryName:String):CssLoader {
			var result:CssLoader;
			var fl:CssLoader;
			var i:uint;
			
			for (i = 0; i < CssLoader.libraries.length; i++) {
				fl = CssLoader.libraries[i];
				if (fl.name == libraryName) {
					result = fl;
					break;
				}
			}
			
			return result;
		}
		
		
	}
	
}