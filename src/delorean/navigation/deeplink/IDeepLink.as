package delorean.navigation.deeplink 
{
	import flash.events.IEventDispatcher;
	/**
	 * ...
	 * @author André Mattos - www.ma77os.com
	 */
	public interface IDeepLink extends IEventDispatcher
	{
		
		function go (id:*, dataParam:*= null):void;
		
		
	}

}