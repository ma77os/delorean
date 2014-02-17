package delorean.text {
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	/**
	 * ...
	 */
	public class MultiLineTextField extends TextField {
		
		public function MultiLineTextField(text:String, width:Number, format:TextFormat, embedFonts:Boolean = true, useAdvancedAntiAlias:Boolean = true, condenseWhite:Boolean = true) {
			
			super();
			
			this.embedFonts = embedFonts;
			this.multiline = true;
			if (width > 0){
				this.wordWrap = true;
				this.width = width;
			}
			this.selectable = false;
			this.mouseEnabled = false;
			this.condenseWhite = condenseWhite;
			this.antiAliasType = (useAdvancedAntiAlias) ? AntiAliasType.ADVANCED : AntiAliasType.NORMAL;
			this.defaultTextFormat = format;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.htmlText = text;
		}
		
	}
	
}