package delorean.text {
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	/**
	 * ...
	 */
	public class SingleLineTextField extends TextField {
		
		public function SingleLineTextField(htmlText:String, format:TextFormat, embedFonts:Boolean = true, useAdvancedAntiAlias:Boolean = true, condenseWhite:Boolean = true) {
			
			super();
			
			this.embedFonts = embedFonts;
			this.selectable = false;
			this.mouseEnabled = false;
			this.antiAliasType = (useAdvancedAntiAlias) ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
			this.defaultTextFormat = format;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.condenseWhite = true;
			this.htmlText = htmlText;
			
		}
		
	}
	
}