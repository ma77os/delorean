package delorean.assets.loaders {
	
	
	/**
	 * Loads xml files.
	 */
	public class XmlLoader extends DataLoader {
		
		
		/**
		 * Constructor, creates a new XmlLoader instance.
		 * @param	name	<String, default null> Optional name of the loader.
		 */
		public function XmlLoader(name:* = null) {
			super(name);
		}
		
		
		/*--------------------------------------------------------------------------------------------
		 * 			GETTERS / SETTERS
		--------------------------------------------------------------------------------------------*/
		
		/**
		 * Gets the xml content (read-only).
		 */
		public function get xml():XML {
			return XML(this.data);
		}
		
		
	}
	
}