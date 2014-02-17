package delorean.utils
{
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 * ...
	 * @author Tiago Canzian
	 */
	public class TextFieldUtils {
		
		public static function clearOnFocus(field : TextField, defaultText : String = '', displayAsPassword : Boolean = false) : void {
			field.text = defaultText;
			field.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			field.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			
			function onFocusIn(ev : FocusEvent) : void {
				if (field.text == defaultText) field.text = '';
				field.displayAsPassword = displayAsPassword; 
			}
			
			function onFocusOut(ev : FocusEvent) : void {
				if (field.text == '') field.text = defaultText;
			}
		}
	}
}