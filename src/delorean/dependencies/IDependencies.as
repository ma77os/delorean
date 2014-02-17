package delorean.dependencies 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public interface IDependencies extends IEventDispatcher
	{
		function add (id:String, url:String, type:String = "", fonts:String = "", totalBytes:Number = 0):void;
		function load ():void;
		function getContent(id:String):*;
		function dispose ():void;
	}
	
}