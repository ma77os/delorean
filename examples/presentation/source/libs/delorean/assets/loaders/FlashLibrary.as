package delorean.assets.loaders {
	import flash.display.MovieClip;
	
	
	/**
	 * FlashLibrary loads swf files and allows you to quickly access the library of this swf.
	 */
	public class FlashLibrary extends FileLoader {
		
		/// internal use.
		private static var libraries:Array = [];
		
		
		/**
		 * Constructor, creates a new Flashlibrary item.
		 * @param	global	<Boolean> If true the library will be global and can be found be the static method "find".
		 * @param	name	<String> Name of the object to be found later.
		 */
		public function FlashLibrary(global:Boolean, name:String = "") {
			
			name = (name && name.length) ? name : "FlashLibrary_" + FlashLibrary.libraries.length;
			super(name);
			
			if (global) {
				FlashLibrary.libraries.push(this);
			}
			
		}
		
		
		/**
		 * Takes a copy of a library item.
		 * @param	linkageName	<String> Class name of desired object.
		 * @return	<*> A new instance of the object.
		 */
		public function take(linkageName:String, root : MovieClip = null, ...args):* {
			var cls:Class;
			
			cls = this.takeClass(linkageName, root);
			
			if (args.length) {
				return (new cls(args));
			} else {
				return (new cls());
			}
			
		}
		
		
		/**
		 * Takes a library item.
		 * @param	linkageName	<String> Class name of desired object.
		 * @return	<*> A new instance of the object.
		 */
		public function takeClass(linkageName:String, root : MovieClip = null):* {
			var cls:Class;
			
			if (root) {
				cls = root.loaderInfo.applicationDomain.getDefinition(linkageName) as Class;
			} else {
				cls = this.loader.contentLoaderInfo.applicationDomain.getDefinition(linkageName) as Class;
			}
			
			
			return (cls);
		}
		
		
		
		/*--------------------------------------------------------------------------------------------
		 * 			STATIC
		--------------------------------------------------------------------------------------------*/
		
		
		/**
		 * Finds a library by its name.
		 * @param	libraryName	<String> The name of the library.
		 * @return	<FlashLibrary>	The FlashLibrary item with the informed name.
		 */
		public static function find(libraryName:String):FlashLibrary {
			var result:FlashLibrary;
			var fl:FlashLibrary;
			var i:uint;
			
			for (i = 0; i < FlashLibrary.libraries.length; i++) {
				fl = FlashLibrary.libraries[i];
				if (fl.name == libraryName) {
					result = fl;
					break;
				}
			}
			
			return result;
		}
		
	}
	
}