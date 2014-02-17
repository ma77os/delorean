package delorean.controls 
{
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public interface IItemList 
	{
		function set index (value:int):void;
		function get index ():int;
		function set data (value:Object):void;
		function get data ():Object;
		function set label (value:String):void;
		function get label ():String;
	}
	
}